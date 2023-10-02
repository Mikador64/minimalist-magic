#!/bin/bash

sudo systemctl list-units --type=service | perl -I"$MM" -Mmm -0777 -nle 'color "BLUE";  p ai qq|Anything suspicious happening here? I am looking for possible malicious activity:\n${_}|;nl'
