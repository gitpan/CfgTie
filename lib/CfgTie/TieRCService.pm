#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.


package CfgTie::TieRCService;

=head1 NAME

CfgTie::TieRCService -- A module to manage UNIX services

=head1 SYNOPSIS

This is a straight forward interface to the control scripts in @file{/etc/rc?.d}

=head1 DESCRIPTION

This manages the system services, atleast those the live in the F</etc/rc?.d>
folders.  

=head2 Method

C<new($service_name,$path)> I<path> is optional, and may refer either to the
folder containing the relevant control script, or may refer to the control
script itself.

C<start>  will start the service (if not already started).  Example:
C<$Obj->E<gt>C<start();>

C<stop> will stop the service (if running).  Example: C<$Obj->E<gt>C<stop();>

C<restart> will restart the service, effectively stopping it (if it is
running) and then starting it.  Example: C<$Obj->E<gt>C<restart();>

C<status>

C<reload>


=cut

# Still need a tiehash, ability to add it to a run level, change its order
# in the runlevel, remove it from the runlevel


sub proc_id($)
{
   my $key = shift;
   my $pid;

   if (-e "/var/run/$key.pid")
     {
        #use the canonically process ID
        my $F = $FNum++;
        open F, "</var/run/$key.pid";
        <F>;
        /(\d+)/; $pid=$1;
        close F;

        return $pid;
     }
}

sub proc_sig($$)
{
   my $pid = proc_id shift;

   if (defined $pid)
     {
        kill shift, $pid;
        return 1;
     }
    return -1;
}

my %ServScript;

sub scan_for_script($$)
{
   my ($serv, $path) = @_;
   $FNum++;
   opendir FNum, $path;
   my @RCfiles = grep {/^...$serv$/} (readdir(FNum));
   closedir FNum;
   if (!scalar @RCfiles) {return;}
   my ($R) = @RCfiles;
   $R;
}

sub new
{
   my ($self,$serv,$path) = @_;
   my $node = { Service => $serv,};

   if (!defined $serv) {return bless $node, $self;}
   if (defined $path)
     {
        #if the path is bad, just let it be there, but invalid..
        #Or if it points to a real file...
        if (!-e $path || !-d $path)
          {
             #The user specified a file; take the user at his word
             $node->{Path}=$path;
             return bless $node, $self;
          }

        if (-e "$path/$serv")
          {
             $node->{Path}="$path/$serv";
             return bless $node, $self;
          }

        if (-e "$path$serv")
          {
             $node->{Path}="$path$serv";
             return bless $node, $self;
          }

        my $R = scan_for_script $serv, $path;
        if (defined $R) {$node->{Path}=$R;}

        return bless $node, $self;
     }

   if (!exists $ServScript{$serv})
     {
        if (-e "/etc/rc.d/init.d/$serv")
          {$ServScript{$serv} = "/etc/rc.d/init.d/$serv";}
         else
          {
             my $RCBase;
                if (-d "/etc/rc2.d/")
                  {$RCBase = "/etc/rc2.d/";}
             elsif (-d "/etc/rc.d/rc2.d")
                  {$RCBase = "/etc/rc.d/rc2.d/";}
             else {return bless $node, $self;}

             my $R = scan_for_script $serv, $RCBase;
             if ($R) {$ServScript{$serv} = $R;}
          }
      }

   if (exists $ServScript{$serv}) {$node->{Path} = $ServScript{$serv};}
   return bless $node,$self;
}

BEGIN
{
   #basically create the various verbs... 
   my $X="package iservice;\n";

   foreach my $I ('start','stop','restart','status')
    {
       $X.= "sub $I(\$)\n{\n".
            "   my \$self = shift;\n".
            "   if (exists \$self->{Path})\n".
            "     {return system(\$self->{Path}.\" $I\");}\n".
            "}\n\n";
    }
   eval $X;
}

sub reload($)
{
   my $self=shift;
   if (-x "/usr/sbin/".$self->{Service}.".reload")
     {
        return system("/usr/sbin/".$self->{Service}.".reload");
     }
    else
     {
        #Get its pid
        if (proc_sig($self->{Service}, 'HUP') == -1)
          {
             restart $self;
          }
     }
}
1;
