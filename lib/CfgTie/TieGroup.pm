#!/usr/bin/perl -Tw
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.

package CfgTie::TieGroup;

=head1 NAME

CfgTie::TieGroup -- an associative array of group names and ids to information

=head1 SYNOPSIS

Makes the groups database available as regular hash

        tie %group,'CfgTie::TieGroup'
        $group{'myfriends'}=['jonj', @{$group{'myfriends'}];

=head1 DESCRIPTION

This is a straight forward HASH tie that allows us to access the user group
database sanely.

It cross ties with the user package and the mail packages

=head2 Ties

There are two ties available for programers:

=over 1

=item C<tie %group,'CfgTie::TieGroup'>

C<$group{$name}> will return a HASH reference of the named group information

=item C<tie %group_id,'CfgTie::Group_id'>

C<$group_id{$id}> will return a HASH reference for the specified group.

=back

=head2 Structure of hash

Any given group entry has the following information assoicated with it:

=over 1

=item C<Name>

=item C<Id>

=item C<Members>

A list reference of the users...

=back


Plus an (probably) obsolete fields:

=over 1

=item C<Password>

This is the encrypted password, but will probably be obsolete

=back

Each of these entries can be modified (even deleted), and they will be
reflected into the overall system.  Additionally, the programmer can set any
other associated key, but this information will only available to running
PERL script.

=head2 Additional Routines

=over 1

=item C<&CfgTie:TieGroup'status()>

=item C<&CfgTie::TieGroup_id'status()>

Will return C<stat> information on the group database.

=back

=head2 Miscellaneous

C<$CfgTie::TieGroup_rec'groupmod> contains the path to the program F<groupmod>.
This can be modified as required.

C<$CfgTie::TieGroup_rec'groupadd> contains the path to the program F<groupadd>.
This can be modified as required.

C<$CfgTie::TieGroup_rec'groupdel> contains the path to the program F<groupdel>.
This can be modified as required.

=head1 Files

F</etc/passwd>
F</etc/group>
F</etc/gshadow>
F</etc/shadow>


=head1 See Also

L<Cfgfile>, L<RCService>,
L<CfgTie::TieAliases>, L<CfgTie::TieGeneric>, L<CfgTie::TieHost>,
L<CfgTie::TieNamed>, L<CfgTie::TieNet>, L<CfgTie::TiePh>, L<CfgTie::TieProto>,
L<CfgTie::TieServ>, L<CfgTie::TieShadow>, L<CfgTie::TieUser>

L<group(5)>,
L<passwd(5)>,
L<shadow(5)>,
L<groupmod(8)>,
L<groupadd(8)>,
L<groupdel(8)>

=head1 Cavaets

The current version does cache some group information

=head1 Author

Randall Maas (L<randym@acm.org>)

=cut

sub status
{
  # the information for the /etc/group file
  stat '/etc/group';
}

sub TIEHASH
{
   my $self = shift;
   my $node = {};
   return bless $node, $self;
}

sub FIRSTKEY
{
   my $self = shift;

   #Rewind outselves to the beginning.
   setgrent;

   &NEXTKEY($self);
}

sub NEXTKEY
{
   my $self = shift;

   #Get the next group id in the database.
   # Get the information from the system and store it for later
   my @x = getgrent;
   if (! scalar @x) {return;}

   &CfgTie::TieGroup_rec'TIEHASH(0,@x);
   return $x[0]; #Corresponds to the name
}

sub EXISTS
{
   my ($self,$name) = @_;
   if (exists $CfgTie::TieGroup_rec'by_name{$name}) {return 1;}

   # Get the information from the system and store it for later
   my @x = getgrnam $name;
   if (! scalar @x) {return 0;}

   &CfgTie::TieGroup_rec'TIEHASH(0,@x);
   return 1;
}

sub FETCH
{
   my ($self, $name) = @_;

   #check out our cache first
   if (exists $CfgTie::TieGroup_rec'by_name{$name})
     {return $CfgTie::TieGroup_rec'by_name{$name};}

   my %X;
   tie %X, 'CfgTie::TieGroup_rec', getgrnam $name;
   return bless %X;
}

#Bug creating groups is not supported yet.
sub STORE
{
   my ($self,$key,$val) = @_;
#   groupadd or groupmod, depending
}

#Bug need to consider how vigorously we delete things -r ? /var/mail/me, etc
sub DELETE
{
   my $self = shift;
   my $name = shift;

   #Basically delete the group now.
   system "$CfgTie::TieGroup_rec'groupdel $name";

   #Remove it from our cache
   if (exists $CfgTie::TieGroup_rec'by_name{$name})
     {delete $CfgTie::TieGroup_rec'by_name{$name};}
}

package CfgTie::TieGroup_id;

sub status
{
  # the information for the /etc/group file
  stat '/etc/group';
}


sub TIEHASH
{
   my $self = shift;
   my $node = {};
   return bless $node, $self;
}

sub FIRSTKEY
{
   my $self = shift;

   #Rewind outselves to the beginning.
   setgrent;

   &NEXTKEY($self);
}

sub NEXTKEY
{
   my $self = shift;

   #Get the next group id in the database.
   # Get the information from the system and store it for later
   my @x = getgrent;
   if (! scalar @x) {return;}

   &CfgTie::TieGroup_rec'TIEHASH(0,@x);
   return $x[2]; #Corresponds to the id
}

sub EXISTS
{
   my ($self,$id) = @_;
   if (!defined $id) {return 0;}

   if (exists $CfgTie::TieGroup_rec'by_id{$id}) {return 1;}

   # Get the information from the system and store it for later
   my @x = getgrgid $id;
   if (! scalar @x) {return 0;}

   my %X;
   tie %X, 'CfgTie::TieGroup_rec', @x;

   return 1;
}

sub FETCH
{
   my ($self,$id) = @_;

   if (!defined $id) {return;}

   if (!&EXISTS($self,$id)) {return;}

   #check out our cache first
   if (exists $CfgTie::TieGroup_rec'by_id{$id})
     {return $CfgTie::TieGroup_rec'by_id{$id};}

   return;
}

#Bug creating groups is not supported yet.
sub STORE
{
   my ($self,$key,$val) = @_;
#   groupadd or groupmod, depending
}

#Bug need to consider how vigorously we delete things -r ? /var/mail/me, etc
sub DELETE
{
   my ($self,$id) = @_;

   if (!exists $CfgTie::TieGroup_rec'by_id{$id})
     {
        #Try to look up the group id
        &FETCH($self,$id);
     }
      
   if (exists $CfgTie::TieGroup_rec'by_id{$id})
     {
        #Basically delete the group now.
        system "$CfgTie::TieGroup_rec'groupdel $CfgTie::TieGroup_rec'by_id{$id}->{Name}";

        #Remove it from out cache
        delete $CfgTie::TieGroup_rec'by_id{$id};
     }
}



package CfgTie::TieGroup_rec;
# A package used by both group_id and group to retain record information about
# a person.  This is the only way to access groupmod.

#Two hashes are used for look up
# $by_name{$name}
# $by_id{$id}

sub TIEHASH
{
   # Ties a single group to a register...
   my ($self,$Name,@Rest) = @_;
   my $Node;

   if (exists $by_name{$Name})
     {
        #Just update our record...
        $Node = $by_name{$Name};
     }
#    else  create it
       
   $Node->{Name}=$Name;
   ($Node->{Password}, $Node->{Id}, $Node->{Members}) = @Rest;

   $by_name{$Name} = $Node;
   $by_id{$Node->{Id}} = $Node;

   return bless $Node, $self;
}

sub FIRSTKEY
{
   my $self = shift;
   my $a = keys %self;
   return scalar each %self;
}

sub NEXTKEY
{
   my $self = shift;
   return scalar each %self;
}

sub EXISTS
{
   my ($self,$key) = @_;
   return exists $self{$key};
}

sub FETCH
{
   my $self = shift;
   my $key = shift;

   if (exists $self{$key}) {return $self{$key};}
}

# Maps the changes to a particular setting to a flag on the command line
$groupmod_opt =
 {
   Name => '-n',
   Id   => '-g',
 };

$groupmod = '/usr/sbin/groupmod';  #Hard path to groupmod
$groupdel = '/usr/sbin/groupdel';  #Hard path to groupdel

sub STORE
{
   # Changes a setting for the specified group... we basically call groupmod
   my ($self,$key,$val) = @_;

   if ($key eq 'Groups')
     {
        #Handle the groups thing...

        #$val is a list reference....
        my ($i,@g) = @{$val};

        system "$groupmod $self->{Name} -g $i -G ". join(',', @g);
     }
   if (exists $groupmod_opt{$key})
     {
        #This is something for group mod!
        system "$groupmod $groupmod_opt{$key} $val $self->{Name}";
     }
    else
     {
        #Extra setting that will be lost... 8(
        $self{$key}=$val;
     }
}

sub DELETE
{
   #Deletes a group setting
   my ($self, $key) = @_;

      if ($key eq 'AuthMethod')
        {
           system "$groupmod -A DEFAULT $self->{Name}";
        }
   elsif (exists $groupmod_opt{$key})
        {
           #This is something for group mod!
           system "$groupmod $self->{Name} $groupmod_opt{$key}";
        }
   else
        {
           #Just remove our local copy
           delete $self{$key};
        }
}


