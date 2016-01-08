# --
# Kernel/Output/HTML/FilterElementPost/MoveTicketLinkedObjects
# Copyright (C) 2016 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::MoveTicketLinkedObjects;

use strict;
use warnings;

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Web::Request
    Kernel::System::Ticket
    Kernel::Output::HTML::Layout
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{UserID} = $Param{UserID};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get template name
    my $Templatename = $Param{TemplateFile} || '';

    return 1 if !$Templatename;
    return 1 if !$Param{Templates}->{$Templatename};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ViewMode = $ConfigObject->Get('LinkObject::ViewMode') || '';
    return 1 if 'complex' ne lc $ViewMode;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    $LayoutObject->AddJSOnDocumentComplete(
        Code => q~
            if ( Core.Config.Get('MovedComplexTable') != 1 ) {
                var ArticleItems = $('#ArticleItems');
                var ComplexTable = ArticleItems.next();
                var Copy = ComplexTable.clone();
                ComplexTable.remove();
                Copy.insertBefore( ArticleItems );
                Core.Config.Set('MovedComplexTable', 1);
            }
        ~,
    );

    return 1;
}

1;
