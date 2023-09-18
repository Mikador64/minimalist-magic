

# Minimalist Magic

**by**: [mikeador64.com](https://mikador64.com/)

### Note

More robust documentation detailing its specific usage is coming soon.

### About

The package "mm" was developed to provide quick and efficient ways to perform certain tasks using command-line one-liners. This script comprises various subroutines, each designed to execute a specific tasks. These tasks include:

- **p**: A print function with color control.
- **arch**: Converts a string into an array of characters.
- **arsh**: Shuffles an array.
- **arst**: Converts an array back into a string.
- **typo**: Applies a typoglycemia effect to a string.
- **ai**: An AI function that uses the OpenAI API to generate responses.
- **askai**: Asks a question to the AI function and prints the response.
- **dd**: Uses Data::Dumper to print a data structure.
- **bp**: Prints bash commands for setting up the environment.
- **bird**: Applies a highlighting effect to a string.
- **pkg**: Prints the contents of the %INC hash.
- **color**: Prints a string in a specified color.
- **nl**: Prints a newline.
- **o**: Opens a file and returns its contents.
- **w**: Writes content to a file.

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