#!/usr/bin/perl -Tw
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.


package CfgTie::TieUser;

=head1 NAME

CfgTie::TieUser -- an associative array of user names and ids to information

=head1 SYNOPSIS

makes the user database available as a regular hash

        tie %user,'CfgTie::TieUser'
        print "randym's full name: ", $user{'randym'}->{gcos}, "\n";

=head1 DESCRIPTION

This is a straight forward HASH tie that allows us to access the user database
sanely.

It cross ties with the groups packages and the mail packages

=head2 Ties

There are two ties available for programers:

=over 1

=item C<tie %user,'CfgTie::TieUser'>

C<$user{$name}> will return a HASH reference of the named user information

=item C<tie %user_id,'CfgTie::TieUser_id'>

C<$user_id{$id}> will return a HASH reference for the specified user.

=back

=head2 Structure of hash

Any given user entry has the following information assoicated with it (the
keys are case insensitive):

=over 1

=item C<Name>

Login name

=item C<GroupId>

=item C<Id>

The user id number that they have been assigned.  It is possible for many
different user names to given the same id.  However, changing the Id for
the user (ie, setting it to a new one), has one of two effects.  If
C<user'Chg_FS> is set 1, then all the files in the system owned by that id
will changed to the new id in addition to changing the id in the system table.
Otherwise, only the system table will be modified.


=item C<Quota>

=item C<Comment>

=item C<Home>

The users home folder

=item C<LOGIN_Last>

This is the information from the last time the user logged in.  It is an
array reference to data like:

        [$time, $line, $from_host]

=item C<Shell>

The users shell

=item C<AuthMethod>

The authentication method if other than the default

=item C<ExpireDate>

The date the account expires on

=item C<Inactive>

The number of days after a password expires.s...

=item C<Priority>

The scheduling priority for that user.

=back


Plus two (probably) obsolete fields:

=over 1

=item C<Password>

This is the encrypted password, but will probably be obsolete

=item C<GCOS>

I<General Electric Comprehensive Operating System> or
I<General Comprehensive Operating System>
field

This is now the users full name under many Unix's, incl. LINUX.

=back

Each of these entries can be modified (even deleted), and they will be
reflected into the overall system.  Additionally, the programmer can set any
other associated key, but this information will only available to running
PERL script.

=head2 Configuration Variables

=head2 Additional Routines

=over 1

=item C<&CfgTie::TieUser'status()>

=item C<&CfgTie::TieUser_id'status()>

Will return C<stat> information on the user database.

=back

=head2 Adding or overiding methods for user records

Lets say you wanted to change the default HTML handling to a different method.
To do this you need only include code like the following:

   package CfgTie::TieUser_rec;
   sub HTML($)
   {
      my $self=shift;
      "<h1>".$Self->{name}."</h1>\n".
      "<table border=0><tr><th align=right>\n".
        join("</td></tr>\n<tr><th align=right>",
          map {$_."</th><td>".$self->{$_}} (sort keys %{$self})
       </td></tr><lt></table>C<\n>";
   }

=head2 Miscellaneous

C<$CfgTie::TieUser_rec'usermod> contains the path to the program F<usermod>.
This can be modified as required.

C<$CfgTie::TieUser_rec'useradd> contains the path to the program F<useradd>.
This can be modified as required.

C<$CfgTie::TieUser_rec'userdel> contains the path to the program F<userdel>.
This can be modified as required.

Not all keys are supported on all systems.

This may transparently use a shadow tie in the future.

=head1 Files

F</etc/passwd>
F</etc/group>
F</etc/shadow>


=head1 See Also

L<Cfgfile>, L<CfgTie::TieAliases>, L<CfgTie::TieGeneric>, L<CfgTie::TieGroup>,
L<CfgTie::TieHost>, L<CfgTie::TieNamed>,   L<CfgTie::TieNet>,
L<CfgTie::TiePh>,   L<CfgTie::TieProto>,   L<CfgTie::TieServ>,
L<CfgTie::TieShadow>

L<group(5)>,
L<passwd(5)>,
L<shadow(5)>,
L<usermod(8)>,
L<useradd(8)>,
L<userdel(8)>

=head1 Cavaets

The current version does cache some user information

=head1 Author

Randall Maas (L<randym@acm.org>)

=cut

my $Chg_FS = 1; #By default we want to update the file system when the user
# Id changes

sub status
{
  # the information for the /etc/passwd file
  stat '/etc/passwd';
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
   setpwent;

   &NEXTKEY($self);
}

sub NEXTKEY
{
   my $self = shift;

   #Get the next user id in the database.
   # Get the information from the system and store it for later
   my @x = getpwent;
   if (! scalar @x) {return;}

   &CfgTie::TieUser_rec'TIEHASH(0,@x);
   return $x[0]; #Corresponds to the name
}

sub EXISTS
{
   my ($self,$name) = @_;
   my $lname =lc($name);
   if (exists $CfgTie::TieUser_rec'by_name{$lname}) {return 1;}

   # Get the information from the system and store it for later
   my @x = getpwnam $name;
   if (! scalar @x) {return 0;}

   $CfgTie::TieUser_rec'by_name{$lname} = CfgTie::TieUser_rec->new(@x);
   return 1;
}

sub FETCH
{
   my ($self, $name) = @_;

   if (!defined $name) {return;}

   my $lname = lc($name);

   #check out our cache first
   if (&EXISTS($self,$name)) {return $CfgTie::TieUser_rec'by_name{$lname};}
}

#Bug creating users is not supported yet.
sub STORE
{
   my ($self,$key,$val) = @_;
#   useradd or usermod, depending
}

#Bug need to consider how vigorously we delete things -r ? /var/mail/me, etc
sub DELETE
{
   my $self = shift;
   my $name = shift;

   #Basically delete the user now.
   system "$CfgTie::TieUser_rec'userdel $name";

   #Remove it from our cache
   if (exists $CfgTie::TieUser_rec'by_name{$name})
     {delete $CfgTie::TieUser_rec'by_name{$name};}
}

package CfgTie::TieUser_id;

sub status
{
  # the information for the /etc/passwd file
  stat '/etc/passwd';
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
   setpwent;

   &NEXTKEY($self);
}

sub NEXTKEY
{
   my $self = shift;

   #Get the next user id in the database.
   # Get the information from the system and store it for later
   my @x = getpwent;
   if (! scalar @x) {return;}

   &CfgTie::TieUser_rec'TIEHASH(0,@x);
   return $x[2]; #Corresponds to the id
}

sub EXISTS
{
   my ($self,$id) = @_;
   if (exists $CfgTie::TieUser_rec'by_id{$id}) {return 1;}

   # Get the information from the system and store it for later
   my @x = getpwuid $id;
   if (! scalar @x) {return 0;}

   $CfgTie::TieUser_rec'by_name{$x[0]} = CfgTie::TieUser_rec->new(@x);
   $CfgTie::TieUser_rec'by_id{$id} = $CfgTie::TieUser_rec'by_name{$x[0]};
   return 1;
}

sub FETCH
{
   my ($self,$id) = @_;

   #check out our cache first
   if (&EXISTS($self,$id)) {return $CfgTie::TieUser_rec'by_id{$id};}
}

#Bug creating users is not supported yet.
sub STORE
{
   my ($self,$key,$val) = @_;
#   useradd or usermod, depending
}

#Bug need to consider how vigorously we delete things -r ? /var/mail/me, etc
sub DELETE
{
   my ($self,$id) = @_;

   if (!exists $CfgTie::TieUser_rec'by_id{$id})
     {
        #Try to look up the user id
        &FETCH($self,$id);
     }
      
   if (exists $CfgTie::TieUser_rec'by_id{$id})
     {
        #Basically delete the user now.
        system "$CfgTie::TieUser_rec'userdel $CfgTie::TieUser_rec'by_id{$id}->{Name}";

        #Remove it from out cache
        delete $CfgTie::TieUser_rec'by_id{$id};
     }
}



package CfgTie::TieUser_rec;
# A package used by both user_id and user to retain record information about
# a person.  This is the only way to access usermod.

#Two hashes are used for look up
# $by_name{$name}
# $by_id{$id}

sub new {&TIEHASH(@_);}

sub TIEHASH
{
   # Ties a single user to a register...
   my ($self,$Name,@Rest) = @_;
   my $Node;
   my $lname = lc($Name);

   if (scalar @Rest)
     {
        ($Node->{password},$Node->{id},   $Node->{groupid},
         $Node->{quota}, $Node->{comment}, $Node->{gcos}, $Node->{home},
         $Node->{shell}) = @Rest;
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

#Modified from PERL Cookbook:
my $lastlog_fmt="L a16 A16"; #on sunos "L A8 A16"
sub lastlog_FETCH($)
{
   use User::pwent;
   use IO::Seekable qw(SEEK_SET);

   #SECURITY NOTE:
   #Change our real user id and group id to be whatever out user
   #id and group id really are
   my ($UID_save, $GID_save);
   ($UID_save,$>)=($>,$<);
   ($GID_save,$))=($(,$();

   my $LASTLOG=$Cfgfile'FNum++;
   if (!open(LASTLOG, "</var/log/lastlog")) {return;}

   my $User = shift;
   my $U = ($User =~ /^\d+$/) ? getpwuid($User) : getpwnam($User);
   my $R;
   if (!$U) {goto ret_from_here;}
   my $sizeof = length(pack($lastlog_fmt,()));
   if (seek(LASTLOG, $U->uid + $sizeof,SEEK_SET) &&
       read(LASTLOG, $buffer, $sizeof) == $sizeof)
     {
        #time line host
        $R = [unpack($lastlog_fmt, $buffer)];
     }

  ret_from_here:

   close LASTLOG;
   #SECURITY NOTE:
   #Restore real user id and group id to whatever they were before
   ($>,$))=($UID_save,$GID_save);

   $R;
}

sub scan_lasts
{
   #Get the last time the read their email
   #SECURITY NOTE:
   #Change our real user id and group id to be whatever out user
   #id and group id really are
   my ($UID_save, $GID_save);
   ($UID_save,$>)=($>,$<);
   ($GID_save,$))=($(,$();

   my $L = $Cfgfile'FNum++;
   open (L, "</var/log/maillog");
   while (<L>)
    {
       if(/([\d\w\s:]+)\s\w+\s\w+\[\d+\]:\sLogout\suser\s(\w+).*/)
           {$Last{lc($2)} = $1;}
     }

   close L;
   #SECURITY NOTE:
   #Restore real user id and group id to whatever they were before
   ($>,$))=($UID_save,$GID_save);

}

sub EXISTS
{
   my ($self,$key) = @_;
   my $lkey=lc($key);

      if ($lkey eq 'login_last' && !exists $self->{'login_last'})
        {
           my $R = lastlog_FETCH($self->{name});
           if (undef $R) {return 0;}
           $self->{'login_last'} = $R;
        }
   elsif ($lkey eq 'last' && !exists $self->{'last'})
     {
        #Try to recover it from our shadow, but avoid scanning the last
        #file if we can -- it takes a *long* time
        if (!exists $Last{lc($self->{name})} && !defined $scanned_last)
          {
             &scan_lasts();
             $scanned_last=1;
          }
        if (exists $Last{lc($self->{name})})
          {$self->{'last'} = $Last{lc($self->{name})};}
     }
   return exists $self->{$lkey};
}

sub FETCH
{
   my $self = shift;
   my $key = shift;
   my $lkey = lc($key);

   if ($lkey eq 'priority')
     {
        #Get the priority setting from the system
        return getpriority PRIO_USER,$self->{Node}->{Id};
     }
   elsif ($lkey eq 'last' && !exists $self->{$lkey}) {&EXISTS($self,$lkey);}

   if (exists $self->{$lkey}) {return $self->{$lkey};}
}

# Maps the changes to a particular setting to a flag on the command line
my $usermod_opt =
 {
   comment => '-c',
   home    => '-d',
   expire  => '-e',
   inactive=> '-f',
   name    => '-l',
   shell   => '-s',
   group1  => '-g',
   groups  => '-G',
   id      => '-u',
 };

my $usermod_opt2 =
 {
   id      => '-o',
 };

my $usermod = '/usr/sbin/usermod';  #Hard path to usermod
my $userdel = '/usr/sbin/userdel';  #Hard path to userdel

sub STORE
{
   # Changes a setting for the specified user... we basically call usermod
   my ($self,$key,$val) = @_;
   my $lkey = lc($key);

   if ($lkey eq 'groups')
     {
        #Handle the groups thing...

        #$val is a list reference....
        my ($i,@g) = @{$val};

        system "$usermod $self->{name} -g $i -G ". join(',', @g);
     }
   elsif ($lkey eq 'priority')
     {
        #Pass the priority setting onto the system
        setpriority(PRIO_USER,$self->{id},$val);
     }
   elsif (exists $usermod_opt->{$lkey})
     {
        #This is something for user mod!
        my ($FSUp, @FSet)=(0);

        if (defined $user'Chg_FS && $user'Chg_FS == 1 && $lkey eq 'id')
          {
             #We are supposed to change all of the files in the system to
             #have the new new one.
             #We have a race condition: someone else may change soemthing in
             #the file system, so we may not get everything, but we try to
             #be reasonable

             # Now we need to identify all of the files.. this may take a
             # long time
             @FSet= &filever'find_by_user ('/', $self->{id});

             if (defined @FSet && scalar @FSet) {$FSUp = 1;}
          }

        my $X = $usermod_opt2->{$lkey};
        if (!defined $X) {$X='';}

        #Change the system tables
        system "$usermod ".$usermod_opt->{$lkey}." $val $X ".$self->{name}.
                "\n";
        #If bad things should throw exception

        if ($FSUp) {chown $val,-1, @FSet;}

        $self->{$lkey} = $val;
     }
    else
     {
        #Extra setting that will be lost... 8(
        $self->{$lkey}=$val;
     }
}

sub DELETE
{
   #Deletes a user setting
   my ($self, $key) = @_;
   my $lkey=lc($key);

      if ($key eq 'authmethod')
        {
           system "$usermod -A DEFAULT ".$self->{name};
        }
   elsif (exists $usermod_opt->{$key})
        {
           #This is something for user mod!
           system "$usermod ".$usermod_opt->{$lkey}." ".$self->{name};
        }
   else
        {
           #Just remove our local copy
           delete $self->{$key};
        }
}

sub HTML($)
{
   # A routine to HTMLize the user
   my $self=shift;

   my %Keys2 = map {$_,1} (keys %{$self});
   $Keys2{'last'}=1;

   delete $Keys2{gcos};
   delete $Keys2{name};
   delete $Keys2{id};
   delete $Keys2{groupid};
   delete $Keys2{passwd};

   "<h1>".$self->{gcos}."</h1>\n".
   "<table border=0>".
     "<tr><th align=right>Full Name:</th><td>".$self->{gcos}."</td></tr>".
     "<tr><th align=right>login:</th><td>".$self->{name}."</td></tr>".
     "<tr><th align=right>Id:</th><td>".$self->{id}."</td></tr>".
     "<tr><th align=right>Group Id:</th><td>".$self->{groupid}."</td></tr>".
     "<tr><th align=right>".
   
    join("</td></tr>\n<tr><th align=right>",
           map {$_."</th><td>".$self->{$_}}
                (sort keys %Keys2)).
   "</td></tr></table>\n";
}
