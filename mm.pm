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

	use HTTP::Request::Common;
	use LWP::UserAgent;
	use JSON::XS;

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MODS

	$|++;

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INIT

	my @subs = qw|p arch arsh arst typo ai askai dd bp bird pkg color nl o w get zzz pr gram jse jsd|;

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

	# configure Data::Dumper for prettier output
	$Data::Dumper::Purity   = 1;  # to ensure the dumped data remains valid Perl code
	$Data::Dumper::Indent   = 1;  # use a readable (indented) style
	$Data::Dumper::Sortkeys = 1;  # sort harsh keys
	$Data::Dumper::Terse	= 1;  # avoids $VAR1 = at the beginning of the dump

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUBS

	# print
	sub p
	{
		if (@_)
		{
			print @_, RESET;
		}
		else
		{
			print $_, RESET;
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

		$prompt =~ s`[#]``g;
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

			if ($n++ <= 4000) { $truncated .= $1 }
			goto ESCAPE if $n >= 4000;

		~mergs;

		# debug stuff
		# say length $truncated; exit;
		# say $truncated; exit;
		# say $n; exit;

		ESCAPE: $prompt = $truncated;

		my $final_form = '';
		my $ua = LWP::UserAgent->new;

		# define the message array with just the user's question
		my @messages = (
			{
				role => "user",
				content => "${prompt}"
			}
		);

		# define JSON payload
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

		# create HTTP POST request
		my $req = POST 'https://api.openai.com/v1/chat/completions',
				'Content-Type' => 'application/json',
				'Authorization' => 'Bearer '.$openai->{api},
				Content => $json_payload;

		# send the request and get the response
		my $response = $ua->request($req);

		# check if the request is successful
		if ($response->is_success)
		{
			$final_form = ${\decode_json($response->content)}->{choices}[0]{message}->{content} . "\n";
			# say Dumper $response->content; exit;
		}
		else
		{
			print "AI Error: " . $response->status_line . "\n";
			# print "AI Error: ", Dumper $response;
		}


		# print results
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

	sub get($)
	{
		use URI;

		chomp(my $url_ingest= shift);
		my $url = URI->new($url_ingest);

		my $ua = LWP::UserAgent->new(
			timeout => 10,
			max_redirect => 10
		);
		$ua->env_proxy;

		my $response = $ua->get($url);

		if ($response->is_success)
		{
			return $response->decoded_content;
			# or: $response->content;
		}
		else
		{
			die $response->status_line;
		}

	}

	sub zzz
	{
		my $rando = shift // 5;
		my $fixed = shift // 0;

		my $random = int(rand($rando)+1) + $fixed;
		sleep $random;
	}

	sub gram($$)
	{
		use Regexp::Grammars;

		my $grammar = shift;
		my $text = shift;

		unless ($grammar and $text)
		{
			die RED 'Need $grammar and $text!', RESET "\n";
		}

		unless ($grammar =~ m`^qr`)
		{
			if (-f $grammar)
			{
				$grammar = o $grammar;
			}

		}

		$grammar = eval $grammar or do
		{
			die RED "Error evaluating grammar: $@\n", RESET;
		};

		if ($text =~ $grammar)
		{
			my %construct = %/; #/
			no Regexp::Grammars;
			return \%construct;
		}
		else
		{
			warn "failed to parse the log!\n";
			return 'FAIL';
		}

	}

	sub jse($)
	{
		return (encode_json (shift));
	}

	sub jsd($)
	{
		return (decode_json (shift));
	}


	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END

	1;  # important: must return a true value

}

__END__
Examples UFW Parse:
p -0777 -nlE '%h = gram q|grammar-ufw-blocked.txt|, $_; say $h{Log}->{Blocked}->[0]->{IP};' /var/log/ufw.log
