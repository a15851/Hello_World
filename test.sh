#!/usr/bin/env bash

INPUT_FILE="$1"

declare -A daily_result
declare -A ip_result

calculate_requests_per_day () {
  echo 'requests per day'
  echo '----------------'

  while read -r line
  do
      line1="echo $line| sed 's/\\ /_/g'"
      # Set space as the delimiter
      IFS='['
      #Read the split words into an array based on space delimiter
      read -a strarr_a <<< "$line1"

      # Set space as the delimiter
      IFS=':'
      #Read the split words into an array based on ':' delimiter
      read -a strarr_b <<< "${strarr_a[1]}"

      date=${strarr_b[0]}

      date="${date##}"
      date="${date%%}"
      if [ -n "$date" ]
      then
          ((daily_result[$date]++))
      fi
  done < "$LOG_FILE"

  for k in "${!daily_result[@]}"
  do
    #echo ${daily_result["$k"]} ${k}
        echo "${daily_result["$k"]}" "${k}"
  done | sort -rn | head -10
}

calculate_requests_per_ip () {
  echo 'requests per IP'
  echo '---------------'

  while IFS= read -r line
  do
    # Set space as the delimiter
    IFS=' -'
    #Read the split words into an array based on space delimiter
    read -a ip_add <<< "$line"

    ip="${ip_add[0]##}"
    ip="${ip%%}"
    if [ -n "$ip" ]
    then
        ((ip_result[$ip]++))
    fi
  done < "$LOG_FILE"

  for k in "${!ip_result[@]}"
  do
    #echo ${ip_result["$k"]} ${k}
        echo "${ip_result["$k"]}" "${k}"
    done | sort -rn | head -10
}

LOG_FILE="input.log"
sed 's/[\]//g' "$INPUT_FILE" > "$LOG_FILE"
calculate_requests_per_day
calculate_requests_per_ip
rm "$LOG_FILE"
