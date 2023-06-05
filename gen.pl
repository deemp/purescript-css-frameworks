#!/usr/bin/perl

use strict;
use warnings;
use feature 'signatures';
no warnings 'experimental::signatures';
use File::Basename;

sub uniq (@data) {
    my %seen;
    return grep { !$seen{$_}++ } @data;
}

sub convert ($dirCss, $moduleName) {

    my $themes = "Halogen.Frameworks";
    $moduleName = "$themes.$moduleName";

    # = collect all class names
    my $css = "css/$dirCss/all.css";

    my $fileTmp = "$css.tmp";
    my $file;

    my @allClassNames;

    open (fileF, '<', $css) or die $!;
    
    my @lines = grep ($_ !~ /(url|\/\*|filter:)/, <fileF>);

    for my $line (@lines) {
        my @classNames = $line =~ /\.([a-zA-Z][-a-zA-Z0-9]*)/g;
        push(@allClassNames, @classNames);
    }
    my @classNames = uniq (sort @allClassNames);

    # = write purescript code

    # == calculate file name
    my $rootPurs = "src/";

    my $modulePurs = $moduleName;
    $modulePurs =~ s|\.|/|g;
    my $filePurs = "$rootPurs$modulePurs.purs";

    # == prepare directory 
    mkdir dirname($filePurs);

    # == write purs file
    open(filePursF, '>', $filePurs) or die $!;

    my $header = qq{
        module $moduleName where

        import Halogen.HTML.Core (ClassName(..))

        };

    $header =~ s/^ {8}//mg;
    $header =~ s/^\s+//;
    
    print filePursF $header;

    for my $className (@classNames) {
        chomp $className;
        my $classNameCamel = ($className =~ s/[_-]([a-z0-9])/\u$1/gr);
        $classNameCamel =~ s/^([A-Z])/_$1/;
        $classNameCamel =~ s/-/_/g;
        print filePursF "$classNameCamel :: ClassName\n";
        print filePursF "$classNameCamel = ClassName \"$className\"\n\n";
    }
}

convert ("bootstrap", "Bootstrap");
convert ("bootstrap-icons", "BootstrapIcons");
convert ("boxicons", "BoxIcons");
convert ("css.gg", "GG");
convert ("devicons", "DevIcons");
convert ("fontawesome", "FontAwesome");
convert ("remixicon", "RemixIcon");
convert ("simple-line-icons", "SimpleLineIcons");
convert ("tabler-icons", "TablerIcons");
convert ("themify-icons", "ThemifyIcons");
convert ("typicons.font", "Typicons");
convert ("vscode-codicons", "VSCodeCodicons");
convert ("weather-icons", "WeatherIcons");
convert ("pure/grids-responsive", "Pure.GridsResponsive");
convert ("pure/pure", "Pure.Pure");
convert ("milligram", "Milligram");
convert ("picnic", "Picnic");
convert ("chota", "Chota");
convert ("bulma", "Bulma");
convert ("foundation", "Foundation");
convert ("uikit", "UIkit");
convert ("primer", "Primer");
convert ("carbon", "Carbon");