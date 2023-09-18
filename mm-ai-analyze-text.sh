#!/bin/bash

perl -I"$MM" -Mmm -e 'p q|> file: |,"YELLOW"' && read FILE && perl -I"$MM" -Mmm -e 'p q|> query: |,"YELLOW"' && read QUERY && echo "$QUERY" | perl -I"$MM" -Mmm -0777 -plE 'BEGIN { $query = <STDIN> } color "green"; $_ = ai(qq|${query}:\n${_}[END]|); END { color "reset"; nl }' $FILE
