#!/usr/bin/env perl

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INFO

# By: Michael Limberger
# Email: m.limberger@utoronto.ca
# v0.01-2023

# This script is designed to install the most recent
# version of Cacti in 2023, Ubuntu 20.04 LTS is required

# Defaults:
# #########################
# MySql Root Pass: mysql555
# Database: web
# Database User: webuser
# Database Pass: web555

# Looking for Version
# #########################
# Distributor ID: Ubuntu
# Description:    Ubuntu 20.04.3 LTS
# Release:        20.04
# Codename:       focal

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRAGMAS

use feature qw|say|;
use List::Util qw|shuffle|;
use Term::ANSIColor qw(:constants);

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GLOBALS

$|++;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CREDITS

# author info
my $aboutName  = 'mikador64.com';
my $aboutEmail = 'Email: hello-there@miker.media';

# display author flare
rainbowText($aboutName);
rainbowText($aboutEmail);

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INIT

# validate if ubuntu is installed or exit
if (1)
{
	my $lsb_release = q|uname -a|;

	$checkLinux = qx|${lsb_release}|;

	unless ($checkLinux =~ m`debian|ubuntu|pop-os`mi)
	{
		failUbuntu();
	}
}

# run commands
RUN:
{
	while (<DATA>)
	{
		# strip newlines
		chomp;

		# skip if no content or comment
		next if m`^(?:$|\s+$|\#)`;

		# debug STOP token for halting program
		if (m`^\*STOP\*`)
		{
			errorText(qq|Stop Prompt Detected So Bailing!|);
		}

		print qq|> |;
		print YELLOW;
		s`.`typeWriter($&)`ger;
		say RESET;
		system $_;

		# if command not successful run error subroutine
		unless ($? == 0)
		{
			errorText(qq|Error: ${?}|);
		}
		else
		{
			print qq|> |;
			print GREEN;
			my $msg = 'Command Ran Successfully!';
			$msg =~ s`.`typeWriter($&)`ger;
			say RESET;
		}
	}
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUBS

# rainbow text effect
sub rainbowText($)
{
	my $txt = shift;
	my @colors = qw|RED GREEN YELLOW WHITE MAGENTA CYAN|;
	print q|> |;
	$txt =~ s`.`$cmd = q~print ~.@{[shuffle @colors ]}[0].';'; eval $cmd; typeWriter($&);`ger;
	say RESET;
}

# error message for incorrect OS version
sub failUbuntu()
{
	errorText(qq|OS not Debian enough so bailing!|);
}

# error detected so quit
sub errorText($)
{
	my $text = shift;

	print qq|> |;
	print RED;
	print UNDERLINE;
	$text =~ s`.`typeWriter($&)`ger;
	say RESET;
	exit 1;
}

# on screen typewriter effect
sub typeWriter($)
{
	my $char = shift;
	select(undef, undef, undef, rand(0.05));
	print $char;
}

__END__
# Basics Unreleated
sudo apt update
sudo apt install build-essential -y
sudo apt install make -y
sudo apt install cpanminus

# Dependancies
sudo cpanm HTTP::Request::Common
sudo cpanm LWP::UserAgent
sudo cpanm JSON::XS

# Setup .bashrc
perl -MCwd -E '$pwd = Cwd::getcwd(); $cmd = qq~export PATH=${pwd}:\$PATH\nexport MM=\x{27}${pwd}\x{27}\nalias p="perl -I\x{27}\$MM\x{27} -Mmm"~; say $cmd;' >> $HOME/.bashrc

# Create Template for api.json
perl -slE 'say $api =~ s`(NL)|TAB`$1 ? "\n" : "\t"`ger' -- -api='{NLTAB"api":"sk-ENTER-YOUR-OPENAI-API-KEY-HERE",NLTAB"model":"gpt-4",NLTAB"temperature":0,NLTAB"max_tokens":1000,NLTAB"top_p":1,NLTAB"frequency_penalty":0,NLTAB"presence_penalty":0NL}' > api.json
