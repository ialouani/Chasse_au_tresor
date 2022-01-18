#!/bin/bash
base=CarnetsDeVoyage
filtrage(){
    echo $base/19[7-9][0-9][-_][ABCDEFGHIJKLMNOPQRSTUVXWYZ]* | tr " " "\n"  | cut -d'/' -f2
}
identify_rep(){
    rep=$base/$1
    size_0=$(echo $(du -s $rep) | cut -d' ' -f1)
    for i in $*;do
	if [ -d $base/$i ];then
	    size=$(echo $(du -s $base/$i) | cut -d' ' -f1)
	    if [ "$size" > "$size_0" ];then
		rep=$base/$i
		size_0=$(echo $(du -s $rep) | cut -d' ' -f1)
		fi
	fi
    done
    echo $rep
}
find_itineraries(){
    find $1 -type f -name "*Itineraire*"
}
find_signature(){
    for i in $*;do
	grep Bilbon $i > /dev/null
	var=$?
	if [ "$var" == "0" ];then
	    anagramme=$(cat $i | grep à | sort | head -n3 | cut -c1 | tr -d '\n')
	    if [ "$anagramme" == "CEL" ];then
		cle=$i
	    fi
	fi
    done
    echo $cle
}
rep=$( identify_rep $( filtrage ) )
key=$( find_signature $( find_itineraries $rep ) )
cat $key | sort -k 3,3 | grep . > Itineraire_trie.txt
cat Itineraire_trie.txt | head -n2 > Itineraire_trie_compact.txt
mots=$( cat Itineraire_trie_compact.txt | head -n1 | awk -F " " '{print $3}' )
mots+=" $( cat Itineraire_trie_compact.txt | head -n2 | tail -n1 | awk -F " " '{print $3}' )"
rm Itineraire_trie.txt && rm Itineraire_trie_compact.txt
tresor=$( echo $mots | tr " " "/" )
tresor_1=$base/$tresor
tresor_2=$tresor_1/$(ls $tresor_1)
tresor_3=$tresor_2/$(ls $tresor_2)
echo $tresor && cat $tresor_3
