#!/usr/bin/perl -w
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.

package CfgTie::Cfgfile;
use strict 'refs';
use filever;

=head1 NAME

CfgTie::Cfgfile -- A module to help interface to configuration files

=head1 SYNOPSIS

Helps interface to text based configuration files commonly used in UNIX

=head1 DESCRIPTION

This is a fairly generic interface to allow many configuration files to be
used a hash ties.  I<Note: This is not intended to be called by user programs,
but by modules wishing to reuse a template structure!>

   package mytie;
   require CfgTie::Cfgfile;
   require Tie::Hash;

   @ISA = qw(Tie:Hash);

   sub TIEHASH
   {
      my $self = shift;
      my $Node = {};
      my $Obj =  bless $Node, $self;
      $Node->{delegate} = CfgTie::Cfgfile->new($Obj,@_);
      $Obj;
   }

=over 1

=item my_package_name

This refers to the package which will parse and interpret the configuration
file.  More information on this can be found below.

=item filepath

I<optional>.  If defined this is the path to the configuration file to be
opened.  If not defined, the default for the specified package will be used.

=item RCS-Object

I<optional>.  If defined, this is an RCS object (or similar)  that will control
how to check-in and check-out the configuration file.  See RCS perl module for
more details on how to create this object (do not use the same instance for
each configuration file!).  Files will be checked back in when the C<END>
routine is called.  If a C<filepath> is specified, it will override the one
previously set with the RCS object.  If no C<filepath> is specified, but the
RCS has one specified, it will be used instead.

=back

=head2 The I<Obj> object

The Object may need to provide the following methods:

=over 1

=item C<scan>

This is called when the file is first tied in.  It should scan the file,
placing the associated contents into the C<{Contents}> key.

=item C<format>(I<key>,I<contents>)

This formats a single entry to be stored in a file.  This is used for when a
value can be stored simply.

=item C<cfg_begin>

If this method is defined, it is called just before the configuration file
will be modified.

=item C<cfg_end>

If this method is defined, it is called after the configuration file has
changed.  It can be used, for instances, to rebuild a binary database, restart
a service, or email martians.

=item C<makerewrites>

This is called just before the configuration file will be rewritten.  It
should return a reference to a function that is used to transform the current
control file into the new one.  This is transforming function is called
foreach line in the configuration file while it is being
rewritten. 

=back

=head2 Object methods you can use

C<Comment_Add> This appends the string to the list of comments that will be
logged for this revision (assuming that a Revision Control object was used).

C<Queue_Store($key,$val)> This queues (for later) the transaction that
I<key> should be associated with I<val>.  The queue is employed to synchronize
all of the settings with the stored settings on disk.

C<Queue_Delete($key)> This queues (for later) the transaction that any value
associated with I<key> should be removed.

C<RENAME(\%rules)> This method will move through the whole table and make a
series of changes.  It may:

=over 1

=item Remove some entries, based upon their keys

=item Rename the keys from some entries

=item Change the contents of the keys, possibly removing portions

=back

C<\%rules> is the set of rules that governs will be changed in name and what
will be removed.  It is an associative array (hash) of a form like:

	{
	    PATTERN1 => "",
	    PATTERN2 => REWRITE,
	}


C<PATTERN1 = >
Two things will happen with a rule like this:

=over 1

=item Every key in the table that matches the pattern will be removed

=item Any element (of an entry) that matches the pattern will be removed

=back

C<PATTERN2 = REWRITE>
In this case the rewrite indicates what should replace the pattern:

=over 1

=item

Every key that matches the pattern will be rewritten and replace with a
new key

=item

Any element (of an entry) that matches the pattern will be modified to
match the rewrite rule.

=back


=head1 See Also

L<RCService> L<CfgTie::TieAliases>, L<CfgTie::TieGeneric>,
L<CfgTie::TieGroup>, L<CfgTie::TieHost>, L<CfgTie::TieNamed>,
L<CfgTie::TieNet>, L<CfgTie::TiePh>, L<CfgTie::TieProto>, L<CfgTie::TieServ>,
L<CfgTie::TieShadow>, L<CfgTie::TieUser>

I<p321>

=head1 Cavaets

Additions that do not change any previously established values are reflected
immediately (and F<newaliases> is run as appropriate).  Anything which changes
a previously established value, regardless of whether or not it has been
committe, are queue'd for later.  This queue is used to rewrite the file when
C<END> is executed.

=head1 Author

Randall Maas (L<randym@acm.org>)

=cut

my $FNum=137;
my %Files2CheckIn;
my @Thingies; 1;

sub RCS_Handshake($)
{
   my $self=shift;
   if (!exists $self->{RCS}) {return;}

   my $RObj = $self->{RCS};
   if (defined $RObj->comments)
     {
        my $locker = $RObj->lock;

        #Do we need to check it out?
        if (defined $locker) {return;}
   
        #Check it out with the locks set
        $RObj->co('-l');
     }

   #Add it to the list of things to check in
   $Files2CheckIn{$self->{Object}->{Path}} = $RObj;
}

sub END
{
   #This takes the current set of outstanding ties and rewrites the files
   foreach my $I (@Thingies)
    {
       #Skip it if there is nothing to do.
       if (!exists $I->{Object}) {next;}
        my $J = $I->{Object};
       if (!exists $J->{Queue} ||
           !scalar keys %{$J->{Queue}}) {next;}

       my $rewrite;
       #Build up rewrite rules:
       eval '$rewrite = $J->makerewrites($I);';
       if ($@)
         {
            #There was an error with the rewrite thing, skip this
            warn $@;
            next;
         }

       if (!defined $J->{Path}) {next;}
       if (!scalar keys %{$J->{Contents}}) {next;}
       if (-e $J->{Path} && !defined $J->{Queue}) {next;}

       my $FOut= $Cfgfile'FNum++;

       #Announce that we will begin making changes
       eval '$J->cfg_begin(\$I);';

       #Check with the revision control system
       &RCS_Handshake($I);

       #SECURITY NOTE:
       #Change our real user id and group id to be whatever out user
       #id and group id really are
       my ($UID_save, $GID_save);
       ($UID_save,$>)=($>,$<);
       ($GID_save,$))=($(,$();
       my($Base,$NewFileName);
       if ($J->{Path}=~/^([^\s]+)/ && $1 && length $1)
         {$Base=$1; $NewFileName = "$1,new";}
	else
	 {next;}

       if (-e $J->{Path})
         {
            #Next rewrite file...
            # Do the file rewrite
            my $FIn = $Cfgfile'FNum++;

            open FIn,"<$Base" or die "Could not open file ($Base) for reading: $!\n";
            open FOut,">$NewFileName" or die "Could not open the temporary output file ($NewFileName): $!\n";
            my $S=[];
            while (<FIn>)
             {
                 my $L = &$rewrite($_,$S);
                if (defined $L) {print FOut $L;}
             }
            close FIn;
         }
        else
         {
            if (defined $I->{RCS})
              {$Files2CheckIn{$Base} = $I->{RCS};}
            open FOut,">$Base";
            foreach my $k (keys %{$J->{Contents}})
             {
                my $x=$J->{Contents}->{$k};
                print FOut eval '$J->format($k,$x)';
                print FOut "\n";
             }
         }

       close FOut;

       #SECURITY NOTE:
       #Restore real user id and group id to whatever they were before
       ($>,$))=($UID_save,$GID_save);

       #Swap the file
       if (-e $NewFileName)
         {
            #Rotate the file in
            &filever'Rotate($Base,$NewFileName);
         }

       #Announce that we are done making changes
       eval '$J->cfg_end($I);';
    }

   #Check in each of the files that need to be
   foreach my $I (keys %Files2CheckIn)
    {
       my $Obj =$Files2CheckIn{$I};
       my $Cmt;
       if (exists $Obj->{Comments})
         {
            $Cmt = $Obj->{Comments};
            $Cmt =~ s/\n/ /g;
         }
        else
         {$Cmt="Settings changed through the PERL-based envmgr";}
       my @Args = ('-u',"-m$Cmt");
       #Check to see if we need an initial description.
       if (!defined $Obj->comments) {@Args=(@Args, '-t-');}
       print "Checkin' in\n";
       $Obj->ci(@Args);
    }
   %Files2CheckIn=();
}

sub new {TIEHASH(@_);}
sub TIEHASH
{
   my ($self,$Obj,$x,@Extra)=@_;
   my $RCSObj=undef;
   my $Node={};

   if (defined $x)
     {
           if (ref    $x) {$RCSObj = $x;}
        elsif (length $x) {$Obj->{Path} = $x;}
     }

   if (defined $RCSObj)
     {
        $Node->{RCS} = $RCSObj;
        if (defined $RCSObj->file && length $RCSObj->file)
          {
            $Obj->{Path}=$RCSObj->workdir.'/'.$RCSObj->file;
            if (defined $RCSObj->comments && !defined $RCSObj->lock)
              {
                $RCSObj->co();
              }
          }
     }

   $Node->{Object} = $Obj;
   no strict 'refs';
   $Obj->scan($Node,@Extra);
   push @Thingies, $Node;
   if (exists $Obj->{Path} && defined $RCSObj && !defined $RCSObj->file)
     {
        &filever'RCS_path($RCSObj, $Obj->{Path});
     }

   return bless $Node, $self;
}

sub FIRSTKEY
{
   my $self = shift;
   my $a = keys %{$self->{Contents}};
   return scalar each %{$self->{Contents}};
}

sub NEXTKEY
{
   my $self = shift;
   return scalar each %{$self->{Contents}};
}

sub EXISTS
{
   my ($self,$key) = @_;
   return exists $self->{Contents}->{$key};
}

sub FETCH
{
   my ($self,$key)=@_;
   return $self->{Contents}->{$key};
}

sub Queue_Delete($$)
{
   my ($self,$key) = @_;

#   print "Queuing a delete for $key\n";

   #If there is a value it is supposed to be associated with, remove it, and
   #queue it for later
   $self->{Queue}->{$key} ='';
}

sub Queue_Store($$$)
{
   my ($self,$key,$val) = @_;

   #If there is a value it is supposed to be associated with, override it, and
   #queue it for later
   $self->{Queue}->{$key} = $val;
}

sub DELETE
{
   my ($self,$key)=@_;
   #Queue this for later.

   #Remove it from our current set of values
   if (exists $self->{Contents}->{$key}) {delete $self->{Contents}->{$key};}

   Queue_Delete($self, $key);
}

sub STORE_cheap($$)
{
   my ($self,$val) = @_;
   #if we add something, and it is not in the DB, we have it easy...
   #we just append it to the end of the file and run newaliases
   #It is not completely cheap since we run new aliases...

   #Do the append
   my $F=$Cfgfile'FNum++;

   if (exists $self->{Object})
    {eval '$self->{Object}->cfg_begin();';}

   #Check with the revision control system
   &RCS_Handshake($self);

   #SECURITY NOTE:
   #Change our real user id and group id to be whatever out user
   #id and group id really are
   my ($UID_save, $GID_save);
   ($UID_save,$>)=($>,$<);
   ($GID_save,$))=($(,$();

   open F,">>$self->{Object}->{Path}" or die "Could not append: $!\n";
   print F $val;
   close F;

   #SECURITY NOTE:
   #Restore real user id and group id to whatever they were before
   ($>,$))=($UID_save,$GID_save);

   if (exists $self->{Object})
    {eval '$self->{Object}->cfg_end();';}
}

sub STORE
{
   my ($self,$key,$val) = @_;

   if (!defined $key) {warn "trying to store data without key:$!\n";return;}

   my $e = exists $self->{Contents}->{$key};

   #Add the value to our cache
   if (defined $val && (ref($val) eq 'ARRAY' || ref($val) eq 'HASH'))
     {$self->{Contents}->{$key} = $val;}
    else
     {$self->{Contents}->{$key} =[$val];}

   if (!$e && !exists $self->{Queue}->{$key})
     {
        #This can be done fairly cheaply..
        my $SVal;
        eval '$SVal=$self->{Object}->format($key,$val)';
        if (!$@ && defined $SVal) {return STORE_cheap $self, $SVal;}
     }

   #Queue this for later.
   Queue_Store($self,$key,$self->{Contents}->{$key});
}

sub APPEND
{
   my $self=shift;
   my $Key=shift;
   $self->{Contents}->{$Key} = [@{$self->{Contents}->{$Key}},@_];

   #Queue this for later.
   Queue_Store($self,$Key,$self->{Contents}->{$Key});
}

sub RENAME
{
   my($self,$Rules) =@_;
   #Generate the rewrite rules so we can build this thing.
   my $Sub =  "
   my \@Keys = keys \%{\$self->{Contents}}; #2
   foreach my \$K (\@Keys)
    { #4
       my (\$OK,\$N,\@NVal)=(\$K,0);
       my \$Val= \$self->{Contents}->{\$K}; #6
       foreach my \$I (\@{\$Val})
         { #8\n";

   #Encode the rules for changing the elements
   if (scalar keys %{$Rules})
     {
        $Sub.= join("els",
	map
         {
	    my $Ret .= "if (\$I =~ s/^$_\$/";
	    if ($Rules->{$_} && length $Rules->{$_})
              {$Ret .= $Rules->{$_};}
	    $Ret."/i)
		   {
	             if (\$I && length \$I) {push \@NVal,\$I};
		     \$N++;}\n";
         } (keys %{$Rules})).
	"   else {push \@NVal, \$I;}";
      }

   $Sub .= "   }\n";
   foreach $To (keys %{$Rules})
    {
	$Sub .= "if (\$K=~ s/^$To\$/";
	if ($Rules->{$To} && length $Rules->{$To})
          {$Sub.=$Rules->{$To};}
	$Sub.="/i)
	   {
	     if (\$K && length \$K)
	       {
	          if (\$N)
	            {\$self->{Contents}->{\$K} = [\@NVal];}
	           else
	            {\$self->{Contents}->{\$K} = \$Val;}
                  Queue_Store(\$self,\$K,\$self->{Contents}->{\$K});
	      }
	     delete \$self->{Contents}->{\$OK};
             Queue_Delete(\$self, \$OK);
	  }
	 elsif (\$N) 
          {
             if (scalar \@NVal)
               {
		 \$self->{Contents}->{\$K}=[\@NVal];
                 Queue_Store(\$self,\$K,\$self->{Contents}->{\$K});
               }
              else
               {
	          delete \$self->{Contents}->{\$OK};
                  Queue_Delete(\$self, \$K);
               }
          }\n";
#Could be faster with an 'else'..
    }

   $Sub.="   }\n";
   eval "$Sub";
#die "$Sub\n $@\n";
}

sub Comment_Add($$)
{
   #This appends the comments to the set of comments for this revision
   my ($self,$Cmt) = @_;
   if (exists $self->{Comments})
     {$self->{Comments} .= "$Cmt\n";}
    else
     {$self->{Comments} = "$Cmt\n";}
}
