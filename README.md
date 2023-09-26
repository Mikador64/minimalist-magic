

# Minimalist Magic

**by**: [mikeador64.com](https://mikador64.com/)

### Note

More robust documentation detailing its specific usage is coming soon.

### About

The package "mm" was developed to provide quick and efficient ways to perform certain tasks using command-line one-liners. This script comprises various subroutines, each designed to execute a specific tasks. These tasks include:

This Perl package contains the following subroutines:
- `p`: This subroutine prints a string or an array reference. It also accepts an optional color control.
- `pr`: This is an alias for the print function. It prints the contents of `@_` or `$_` if `@_` is empty.
- `arch`: This subroutine splits a string into an array of characters.
- `arsh`: This subroutine shuffles the elements of an array.
- `arst`: This subroutine converts an array into a string. It accepts an array reference and an optional delimiter.
- `typo`: This subroutine applies a typoglycemia effect to a string. It shuffles the characters of each word in the string, except for the first and last characters.
- `ai`: This subroutine interacts with an AI model. It sends a prompt to the AI model and returns the AI's response.
- `askai`: This subroutine prompts the user for a question, sends the question to the AI model, and prints the AI's response.
- `dd`: This subroutine dumps the structure of a variable using the Data::Dumper module.
- `bird`: This subroutine applies a bird effect to a string. It highlights a portion of each word in the string.
- `pkg`: This subroutine dumps the contents of the `%INC` hash, which contains all the modules loaded by Perl.
- `color`: This subroutine changes the color of the text.
- `nl`: This subroutine prints a newline character.
- `o`: This subroutine opens a file and returns its contents as a string.
- `w`: This subroutine writes content to a file. It accepts a filename, content, and an optional operation ('a' for append).
- `get`: This subroutine sends a GET request to a URL and returns the response.
- `zzz`: This subroutine pauses the execution for a random number of seconds.
- `gram`: This subroutine parses a text using a grammar. It accepts a grammar and a text, and returns a hash reference representing the parsed text.
- `jse`: This subroutine encodes a Perl data structure into a JSON string.
- `jsd`: This subroutine decodes a JSON string into a Perl data structure.

### Example

```perl
perl -I"$MM" -Mmm -e 'p q|> file: |,"YELLOW"' && read FILE && perl -I"$MM" -Mmm -e 'p q|> query: |,"YELLOW"' && read QUERY && echo "$QUERY" | perl -I"$MM" -Mmm -0777 -plE 'BEGIN { $query = <STDIN> } color "green"; $_ = ai(qq|${query}:\n${_}|); END { color "reset"; nl }' $FILE
```

- Prompt the user for a file name and a query using colored text.
- Read the provided file and apply a AI query to its content.
- Print the processed content with a green color and then reset the color at the end.

### OpenAI Integration

The config file **api.json** is required in the same folder of this package.

```
{
    "api":"sk-ENTER-YOUR-OPENAI-API-KEY-HERE",
    "model":"gpt-4",
    "temperature":0,
    "max_tokens":1000,
    "top_p":1,
    "frequency_penalty":0,
    "presence_penalty":0
}
```

### Package Dependencies  

The script also uses several Perl modules such as:

- [Data::Dumper](https://metacpan.org/pod/Data::Dumper)
- [List::Util](https://metacpan.org/pod/List::Util)
- [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor)
- [HTTP::Request::Common](https://metacpan.org/pod/HTTP::Request::Common)
- [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)
- [JSON::XS](https://metacpan.org/pod/JSON::XS)