#!/bin/bash

# PROJECT 2.2 (Preprocess Script) - CITS4407
# Name        : Kanisius Sosrodimardito
# Student ID  : 24023272

csv_file=$1

# Chech if file exist or not
if [[ ! -f "$csv_file" ]]; then
    echo "Error: The specified input file $csv_file does not exist or is empty." >&2
    exit 1
fi

# Create a new filename by replacing .txt with _tab.txt
tab="${csv_file%.txt}_tab.txt"

# Replace semicolons with tabs and save to the new file
tr ';' '\t' < "$csv_file" > "$tab"
echo "Done converting semicolon to tab"

# Create a new filename by replacing .txt with _unix.txt
unix="${csv_file%.txt}_unix.txt"

# Remove carriage return characters (\r) to convert to Unix line endings
tr -d '\r' < "$tab" > "$unix"
echo "Done converting to Unix line endings"

# Create a new filename by replacing .txt with _decimal.txt
decimal="${csv_file%.txt}_decimal.txt"

# Replace decimal commas with decimal points (e.g. 1,5 → 1.5)
sed 's/\([0-9]\),\([0-9]\)/\1.\2/g' "$unix" > "$decimal"
echo "Done converting decimal formats"

# Create a new filename by replacing .txt with _ascii.txt
ascii="${csv_file%.txt}_ascii.txt"

# Remove all characters except printable ASCII characters, tabs and newlines
tr -cd '\40-\176\n\t' < "$decimal" > "$ascii"
echo "Done removing non-ASCII characters"

# Create final filename by replacing .txt with _final.txt
final_file="${csv_file%.txt}_final.txt"

# Combine header line and sorted data lines (sorted numerically on first column)
{ head -n 1 "$ascii"; tail -n +2 "$ascii" | sort -t$'\t' -k1,1n; } > "$final"

# Create another output filename replacing .txt with _a.txt
a_file="${csv_file%.txt}_a.txt"

# Use awk to fill in missing IDs and renumber duplicates in the first column
awk -F'\t' 'BEGIN { OFS=FS }
NR==1 {print; next}
{
  if ($1 == "" || id[$1]++) $1 = ++max;
  else if ($1+0 > max) max = $1+0
  print
}' "$ascii" > "$a_file"

# Optional cleanup
rm -f "$tab" "$unix" "$decimal" "$ascii" "$final"