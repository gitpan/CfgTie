#!/usr/bin/perl -w
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.


package CfgTie::TieAliases;
require CfgTie::Cfgfile;
require Tie::Hash;
@ISA=qw(CfgTie::Cfgfile);

=head1 NAME

CfgTie::TieAliases -- an associative array of mail aliases to targets

=head1 SYNOPSIS

Makes it easy to manage the mail aliases (F</etc/aliases>) table as a hash.

   tie %mtie,'CfgTie::TieAliases'

   #Redirect mail for foo-man to root
   $mtie{'foo-man'}=['root'];

=head1 DESCRIPTION

This PERL module ties to the F</etc/aliases> file so that things can be
updated on the fly.  When you tie the hash, you are allowed an optional
parameter to specify what file to tie it to.

   tie %mtie,'CfgTie::TieAliases'

or

   tie %mtie,'CfgTie::TieAliases',I<aliases-like-file>

or

   tie %mtie,'CfgTie::TieAliases',I<revision-control-object>

=head2 Format of the F</etc/aliases> file

The format of the F</etc/aliases> file is poorly documented.  The format that
C<CfgTie::TieAliases> understands is documented as follows:

=over 1

=item C<#>I<comments>

Anything after a hash mark (C<#>) to the end of the line is treated as a
comment, and ignored.

=item I<text>C<:>

The letters, digits, dashes, and underscores before a colon are treated as
the name of an aliases.  The alias will be expanded to whatever is on the
line after the colon.  (Each of those is in turn expanded).

=back

=head1 Cavaets

Not all changes to are immediately reflected to the specified file.  See the
L<CfgTie::Cfgfile> module for more information

=head1 See Also

L<CfgTie::Cfgfile>, L<RCService>,
L<CfgTie::TieGeneric>, L<CfgTie::TieGroup>, L<CfgTie::TieHost>,
L<CfgTie::TieNamed>,   L<CfgTie::TieNet>, L<CfgTie::TiePh>,
L<CfgTie::TieProto>,   L<CfgTie::TieServ>,  L<CfgTie::TieShadow>,
L<CfgTie::TieUser>

L<aliases(5)>
L<newaliases(1)>

=head1 Author

Randall Maas (randym@acm.org)

=cut

sub scan
{
   # Read the aliases file
   my $self= shift;
#   my $xself = shift;

   if (!exists $self->{Path})
     {
        #Path has not been defined... define it to the default.
        $self->{Path} = '/etc/aliases';
     }

   my $F=$CfgTie::Cfgfile'FNum++;
   if (!open(F,"<$self->{Path}")) {return;}
   while (<F>)
    {
       #Only keep the stuff before the comment
       if (/^([^#]*)/)
         {
            $_=$1;
            if (/([^:]+):\s*([^\n]*)/i)
              {$self->{Contents}->{$1}=[split(/,\s*/, $2)];}
         }
     }
   close F;
}

sub cfg_end
{
   my $self = shift;
#   my $self=shift;
   if (exists $self->{Path} && $self->{Path} eq '/etc/aliases')
     {system "/usr/bin/newaliases";}
#    else {print "Not a path for newaliases\n";}
}

sub format($$)
{
   my ($self,$key,$value)=@_;
   "$key: ".join(',',@{$value})."\n";
}

#sub is_tainted {not eval {join('',@_),kill 0; 1;};}

sub makerewrites
{
   my ($self) = @_;
#   my ($pself,$self) = @_;
   my $Sub;
   my $Rules = "\$Sub = sub {\n   \$_=shift;\n";
   foreach my $I (keys %{$self->{Queue}})
    {
       if (!defined $self->{Queue}->{$I} || !length $self->{Queue}->{$I})
         #Build a deletion rule
         {$Rules.="   if(/^\\s*$I\\s*:/i){return;}";}
        else
         {
            #Build a change value rule
            $Rules.="   if(/^\\s*$I\\s*:[^#\\n]*(#[^\\n]*)?/i)\n   ".
                    "{my \$Ret ='$I:". join(',',@{$self->{Queue}{$I}}).
                    "';\n    ".
                    "if (defined \$1) {\$Ret .=\$1;}\n   return \$Ret.\"\\n\";}\n";
         }
    }
   $Rules .="\n   \$_;\n};\n";
   $@='';
#   if (&is_tainted($Rules))
#       {die "Rules for updating aliases file are tainted\n";}
#    else
     {eval $Rules;}
   if (defined $@ && length $@) {die "rewrite rules compilation failed: $@";}
   return $Sub;
}

sub new {&TIEHASH(@_);}
sub TIEHASH
{
   my $self =shift;
   my $Node={};
   my $Ret = bless $Node, $self;
   $Ret->{delegate} = CfgTie::Cfgfile->new($Ret, @_);
   $Ret;
}

sub HTML
{
   my $self = shift;
   my $Ret = "<table border=0>";
   foreach my $I (sort keys %{$self->{Contents}})
    {
       $Ret .= "<tr><th align=right><a name=$I>$I</a></th><td>";
       foreach my $J (@{$self->{Contents}->{$I}})
        {
           if (exists $self->{Contents}->{$J})
             {$Ret .= "<a href=\"#$J\">$J</a> ";}
            else
             {$Ret .= $I.' ';}
        }
       $Ret .= "</td></tr>\n";
    }
   $Ret."</table>\n";
}

# from p325
sub AUTOLOAD
{
   my $self=shift;
   return if $AUTOLOAD =~ /::DESTROY$/;

   #Strip the package name
   $AUTOLOAD =~ s/^CfgTie::TieAliases:://;

   #Pass the message along
   $self->{delegate}->$AUTOLOAD(@_);
}

1;
