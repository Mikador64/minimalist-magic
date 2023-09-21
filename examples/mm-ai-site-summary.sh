#!/bin/bash

perl -I"$MM" -Mmm -e 'p q|> URL: |,"YELLOW"' && read URL && curl -sSL $URL | lynx -stdin -dump | perl -I"$MM" -Mmm -0777 -pE 'color "green"; $_ = ai(qq|Summarize in two sentence this website is about:\n${_}[END]|); END{color "reset"; nl}'
