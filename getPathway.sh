#!/bin/bash
#script para pegar os pathways (nível C do ko00001.kegg) a partir do KOs
# By João Pitta (jlpitta82@gmail.com)
# At Home (Recife - PE)
# Thu 09 Dec 2021 16:24 BRT (Primeira versão)
# Versão 0.1

### INICIO: verificações iniciais ###

## Verifica se os parametros foram passados.
[ $# -ne 1 ] && { echo "Use: $0 Arquivo ko00001.kegg"; exit 3 ; }
[ -f $1 ] || { echo "Use: Insira o arquivo ko00001.kegg" ; exit 3 ; }

### Removendo o arquivo da execução anterior ###
rm -f koPath.txt

### LOOP Inicial ###
echo "INICIANDO PROCESSAMENTO..."
PATHWAY=$(echo "PATHWAY")
while read LINE;
do
   START=$(echo "$LINE" | awk '{print $1}')
   if [ "$START" == "C" ]; then
      PATHWAY=$(echo "$LINE" | sed 's/^C    //' | cut --bytes 7-1024)
   elif [ "$START" == "D" ]; then
      KO=$(echo "$LINE" | awk '{print $2}')
      echo "PATHWAY = $PATHWAY"
      echo "Linha KO = $KO"
      echo "Adicionando ao arquivo koPath.txt: $KO;$PATHWAY"
      echo "$KO;$PATHWAY" >> koPath.txt
   fi
   #sleep 1
done < $1
