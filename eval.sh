#!/bin/bash

if [ -f avg_p.txt ] ; then
    rm avg_p.txt
fi
if [ -f avg_s.txt ] ; then
    rm avg_s.txt
fi
if [ -f results.txt ] ; then
    rm results.txt
fi

for file in ./db/*.mat; do
	suf="m.mat"
    foo=${file%"$suf"}
	echo $foo
    [ -f "$file" ] || break
    wrann -r "$foo" -a qrs <"$foo".asc
	bxb -r "$foo" -a atr qrs -c results.txt 
done

grep -Po 'QRS sensitivity:\K[^%]+' results.txt > avg_s.txt
sensitivity=$(awk '{T+= $NF} END { print T/NR }' avg_s.txt) 

grep -Po 'QRS positive predictivity:\K[^%]+' results.txt > avg_p.txt
predictivity=$(awk '{T+= $NF} END { print T/NR }' avg_p.txt)

printf "Algorithm QRS sensitivity: %s\nAlgorithm QRS positive predictivity: %s\n\n\n%s\n" "$sensitivity" "$predictivity" "RESULTS"| cat - results.txt > temp && mv temp results.txt

    rm avg_s.txt

    rm avg_p.txt

