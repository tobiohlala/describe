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


app_id="APP_ID"
app_key="APP_KEY"

base_url="https://od-api.oxforddictionaries.com/api/v1"


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
        -*)
            echo "unknown argument: $1" >&2
            exit 1
            ;;
        *)
            words+=("$1")
            shift
            ;;
    esac

done



for word in "${words[@]}"; do

    # print synonyms

    if [[ "$SYNONYMS" == YES ]]; then

        curl -s -X GET -H "app_id: $app_id" -H "app_key: $app_key" "$base_url/entries/en/$word/synonyms"\
        | jq '.results[].lexicalEntries[].entries[].senses[].synonyms[].text' 2>/dev/null\
        | sed 's/\"//g'

	exit 0

    fi

    # print antonyms

    if [[ "$ANTONYMS" == YES ]]; then

        curl -s -X GET -H "app_id: $app_id" -H "app_key: $app_key" "$base_url/entries/en/$word/antonyms"\
        | jq '.results[].lexicalEntries[].entries[].senses[].antonyms[].text' 2>/dev/null\
        | sed 's/\"//g'\

	exit 0

    fi

    # print definition

    result=$(curl -s -X GET -H "app_id: $app_id" -H "app_key: $app_key" "$base_url/entries/en/$word")

    phoneticSpelling=$(echo $result\
    | jq '.results[].lexicalEntries[].pronunciations[].phoneticSpelling' 2>/dev/null\
    | head -n 1\
    | sed 's/\"//g')

    description=$(echo $result\
    | jq '.results[].lexicalEntries[].entries[].senses[].definitions[]' 2>/dev/null\
    | head -n 1\
    | sed 's/\"//g')

    echo "$word [$phoneticSpelling] is $description"

done


