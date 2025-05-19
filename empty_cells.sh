#!/bin/bash

# PROJECT 2.1. (Data Cleaning Script) - CITS4407
# Name        : Kanisius Sosrodimardito
# Student ID  : 24023272

# ==================================================================================
# ARGUMENT CHECKS
# ==================================================================================

# Check if the first argument (file name) exists and is a regular file
if [[ ! -f $1 ]]; then
    echo "Error in 1st argument: The specified input file does not exist or is empty." > /dev/stderr
    exit 1
else
    csv_file="$1"
fi

# Check if the second argument (delimiter) is provided and is a single character
if [[ -z "$2" || ${#2} -ne 1 ]]; then
    echo "Error in 2nd argument: Please specify a single character as delimiter." > /dev/stderr
    exit 1
else
    delimiter="$2"
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
# Loop through each column from row 2 onwards, then clean any space and tab from each cell, 
# if it is an empty cell it will increase the count for that column
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