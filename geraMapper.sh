#!/bin/bash
#script para transformar o out_roary em um arquivo mapper do deepath
# By João Pitta (jlpitta82@gmail.com)
# At FIOCRUZ-PE (Recife - PE)
# Thu 25 Nov 2021 20:24 BRT (Primeira versão)
# Versão 0.1

### INICIO: verificações iniciais ###

## Verifica se os parametros foram passados.
[ $# -ne 3 ] && { echo "Use: $0 Arquivo_out_roary arquivo com KOs"; exit 3 ; }
[ -f $1 ] || { echo "Use: Insira o arquivo do out_roary" ; exit 3 ; }
[ -f $2 ] || { echo "Use: Insira o arquivo com os KOs"; exit 3 ; }
[ -f $3 ] || { echo "Use: Insira o arquivo com a descrição dos KO (kos.kegg)"; exit 3 ; }

### Peparando dados: Remove e cria arquivos  ###
rm -f mapper.txt
inputList=$1
awk '{print $1}' $inputList > listagene.txt
cabecalho=$(echo -e "Feature;ProkkaID;ID;KO;Pathway")
echo -e "$cabecalho" > mapper.txt

### Inicio dos LOOPs ###

### Loop para gerar o arquivo tempmapper1 com o gene e os Ids do prokka
for i in `cat listagene.txt`; do
   gene=$(echo $i)
   echo -e "Processando o gene $gene"
   grep "$i" $inputList | sed 's/\t/\n/g' > tempProkka.txt
   sed '1d' tempProkka.txt -i
   for j in `cat tempProkka.txt`; do
      echo -e "$gene\t$j" >> tempmapper1.txt   
   done
done

### Loop 2 - Juntar a informação do gene, prokkaID e KO ###
kolist=$2
echo "Kolist é: $kolist"
awk '{print $1}' $kolist > listakoprokka.txt

for i in `cat listakoprokka.txt`; 
do
   linhatempmapper=$(grep "$i" tempmapper1.txt)
   echo "linhatempmapper é: $linhatempmapper"
   echo -e "$linhatempmapper" > tempmapper2.txt
   linhako=$(grep "$i" $kolist)
   echo -e "A linha de kolist é: $linhako"
   while read line;
   do
      echo -e "Linha Uniq é: $line"
      echo -e "Linha completa é: $line\t$linhako"
      echo -e "$line\t$linhako" >> tempmapper3.txt
   done < tempmapper2.txt
done

### Loop 3 - Adiciona a descrição do KO ### 
sed 's/\t/;/g' tempmapper3.txt | egrep '(.*)(:;)(.*)(;)(.*)(;)(.*)$' > tempmapper4.txt
cp tempmapper4.txt tempmapper5.txt
koskegg=$3
for KO in $(awk -F';' '{print $4}' tempmapper5.txt | sort -u);
do
   echo "Adicionando a descrição do KO: ${KO}"
   DESC=$(grep "${KO}" $koskegg | cut --bytes=16-1024 | sed -e "s|;| - |g")
   sed -i -e "s|;${KO}|;${KO};${DESC}|g" tempmapper5.txt
done

### Processamento final ###
cat tempmapper5.txt >> mapper.txt
sed 's/://' mapper.txt -i
rm -f tempProkka.txt listagene.txt tempmapper* listaprokka.txt listakoprokka.txt
echo "Processamento finalizado!"

