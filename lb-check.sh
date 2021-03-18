#!/bin/bash

# Eltávolítom a korábbi logokat
rm curl.log
rm count.log

# Egy while ciklussal 100x meg"curlingelem" az LB-et, és a válaszokat lementem egy logba
load=1

while [ $load -le 30 ]
do
  curl -v $1 >> curl.log 2>&1
  load=$(( $load + 1 ))
  echo $load
done

# az ETagokat vágom ki a logból, ez tartalmazza a serverek egyedi instance-ID-ját és ezek alapján számolok
grep 'ETag' curl.log | cut -d ":" -f 2 | sort | uniq -c >> count.log

# változókba mentem a szétbontott count.log -ot
valasz=$( cat count.log | cut -d '"' -f 1 )
server=$( cat count.log | cut -d '"' -f 2 )

# ezeket a változókat tömbé formálom, hogy külön-külön hozzáférjek az adatokhoz
v=($valasz)
s=($server)

# visszaadja a tömb méretét
y=${#v[@]}

echo "-----------------------------------------------------------"
echo $y "Servers we have behind the Load-Balancer."
echo "-----------------------------------------------------------"

i=0

#a szétbontott és mentett adatokat összetársítva kiiratom.

for i in ${!s[@]}; do
      echo "ServerID: "${s[$i]}",  Give it answers:" ${v[$i]}
      echo "-----------------------------------------------------------"
done
