#!/usr/bin/perl 

$name=$ENV{'USER'};
while(<>)
{
   s/[\r\n]*$//;
   if (/^gw/) {
       print "$_,$name\n";
   } else {
       print "$_\n";
   }
}
