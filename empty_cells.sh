#!/bin/bash

# PROJECT 2.1. (Data Cleaning Script) - CITS4407
# Name        : Kanisius Sosrodimardito
# Student ID  : 24023272

csv_file=$1

# File check (exist or not on the directory)
if [[ ! -f "$csv_file" ]]; then
    echo "Error: The specified input file $csv_file does not exist or is empty." >&2
    exit 1
fi

# Processes header name and count missing values
awk -F';' '
NR==1 {
    # Go through each column from the first row of the txt file (header), 
    # then clean any space and tab from that cell, then store the cleaned cell value in the array HEADER
    for (i = 1; i <= NF; i++) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", $i)
        header[i] = $i
    }
    next
}
# Loop through each column from row 2 onwards, then clean any space and tab from each cell, if it is an empty cell it will increase the count for that column
{
    for (i = 1; i <= NF; i++) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", $i)
        if ($i == "") count[i]++
    }
}
END {
# Print each of the header name and the number of empty values from that column
    for (i = 1; i <= length(header); i++) {
        printf "%s: %d\n", header[i], (count[i] ? count[i] : 0)
    }
}
' "$csv_file"