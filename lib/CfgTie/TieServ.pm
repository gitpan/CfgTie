#!/usr/bin/perl -Tw
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.

package CfgTie::TieServ;

=head1 NAME

CfgTie::TieServ -- A HASH tie that allows access the service port database

=head1 SYNOPSIS

	tie %serv,'CfgTie::TieServ';
	print $serv{'smtp'};

=head1 DESCRIPTION

This is a straight forward HASH tie that allows us to access the service
port database sanely.

=head2 Ties

There are two ties available for programers:

=over 1

=item C<tie %serv,'CfgTie::TieServ'>

C<$serv{$name}> will return a HASH reference of the named service
information

=item C<tie %serv_port,'CfgTie::TieServ_port'>

C<$serv_port{$port}> will return a HASH reference for the specified service
port.

=back

=head2 Structure of hash

Any given serv entry has the following information assoicated with it:

=over 1

=item C<Name>

Service name

=item C<Aliases>

A list reference for other names for this service

=item C<Port>

The port number

=item C<Protocol>

The protocol name

=back

Additionally, the programmer can set any
other associated key, but this information will only available to running
PERL script.

=head1 See Also

L<Cfgfile>,  L<CfgTie::TieAliases>, L<CfgTie::TieGeneric>,
L<CfgTie::TieGroup>,
L<CfgTie::TieHost>,   L<CfgTie::TieNamed>, L<CfgTie::TieNet>,
L<CfgTie::TiePh>,     L<CfgTie::TieProto>, L<CfgTie::TieShadow>,
L<CfgTie::TieUser>

=head1 Cavaets

The current version does cache some service information.

=head1 Author

Randall Maas (L<randym@acm.org>)

=cut

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
   setservent 1;

   &NEXTKEY($self);
}

sub NEXTKEY
{
   my $self = shift;

   #Get the next serv id in the database.
   # Get the information from the system and store it for later
   my @x = getservent;
   if (! scalar @x) {return;}

   &CfgTie::TieServ_rec'TIEHASH(0,@x);
   return $x[0]; #Corresponds to the name
}

sub EXISTS
{
   my ($self,$name) = shift;
   if (exists $CfgTie::TieServ_rec'by_name{$name}) {return 1;}

   # Get the information from the system and store it for later
   my @x = getservbyname $name, AF_INET;
   if (! scalar @x) {return 0;}

   &CfgTie::TieServ_rec'TIEHASH(0,@x);
   return 1;
}

sub FETCH
{
   my ($self, $name) = @_;

   #check out our cache first
   if (exists $CfgTie::TieServ_rec'by_name{$name})
    {return $CfgTie::TieServ_rec'by_name{$name};}

   my %X;
   tie %X, 'CfgTie::TieServ_rec', getservbyname($name, AF_INET);
   return bless %X;
}

#Bug creating, deleting servs is not supported yet.

package CfgTie::TieServ_port;

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
   setservent 1;

   &NEXTKEY($self);
}

sub NEXTKEY
{
   my $self = shift;

   #Get the next serv id in the database.
   # Get the information from the system and store it for later
   my @x = getservent;
   if (! scalar @x) {return;}

   &CfgTie::TieServ_rec'TIEHASH(0,@x);
   return $x[5]; #Corresponds to the id
}

sub EXISTS
{
   my ($self,$port) = shift;
   if (exists $CfgTie::TieServ_rec'by_port{$port}) {return 1;}

   # Get the information from the system and store it for later
   my @x = getservbyport $port, AF_INET;
   if (! scalar @x) {return 0;}

   &CfgTie::TieServ_rec'TIEHASH(0,@x);
   return 1;
}

sub FETCH
{
   my ($self,$port) = @_;

   #check out our cache first
   if (exists $CfgTie::TieServ_rec'by_port{$port})
    {return $CfgTie::TieServ_rec'by_port{$port};}

   my %X;
   tie %X, 'CfgTie::TieServ_rec', getservbyport($port, AF_INET);
   return bless %X;
}

#Bug creating and modifying servs is not supported yet.

package CfgTie::TieServ_rec;
# A package used by both CfgTie::TieServ_port and CfgTie::TieServ to retain
# record information about a service port.  This is the only way to access
# servmod.

#Two hashes are used for look up
# $by_name{$name}
# $by_port{$addr}

sub TIEHASH
{
   # Ties a single serv to a register...
   my $self = shift;
   my $Name = shift;
   my $Node;

   if (exists $by_name{$Name})
     {
        #Just update our record...
        $Node = $by_name{$Name};
     }
#    else  create it

   my $Aliases;
   $Node->{Name} =$Name;
   ($Aliases, $Node->{Port}, $Node->{Protocol}) = @_;
   $Node->{Aliases} = [split ',',$Aliases];

   #Cross reference the names
   my $I;
   foreach $I ($Name, $Node->{Aliases})
    {$by_name{$I} = $Node;}

   $by_port{$Node->{Port}} = $Node;

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
   my ($self,$key) = shift;
   return exists $self{$key};
}

sub FETCH
{
   my $self = shift;
   my $key = shift;

   if (exists $self{$key}) {return $self{$key};}
}

sub STORE
{
   # Changes a setting for the specified serv... we basically call servmod
   my ($self,$key,$val) = @_;

        #Extra setting that will be lost... 8(
        $self{$key}=$val;
}

sub DELETE
{
   #Deletes a serv setting
   my ($self, $key) = @_;

           #Just remove our local copy
           delete $self{$key};
}

