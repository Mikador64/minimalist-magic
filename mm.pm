#!/usr/bin/env perl

# by: mikador64.com
# date: 2023-08-13

package mm
{
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRAGMAS

	use strict;
	use warnings;
	use Data::Dumper;

	use List::Util q|shuffle|;

	use feature qw|say state|;
	use List::Util qw|shuffle|;
	use Term::ANSIColor qw|:constants|;

	use HTTP::Request::Common;;
	use LWP::UserAgent;
	use JSON::XS;

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODS

	$|++;

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INIT

	my @subs = qw|p arch arsh arst typo ai askai dd bp bird pkg color nl o w|;

	require Exporter;
	our @ISA = qw|Exporter|;

	# functions exported by default.
	our @EXPORT = @subs;

	# functions exported on demand.
	our @EXPORT_OK = @subs;

	# group of functions 'all'
	our %EXPORT_TAGS = (
		'all' => [ @subs ],
	);

	our $VERSION = '0.01';

	# Configure Data::Dumper for prettier output
	$Data::Dumper::Purity   = 1;  # To ensure the dumped data remains valid Perl code
	$Data::Dumper::Indent   = 1;  # Use a readable (indented) style
	$Data::Dumper::Sortkeys = 1;  # Sort harsh keys
	$Data::Dumper::Terse	= 1;  # Avoids $VAR1 = at the beginning of the dump

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUBS

	# print
	sub p
	{
		$" = ''; # "

	   if (scalar @_ > 2)
	   {
		  say q|> |, RED UNDERLINE 'p() = only (string or anonymous array) and optional (color control) allowed.';
		  exit 1;
	   }

		my $text;

		if (ref($_[0]) eq 'ARRAY')
		{
			$text  = "@{ shift @_ }";
		}
		elsif ((defined $_[0] && ref($_[0]) eq ''))
		{
			$text =  shift;
		}
		else
		{
			say q|> |, RED UNDERLINE q|p() needs a array reference or string...|, RESET;
			exit 1;
		}

		my $color = shift;
		
		if ($color)
		{
			$color = "\U$color\E";
			my $print = qq|print ${color} \$text, RESET;|;
			eval $print;
		}
		else
		{
			print RESET $text;	
		}
	}
	
	# array from characters
	sub arch
	{
		my $text  = shift;
		my @array = split m``, $text;

		return @array;
	}
	
	# array shuffle
	sub arsh
	{
		unless (ref($_[0]) eq 'ARRAY')
		{
			 say q|> |, RED UNDERLINE q|arst() needs a array reference...|, RESET;
			 exit 1;
		}

		my @array = @{ shift @_ };
		@array = shuffle(@array);

		return @array;
	}
	
	# array to string
	sub arst
	{
		 unless (ref($_[0]) eq 'ARRAY')
		 {
			 say q|> |, RED UNDERLINE q|arst() needs a array reference...|, RESET;
			 exit 1;
		 }

		 my $array	 = shift;
		 my $delimiter = shift;
		 $" = $delimiter ? $delimiter : ''; # "
		 my @array = "@{ $array }";

		 return "@array";
	}
	
	# typoglycemia effect
	sub typo($)
	{

	   chomp(my $text = shift);
	   my $final = '';

	   $text =~ s`[[:alpha:]]{3,}`

			my $match = $&;
			my @array = arch($match);

			my $first = shift @array;
			my $last  = pop   @array;

			@array = arsh([@array]);

			$first . arst([@array]) . $last;
		`ge;

		return $text;
	}

	# ai
	sub ai($)
	{
		my $prompt = shift;
		my $json = $INC{'mm.pm'} =~ s`^.*/\K.*$`api.json`r;

		unless (-f $json)
		{
			p("> No API so quitting!\n", 'RED');
			exit 1;
		}

		open my $fh, '<', $json
		or do { p("> Can't open JSON so quitting!\n", 'RED'); exit 1; };

		my $openai = decode_json(join '', <$fh>);
		close $fh;

		$prompt =~ s`\n` `g;

		my $n = 0;
		my $truncated = '';
		() = $prompt =~ s~(?x)
			(
				(?:\ ?[:/\.[:alnum:]-]+)
				|
					\t
				|
					[[:punct:]]
				|
					\n
				|
					\p{Emoji}
			)
		~
			$truncated .= $1 if ($n++ <= 4000);

		~mergs;

		$prompt = $truncated;

		my $final_form = '';
		my $ua = LWP::UserAgent->new;

		# Define the message array with just the user's question.
		my @messages = (
			{
				role => "user",
				content => "${prompt}"
			}
		);

		# Define your JSON payload
		my $json_payload = encode_json(
		{
			model => $openai->{model},
			messages => \@messages,  # reference to the messages array
			temperature => $openai->{temperature},
			max_tokens => $openai->{max_tokens},
			top_p => $openai->{top_p},
			frequency_penalty => $openai->{frequency_penalty},
			presence_penalty => $openai->{presence_penalty},
		});

		# Create an HTTP POST request
		my $req = POST 'https://api.openai.com/v1/chat/completions',
				'Content-Type' => 'application/json',
				'Authorization' => 'Bearer '.$openai->{api},
				Content => $json_payload;

		# Send the request and get the response
		my $response = $ua->request($req);

		# Check if the request is successful
		if ($response->is_success)
		{
			$final_form = ${\decode_json($response->content)}->{choices}[0]{message}->{content} . "\n";
			# say Dumper $response->content; exit;
		}
		else
		{
			print "Error: " . $response->status_line . "\n";
			# print "Error: ", Dumper $response;
		}


		# Print Results
		chomp $final_form;
		# $final_form =~ s`\n{2,}`\n`g;
		$final_form =~ s`^\n|\n\Z``mg;
		no warnings 'utf8';
		# p("$final_form\n");
		return $final_form;
	
	}

	sub askai()
	{
		print '> ask: ';
		my $input = <STDIN>;
		chomp($input);
		my $response = ai($input);
		p("$response\n", "GREEN");
	}

	sub dd($)
	{
		chomp (my $structure = shift);
		say Dumper($structure);
	}

	sub bird($)
	{
		chomp (my $text = shift);

		$text =~ s`
			(\w+)(\W*)
		`
			my $punct = $2 ? $2 : "";
			my $l = length $1;
			$l = $l > 2 ? int($l * 0.4) : 1;
			my $final = $1 =~s~.{$l}~\033[1m$&\033[0m~r;
			$final .= $punct;
		`xge;

		print $text;
	}

	sub pkg()
	{
		say Dumper({%INC});
	}

	sub color
	{
		my $color = shift;
		$color = qq|\U${color}\E|;
		eval qq|print $color;|;
	}

	sub nl()
	{
		say '';
	}

	sub o($)
	{
		chomp(my $file = shift);

		unless (-f $file)
		{
			say RED qq|> File does not exist: $file|, RESET;
			exit 1;
		}

		open my $fh, '<', $file or do
		{
			say RED qq|> can not open: $file|, RESET;
			exit 1;
		};

		return (join '', <$fh>);
	}

	sub w($$*)
	{
		# file, content
		chomp(my $file    = shift);
		chomp(my $content = shift);
		chomp(my $op = shift);

		my $fh;

		if ($op && $op eq 'a')
		{
			open $fh, '>>', $file or do
			{
				say RED qq|> can not write: $file|, RESET;
				exit 1;
			};
		}
		else
		{
			open $fh, '>', $file or do
			{
				say RED qq|> can not write: $file|, RESET;
				exit 1;
			};
		}

		say $fh $content;
	}

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END

	1;  # important: must return a true value

}

__END__
perl -I. -Mmm -E ''

# Bash
export MM='/home/mike/git/minimalist-magic'
alias p="perl -I'$MM' -Mmm -0777"
