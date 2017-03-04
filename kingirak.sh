#!/bin/bash

echo ""
echo "*****************************"
echo "*****************************"
echo "***       KİNGIRAK        ***"
echo "*****************************"
echo "*****************************"
echo ""
echo "Hedefe ait IP blogunda 80.port üzerinden kontroller sağlar."
echo " "
echo "./tara.sh alanadı"
echo " "
echo "Contact @m_altinkaynak"
echo " "

ip_address=`getent hosts $1 | awk '{ print $1 }'`
IFS='.' read -r -a array <<< "$ip_address"

echo "$(tput bold)$ip_address$(tput sgr0) ip adresine sahip $(tput bold)$(tput setaf 7)$1$(tput sgr0) taranıyor."

for ip in ${array[0]}.${array[1]}.${array[2]}.{0..255}
do 
    result=0
    result=$(curl --connect-timeout 1 --max-time 1 --header "Connection: keep-alive" -s -D - $ip -o /dev/null | awk 'NR==1{print $2}')
    if [[ $result -eq "200" ]]
    then
        aciklama="Sayfa bulundu"
    else
        aciklama="Bir şey bulunamadı."
    fi
    printf '%s %s %s\n' "$ip" "$aciklama" "$result"
done