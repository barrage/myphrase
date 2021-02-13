#!/bin/bash

myphraseusage() {
    echo "myphrase.sh - a tool to select random words from a source, to generate a strong passphrase"
    echo ""
    echo "Usage:"
    echo "myphrase.sh /path/to/source/text [select_number_of_words]"
    echo "  /path/to/source/text - mandatory filepath to source text file"
    echo "  select_number_of_words - optional, number of random words to select from source, defaults to 8"
}

main() {
    source=$1
    select_number_of_words=$2

    if [ -z "$source" ] || [ "$source" == "-h" ] || [ "$source" == "--help" ]; then
        myphraseusage
        exit 1
    fi

    regex='^[0-9]+$'
    if ! [[ "$select_number_of_words" =~ $regex ]] ; then
        select_number_of_words=8
    fi

    wordcount=$(cat $source | tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq | wc -l)

    if [ $wordcount -lt 7776 ]; then
        echo "Warning: source contains only $wordcount unique words, which is below the limit of 7776 to ensure a strong passphrase"
    fi

    cat $source | tr -cs A-Za-z '\n' | tr A-Z a-z | sort | uniq | shuf --random-source=/dev/random -n$select_number_of_words | awk '{print}' ORS=' '
    echo '';
}
main $@
