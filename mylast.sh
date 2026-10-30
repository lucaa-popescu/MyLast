#!/bin/bash

#variabile pentru setari de baza
limita=0
mod="last"
#fisierele unde sistemul tine logurile de autentificare
fisiere_log="/var/log/auth.log /var/log/auth.log.1"

while [ "$#" -gt 0 ]; do
	case "$1" in
		-n)
			limita=$2
			shift 2
			;;
		lastb)
			mod="lastb"
			shift
			;;
		last)
			mod="last"
			shift
			;;
		*)
			shift
			;;
		esac
	done

if [ "$mod" == "last" ]; then
	tipar="session opened|Accepted password"
else
	tipar="Failed password|authentification failure"
fi

echo "utilizator | terminal | data si ora"
echo "---------------------------------"

date_brute=$(zgrep -E "$tipar" $fisiere_log 2>/dev/null |sort -r)

if [ "$limita" -gt 0 ]; then
	final=$(echo "$date_brute" | head -n "$limita")
else
	final="$date_brute"
fi

echo "$final" | awk '{print $9, "\t", $2, $1, $3}'
