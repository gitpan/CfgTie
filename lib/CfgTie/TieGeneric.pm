#!/usr/bin/perl -w
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.

package CfgTie::TieGeneric;

=head1 NAME

CfgTie::TieGeneric -- A generic hash that automatically binds others

=head1 SYNOPSIS

This is an associative array that automatially ties other configuration hashes

=head1 DESCRIPTION

This is a tie to brings other ties together autmomatically so you, the busy
programmer and/or system administrator, don't have to.  The related PERL
module is not loaded unless it is needed at run-time.

        my %gen;
        tie %gen, 'CfgTie::TieGeneric';

=head2 Primary, or well-known, keys

=over 1

=item C<env>

This refers directly to the C<ENV> hash.

=item C<group>

=item C<mail>

This is a special key.  It forms a hash, with subkeys... see below for more
information

=item C<net>

This is a special key.  It forms a hash, with additional subkeys. See
below for more details.

=item C<user>

This employs the 
This is actually a well-known variant of the default.

=item I<Composite>

Composite primary keys are just like absolute file paths.  For example, if
you wanted to do something like

        my %lusers = $gen{'user'};
        my $Favorite_User = $lusers{'mygirl'};

You could just,

        my $Favorite_User = $gen{'/users/mygirl'};

=item others...

These are the things automatically included in.  This will be described below.

=back

=head2 Subkeys for C<mail>

=over 1

=item C<aliases>

L<CfgTie::TieAliases> 

=back

=head2 Subkeys for C<net>

=over 1

=item C<host>

L<CfgTie::TieHost>

=item C<service>

L<CfgTie::TieServ>

=item C<protocol>

L<CfgTie::TieProto>

=item C<addr>

L<CfgTie::TieNet>

=back

=head2 How other ties are automatically bound

Other keys are automatically -- if it all possible -- brought in using the
following procedure:

=over 1

=item 1. If it is something already linked it, that thingy is automatically
returned (of course).

=item 2. If the key is simple, like F<AABot>, we will try to C<use AABot;>
If that works we will tie it and return the results.

=item 3. If the key is more complex, like F</OS3/Config>, we will try to see
if C<OS3> is already tied (and try to tie it, like above, if not).  If that
works, we will just lookup C<Config> in that hash.  If it does not work, we
will try to C<use> and C<tie> C<OS3::Config>, C<OS3::TieConfig>, and
C<OS3::ConfigTie>.  If any of those work, we return the results.

=item 4. Otherwise, C<undef> will be returned.

=back


=head1 See Also

L<CfgTie::TieAliases>, L<CfgTie::TieGroup>,
L<CfgTie::TieHost>, L<CfgTie::TieNamed>,  L<CfgTie::TieNet>,
L<CfgTie::TiePh>,   L<CfgTie::TieProto>,  L<CfgTie::TieRCService>,
L<CfgTie::TieServ>, L<CfgTie::TieShadow>, L<CfgTie::TieUser>

=head1 Author

Randall Maas (L<randym@acm.org>)

=cut

# These are the builti-ins that we always add to the global arena...

# This forms the abstract tie for the net sub-hash
my $net_builtins ={host=>['CfgTie::TieHost'],
      service=>['CfgTie::TieServ'],
      protocol=>['CfgTie::TieProto'],
      addr    =>['CfgTie::TieNet']
    };

# This forms the abstract tie for the mail sub-hash
my $mail_builtins={aliases=>['CfgTie::TieAliases']};

my $builtins =
     {
        user => ['CfgTie::TieUser'],
        group =>['CfgTie::TieGroup'],
#        env =>  \%main'ENV,
        mail => ['CfgTie::TieGeneric_worker', $net_builtins],
        net =>  ['CfgTie::TieGeneric_worker', $mail_builtins], 
     };

use CfgTie::TieGroup;
use CfgTie::TieServ;
use CfgTie::TieProto;
use CfgTie::TieNet;
use CfgTie::TieHost;
@ISA=qw(CfgTie::TieGroup CfgTie::TieServ  CfgTie::TieProto
	CfgTie::TieNet  CfgTie::TieHost);

sub TIEHASH
{
   my $self =shift;
   my $ref = CfgTie::TieGeneric_worker->new($builtins, @_);
   return bless {delegate => $ref}, $self;

}

my $Node_Separator = '/';

sub EXISTS
{
   my ($self,$key)=@_;
   #if the $key has a separator in it, check the cache.
   if (exists $self->{Cache}->{$key})   {return 1;}
   if ($self->{delegate}->EXISTS($key)) {return 1;}

   #recursively try to find it...
   my ($LeftKey, $RightKey);
   if ($key =~ /^(.*)\/([^\/]+)$/)
     {$LeftKey=$1; $RightKey=$2;}
    else
     {return 0;}
   if (!&EXISTS($self, $LeftKey)) {return 0;}

   # stick it in the quick look up cache
   my $X = &FETCH($self, $LeftKey);
   $self->{Cache}->{$key} = $X->{$RightKey};
   return 1;
}

sub FETCH
{
   my ($self,$key)=@_;
   if (!EXISTS($self,$key)) {return;}
   return $self->{Cache}->{$key} if exists $self->{Cache}->{$key};
   return $self->{delegate}->FETCH($key);
}

# from p325
sub AUTOLOAD
{
   my $self=shift;
   return if $AUTOLOAD =~ /::DESTROY$/;

   #Strip the package name
   $AUTOLOAD =~ s/^CfgTie::TieGeneric:://;

   #Pass the message along
   $self->{delegate}->$AUTOLOAD(@_);
}

package CfgTie::TieGeneric_worker;

sub new
{
   my $self=shift;
   my $node = {builtins => shift};
   return bless $node, $self;
}

sub EXISTS
{
   my ($self, $key) = @_;

   if (!defined $key) {return 0;}

   # Check to see if it is already mapped in, and overrides ours
   if (exists $self->{Contents}->{$key}) {return 1;}

   #At this point, it is not mapped in.

   #Try to automagically add it in..
   #First try to use a builtin if possible
   if (exists $self->{builtins}->{$key})
     {
        my ($A,$B) = @{$self->{builtins}->{$key}};

        #load the perl module
        eval "use $A";

        #Tie in the key
	if (!defined $B) {$B=$A;}
        tie %{$self->{Contents}->{$key}}, $B;

        return 1;
     }

   #Finally try to mount the thingy
   eval "use $key";
   tie %{$self->{Contents}->{$key}}, $key;
}


sub FETCH
{
   my ($self,$key) = @_;

   #Try to preload things, and return if we can't
   if (!&EXISTS($self,$key)) {return;}

   #Try to get the local thing first
   if (exists $self->{Contents}->{$key}) {return $self->{Contents}->{$key};}

   return undef;
}

sub FIRSTKEY
{
   my $self = shift;
   my $a = keys %{$self->{Contents}};

   my $b = scalar each %{$self->{Contents}};
   if ($b) {return $b;}

   #Scan thru the builtins
   my $c = keys %{$self->{builtins}};
   return scalar each %{$self->{builtins}};
}

sub NEXTKEY
{
   my $self = shift;
   my $lastkey=shift;
   my $a = scalar each %{$self->{Contents}};
   if ($a) {return $a;}

   if (exists $self->{Contents}->{$lastkey})
     {
        #Prime it with a psuedo FIRSTKEY
        my $b = keys %{$self->{builtins}};
     }

   while (($a) = each %{$self->{builtins}})
    {
       if (!exists $self->{Contents}->{$a})
         {return $a;}
    }
   return $a;
}

