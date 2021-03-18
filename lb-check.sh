#!/bin/bash


rm curl.log
rm count.log


load=1

while [ $load -le 30 ]
do
  curl -v $1 >> curl.log 2>&1
  load=$(( $load + 1 ))
  echo $load
done

grep 'ETag' curl.log | cut -d ":" -f 2 | sort | uniq -c >> count.log

valasz=$( cat count.log | cut -d '"' -f 1 )
server=$( cat count.log | cut -d '"' -f 2 )


v=($valasz)
s=($server)


y=${#v[@]}

echo "-----------------------------------------------------------"
echo $y "Servers we have behind the Load-Balancer."
echo "-----------------------------------------------------------"

i=0

for i in ${!s[@]}; do
      echo "ServerID: "${s[$i]}",  Give it answers:" ${v[$i]}
      echo "-----------------------------------------------------------"
done
