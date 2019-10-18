var=1
while true ; do
  res=$( { curl -o /dev/null -s -w %{time_namelookup}\\n  http://www.google.com; } 2>&1 )
  var=$((var+1))
  if [[ $res =~ ^[1-9] ]]; then
    # DNS resolution took more than 1 second
    now=$(date +"%T")
    echo "$var slow: $res $now"
    break
  fi
done