#!/bin/bash
#script para pegar os pathways (nível C do ko00001.kegg) a partir do KOs e adicionar ao mapper
# By João Pitta (jlpitta82@gmail.com)
# At Home (Recife - PE)
# Thu 09 Dec 2021 22:44 BRT (Primeira versão)
# Versão 0.1

rm -f tempMapperPath.txt mapperPath.txt 
cp mapper.txt tempMapperPath.txt
sed '1d' tempMapperPath.txt -i
echo "Feature;ProkkaID;ID;KO;KO_Description;Pathway" > mapperPath.txt

### LOOP juntando arquivos ####

while read LINE;
do
   #echo "Linha mapper.txt = $LINE"
   KO=$(echo "$LINE" | awk -F";" '{print $4}')
   echo "KO = $KO"
   KOPATH=$(grep "$KO" koPath.txt | awk -F";" '{print $2}')
   echo "$KOPATH" > tempKOPath.txt
   while read PATHLIST;
   do
      echo "KOPATH = $KOPATH"
      echo "PATHLIST = $PATHLIST"
    #  LINHAPATHLIST=$(echo "$PATHLIST")
    #  echo "PATHLIST = $LINHAPATHLIST"
      echo "Linha final = $LINE;$PATHLIST"
      echo "$LINE;$PATHLIST" >> mapperPath.txt
   done < tempKOPath.txt
   #sleep 2
done < tempMapperPath.txt

### Limpando arquivos ###
rm -f tempKOPath.txt tempMapperPath.txt
