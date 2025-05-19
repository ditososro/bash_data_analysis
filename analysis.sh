#!/bin/bash

# PROJECT 2.3 (Analysis Script) - CITS4407
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

input_file="$1"

# 1. Most popular game mechanic
most_popular_mechanic=$(awk -F'\t' 'NR>1 && $13 != "" {
  n=split($13, mechanics, ", ")
  for (i=1; i<=n; i++) count[mechanics[i]]++
}
END {
  max=0
  for (m in count)
    if (count[m] > max) {
      max = count[m]
      top = m
    }
  print top, max
}' "$input_file")

# 2. Most popular game domain
most_popular_domain=$(awk -F'\t' 'NR>1 && $14 != "" {
  n=split($14, domains, ", ")
  for (i=1; i<=n; i++) count[domains[i]]++
}
END {
  max=0
  for (d in count)
    if (count[d] > max) {
      max = count[d]
      top = d
    }
  print top, max
}' "$input_file")

# 3. Pearson correlation: Year Published vs Rating Average
corr_year_rating=$(awk -F'\t' '
# Skip rows where Year Published or Rating Average is missing
NR>1 && $3 != "" && $9 != "" {
  n++
  x += $3
  y += $9
  xx += $3 * $3
  yy += $9 * $9
  xy += $3 * $9
}
END {
  if (n > 1) {
    cov = xy/n - (x/n)*(y/n)
    sd_x = sqrt(xx/n - (x/n)^2)
    sd_y = sqrt(yy/n - (y/n)^2)
    if (sd_x > 0 && sd_y > 0)
      print cov / (sd_x * sd_y)
    else
      print "NA"
  } else
    print "NA"
}' "$input_file")

# 4. Pearson correlation: Complexity Average vs Rating Average
corr_complexity_rating=$(awk -F'\t' '
NR>1 && $11 != "" && $9 != "" {
  n++
  x += $11
  y += $9
  xx += $11 * $11
  yy += $9 * $9
  xy += $11 * $9
}
END {
  if (n > 1) {
    cov = xy/n - (x/n)*(y/n)
    sd_x = sqrt(xx/n - (x/n)^2)
    sd_y = sqrt(yy/n - (y/n)^2)
    if (sd_x > 0 && sd_y > 0)
      print cov / (sd_x * sd_y)
    else
      print "NA"
  } else
    print "NA"
}' "$input_file")

# 5. Output the results
echo "The most popular game mechanics is ${most_popular_mechanic}"
echo "The most popular game domain is ${most_popular_domain}"
echo "The correlation between the year of publication and the average rating is ${corr_year_rating}"
echo "The correlation between the complexity of a game and its average rating is ${corr_complexity_rating}"




