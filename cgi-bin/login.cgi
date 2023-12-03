#! /usr/bin/env perl

use strict;
use utf8;
use File::Basename;
use lib '/var/www/perl';
use MyCGIApp;

my $webapp = MyCGIApp->new(TMPL_PATH => dirname($0) . '/../templates');
$webapp->run();
