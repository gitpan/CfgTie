#!/usr/bin/perl -T
use 5.004;
use strict;
use CfgTie::TieGeneric;
my %Gen;
tie %Gen, 'CfgTie::TieGeneric';
my $pathinfo;

sub redirect($) {exec ("cat ".shift);}
sub Untaint_path($) {$_[0]=~ s/^(.*)$/$1/;}

sub Gen_print($$)
{
   my ($Space,$Name)= @_;

   #If it wants the table of users, redirect to the precomputed set
#   if (!defined $Name || !$Name) {redirect "email.html";}

print "$Space $Name\n";
   #If the user does not exists, gripe
   if (!defined $Name || !$Name || !$Space ||!exists $Gen{$Space} ||
	!exists $Gen{$Space}->{$Name})
     {
	#Carlington miniscule
	my $Thingy=$Space;
        if ($Space=~/^(\w)(\w+)/) {$1=tr/a-z/A-Z/;$Thingy=$1.$2;}
        print "<html><h1>$Thingy does not exist</h1>$pathinfo</html>\n";
        exit 0;
     }

   #Print neat information about the user out.
   my $U = $Gen{$Space}->{$Name};
   print "<html><head><title>$Name</title></head><body>\n". $U->HTML();
   print "</body></html>\n";
}

if (exists $ENV{'PATH_INFO'})
  {
     $pathinfo=$ENV{'PATH_INFO'};
     Untaint_path($pathinfo);
  }

my $oldbar=$|;
my $cfh=select(STDOUT);
$|=1;
open STDERR, ">&STDOUT";

print "Content-type: text/html\n\n";

# Set up for security.
$ENV{'PATH'} = '/bin:/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};
if (!defined $pathinfo) {redirect "email.html";}
my ($Space,$Name)=('','');
if ($pathinfo=~ /^\/(\w+)(?:s)?\/(\w+)/)
#  {redirect "email.html";}
# else
  {$Space=lc($1);$Name=$2;}

&Gen_print($Space,$Name);

=head1 NAME

sys.cgi -- An example CGI script to browse configuration space via CfgTie

=head1 SYNPOSIS

	http://www.mydomain.com/sys.cgi/user/joeuser
	http://www.mydomain.com/sys.cgi/users
	http://www.mydomain.com/sys.cgi/groups

=cut

