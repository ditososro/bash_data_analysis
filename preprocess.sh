#!/bin/bash

# PROJECT 2.2 (Preprocess Script) - CITS4407
# Name        : Kanisius Sosrodimardito
# Student ID  : 24023272

# ====================================================================================================
# FIRST ARGUMENT CHECK
# ====================================================================================================
# Check whether or not the file exist and is valid
if [[ ! -f $1 ]]; then
    echo "Error in 1st argument: The specified input file does not exist or is empty." > /dev/stderr
    exit 1
else
    # Put the file in a variable to better call later on
    csv_file="$1"
fi

# Create a new filename by replacing .txt with _tab.txt
tab="${csv_file%.txt}_tab.txt"

# Replace semicolons with tabs and save to the new file
tr ';' '\t' < "$csv_file" > "$tab"
echo "Replaced ; with tab"
unix="${csv_file%.txt}_unix.txt"

# Remove carriage return characters (\r) to convert to Unix line endings
tr -d '\r' < "$tab" > "$unix"
echo "Converted Unix line ending"
decimal="${csv_file%.txt}_decimal.txt"

# Replace decimal commas with decimal points (e.g. 1,5 → 1.5)
sed 's/\([0-9]\),\([0-9]\)/\1.\2/g' "$unix" > "$decimal"
echo "Convert decimal , to ."
ascii="${csv_file%.txt}_ascii.txt"

# Remove all characters except printable ASCII characters, tabs and newlines
tr -cd '\40-\176\n\t' < "$decimal" > "$ascii"
echo "Done removing non-ASCII characters"
final_file="${csv_file%.txt}_final.txt"

# Combine header and sorted data
{ head -n 1 "$ascii"; tail -n +2 "$ascii" | sort -t$'\t' -k1,1n; } > "$final"

# Create another output filename replacing .txt with _a.txt
a_file="${csv_file%.txt}_a.txt"

# Fill in missing IDs and renumber duplicates in the first column
awk -F'\t' 'BEGIN { OFS=FS }
NR==1 {print; next}
{
  if ($1 == "" || id[$1]++) $1 = ++max;
  else if ($1+0 > max) max = $1+0
  print
}' "$ascii" > "$a_file"

# Cleanup the unused files
rm -f "$tab" "$unix" "$decimal" "$ascii" "$final"