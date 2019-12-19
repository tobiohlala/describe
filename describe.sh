#!/bin/bash

# describe.sh - query word definitions from oxford dictionaries api

# Copyright (c) 2018, Tobias Heilig
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the authors may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#requires   curl, jq


base_url="https://od-api.oxforddictionaries.com/api/v2"

if [ -f ~/.config/describe ]; then
    . ~/.config/describe
else
    echo "ERROR: missing configuration file. see README for further instructions."
    exit 1
fi

if [ -z ${app_id+x} ]; then
    echo "ERROR: couldn't read appid from configuration file. see README for further instructions"
    exit 1
fi

if [ -z ${app_key+x} ]; then
    echo "ERROR: couldn't read appkey from configuration file. see README for further instructions"
    exit 1
fi

function usage {
    echo "usage: $0 [-aes] word"
    echo -e "  -s|--synonyms\t\tprint synonyms"
    echo -e "  -a|--antonyms\t\tprint antonyms"
    echo -e "  -e|--emphasize\temphasize output"
    echo -e "  -h|--help\t\tprint this help"
    exit 1
}

words=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--synonyms)
            SYNONYMS=YES
            shift
            ;;
        -a|--antonyms)
            ANTONYMS=YES
            shift
            ;;
        -e|--emphasize)
            EMPHASIZE=YES
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            usage
            ;;
        *)
            words+=("$1")
            shift
            ;;
    esac
done



for word in "${words[@]}"; do
    # print synonyms
    # ONLY AVAILABLE ON DEVELOPER PLANS
    if [[ "$SYNONYMS" == YES ]]; then
        curl -s -X GET -H "app_id: $app_id" -H "app_key: $app_key" "$base_url/thesaurus/en/$word?fields=synonyms"\
        | jq '.results[].lexicalEntries[].entries[].senses[].synonyms[].text' 2>/dev/null\
        | sed 's/\"//g'
	exit 0
    fi

    # print antonyms
    # ONLY AVAILABLE ON DEVELOPER PLANS
    if [[ "$ANTONYMS" == YES ]]; then
        curl -s -X GET -H "app_id: $app_id" -H "app_key: $app_key" "$base_url/thesaurus/en/$word?fields=antonyms"\
        | jq '.results[].lexicalEntries[].entries[].senses[].antonyms[].text' 2>/dev/null\
        | sed 's/\"//g'\
	exit 0
    fi

    # print definition
    result=$(curl -s -X GET -H "app_id: $app_id" -H "app_key: $app_key" "$base_url/entries/en-us/$word")

    phoneticSpelling=$(echo $result\
    | jq '.results[].lexicalEntries[].pronunciations[].phoneticSpelling' 2>/dev/null\
    | awk '{if (NR == 2) print $0}'\
    | sed 's/\"//g')

    description=$(echo $result\
    | jq '.results[].lexicalEntries[].entries[].senses[].definitions[]' 2>/dev/null\
    | head -n 1\
    | sed 's/\"//g')

    if [[ "$EMPHASIZE" == YES ]]; then
        echo -e "\033[1m$word\033[0;0m \033[2m[$phoneticSpelling]\033[0;0m is $description"
    else
        echo "$word [$phoneticSpelling] is $description"
    fi
done


