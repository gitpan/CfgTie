#!/usr/bin/perl -w
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.

=head1 NAME

C<Secure::File> -- A module to open or create files within suid/sgid files

=head1 SYNOPSIS

    use Secure::File;
    my $SF = new Secure::File;
    $SF->open();

    my $NF = new Secure::File, 'myfile';


=head1 DESCRIPTION

C<open>  This checks that both the effective and real  user / group ids have
sufficient permissions to use the specified file.  (Standard C<open> calls only
check the effective ids).  C<Secure::File> also checks that the file we
open, really is the same file we checked ids on.

If the file already exists, C<open> will fail.

=head1 WARNING <==============================================================>

E<DO NOT TRUST THIS MODULE>.  Every effort has been made to make this module
useful, but it can not make a secure system out of an insecure one.  It can not
read the programers mind.  

=head1 Author

Randall Maas (L<mailto:randym@acm.org>, L<http://www.hamline.edu/~rcmaas/>)

=cut


package Secure::File;
use IO::File;
@ISA=qw(IO::File);
1;

sub new
{
   my $self=shift;
   if (@_)
   {
       my $name=shift;
       my @S = open_precheck($name,@_);
       return if !@S;
       my $R = new IO::File $name, @_;
       if (!defined $R || handle_check($R,@S))
         {
	    return $R;
         }
       undef $R;
       return;
   }

   #Call the parent class new
   return IO::File::new($self);
}

sub open
{
   my $self= shift;

   my @S = open_precheck(@_);
   return if !@S;
   my $R = new IO::File @_;
   if (!defined $R || handle_check($R,@S))
     {
        return $R;
     }
   undef $R;
}

sub open_precheck
{
   my $name=shift;
      if ($name =~ /^\s*>/ ||
	  (@_ && defined $_[0] && (($_[0] & O_WRONLY) || lc($_[0]) eq 'w')))
        {
	   w_check($name);
	}
   elsif (defined $_[0] && (($_[0] & O_RDWR) ||
			    ($_[0] =~ /r/i && $_[0] =~ /w/i)))
        {
	   rw_check($name);
        }
   else
        {
	   r_check($name);
        }
}

sub r_check
{
    #Check to see if the real user has read privileges
    my @S=stat($_[0]);
    if (!@S) {return;}
    return @S if -R _;
}

sub w_check
{
    #Check to see if the real user has write privileges
    my @S=stat($_[0]);
    if (!@S) {return;}
    return @S if -W _;
}

sub rw_check
{
    #Check to see if the real user has read/write privileges
    my @S=stat($_[0]);
    if (!@S) {return;}
    return undef if !-R _;
    return @S    if  -W _;
}

sub handle_check
{
   #Check to be sure that the inode has not changed!
   my $Handle = shift;

   my @S2 = $Handle->stat;

   if ($_[0] != $S2[0] || $_[1] != $S2[1] || $_[6] != $S2[6]) {return 1;}
   0;
}
