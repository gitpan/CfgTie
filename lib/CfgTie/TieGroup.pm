#!/usr/bin/perl -Tw
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.

package CfgTie::TieGroup;
require CfgTie::filever;
require CfgTie::Cfgfile;

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

=item C<name>

=item C<id>

=item C<members>

A list reference to all of the users that are part of this group.

=item C<_members>

A list reference to all of the users that are explicitly listed in the
F</etc/group> file.

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

L<CfgTie::Cfgfile>,
L<CfgTie::TieAliases>, L<CfgTie::TieGeneric>, L<CfgTie::TieHost>,
L<CfgTie::TieNamed>,   L<CfgTie::TieNet>,     L<CfgTie::TiePh>,
L<CfgTie::TieProto>,   L<CfgTie::TieRCService>,
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
   if (!scalar @x) {return;}

   &CfgTie::TieGroup_rec'TIEHASH(0,@x);
   return $x[0]; #Corresponds to the name
}

sub EXISTS
{
   my ($self,$name) = @_;
   my $lname =lc($name);
   if (exists $CfgTie::TieGroup_rec'by_name{$lname}) {return 1;}

   # Get the information from the system and store it for later
   my @x = getgrnam $name;
   if (! scalar @x) {return 0;}

   $CfgTie::TieGroup_rec'by_name{$lname}=CfgTie::TieGroup_rec->new(@x);
   return 1;
}

sub FETCH
{
   my ($self, $name) = @_;
   if (!defined $name) {return undef;}
   my $lname = lc($name);

   #check out our cache first
   if (&EXISTS($self,$lname))
     {return $CfgTie::TieGroup_rec'by_name{$lname};}

   return undef;
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

   $CfgTie::TieGroup_rec'by_name{$x[0]} = CfgTie::TieGroup_rec->new(@x);
   $CfgTie::TieGroup_rec'by_id{$id} = $CfgTie::TieGroup_rec'by_name{$x[0]};

   return 1;
}

sub FETCH
{
   my ($self,$id) = @_;

   #check out our cache first
   if (&EXISTS($self,$id))
     {return $CfgTie::TieGroup_rec'by_id{$id};}

   return undef;
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

use CfgTie::TieUser;
my %Users;
tie %Users, 'CfgTie::TieUser';
sub uniq ($)
{
   my $L=shift;
   my @Ret=();
   my $J;
   foreach my $I (sort @{$L})
    {if (!defined $J || $J ne $I) {$J=$I; push @Ret,$I;}}
   \@Ret;
}

sub new {&TIEHASH(@_);}
sub TIEHASH
{
   # Ties a single group to a register...
   my ($self,$Name,@Rest) = @_;
   my $Node={};
   my $lname = lc($Name);

   if (scalar @Rest)
     {
        ($Node->{password},$Node->{id}, $Node->{_members})=@Rest;
     }

   if (defined $Name)    {$Node->{name}=$Name;}

   return bless $Node, $self;
}

sub FIRSTKEY
{
   my $self = shift;
   my $a = keys %{$self};
   return scalar each %{$self};
}

sub NEXTKEY
{
   my $self = shift;
   return scalar each %{$self};
}

sub EXISTS
{
   my ($self,$key) = @_;
   my $lkey=lc($key);
   if (exists $self->{$lkey}) {return 1;}

   if ($lkey eq 'members')
     {
	my @Mems=($self->{_members});
        foreach my $I (keys %Users)
	 {
	    if ($Users{$I}->{groupid} eq $self->{id}) {push @Mems, $I;}
	 }
	$self->{members}=uniq(\@Mems);
	return 1;
     }

   return 0;
}

sub FETCH
{
   my $self = shift;
   my $key = shift;
   my $lkey = lc($key);
   if (EXISTS($self,$lkey)) {return $self->{$lkey};}
   return undef;
}

# Maps the changes to a particular setting to a flag on the command line
$groupmod_opt =
 {
   name => '-n',
   id   => '-g',
 };

$groupmod = '/usr/sbin/groupmod';  #Hard path to groupmod
$groupdel = '/usr/sbin/groupdel';  #Hard path to groupdel

sub STORE
{
   # Changes a setting for the specified group... we basically call groupmod
   my ($self,$key,$val) = @_;
   my $lkey = lc($key);

   if ($lkey eq 'groups')
     {
        #Handle the groups thing...

        #$val is a list reference....
        my ($i,@g) = @{$val};

        system "$groupmod $self->{Name} -g $i -G ". join(',', @g);
     }
   if (exists $groupmod_opt{$lkey})
     {
        #This is something for group mod!
        system "$groupmod $groupmod_opt{$lkey} $val $self->{Name}";
     }
    else
     {
        #Extra setting that will be lost... 8(
        $self->{$lkey}=$val;
     }
}

sub DELETE
{
   #Deletes a group setting
   my ($self, $key) = @_;
   my $lkey=lc($key);

      if ($lkey eq 'authmethod')
        {
           system "$groupmod -A DEFAULT $self->{name}";
        }
   elsif (exists $groupmod_opt->{$lkey})
        {
           #This is something for group mod!
           system "$groupmod $self->{name} $groupmod_opt->{$lkey}";
        }
   else
        {
           #Just remove our local copy
           delete $self->{$lkey};
        }
}


sub HTML($)
{
   # A routine to HTMLize the user
   my $self=shift;

   my %Keys2 = map {$_,1} (keys %{$self});

   delete $Keys2{name};
   delete $Keys2{id};
   delete $Keys2{password};
   delete $Keys2{members};

   "<h1>".$self->{gcos}."</h1>\n".
   "<table border=0>".
     "<tr><th align=right>Name:</th><td>".$self->{name}."</td></tr>".
     "<tr><th align=right>Id:</th><td>".$self->{id}."</td></tr>".
     "<tr><th align=right>Members:</th><td>".join(', ',@{$self->{members}}).
		"</td></tr>".
     "<tr><th align=right>".
   
    join("</td></tr>\n<tr><th align=right>",
           map {$_."</th><td>".$self->{$_}}
                (sort keys %Keys2)).
   "</td></tr></table>\n";
}

