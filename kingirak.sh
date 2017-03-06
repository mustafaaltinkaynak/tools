#!/bin/bash

set -eo pipefail; [[ -z $TRACE ]] || set -x

usage() {
	cat >&2 <<-EOF
	*****************************
	*****************************
	***       KİNGIRAK        ***
	*****************************
	*****************************

	Hedefe ait IP blogunda 80.port üzerinden kontroller sağlar.

	./tara.sh alanadı

	Contact @m_altinkaynak

	EOF
	exit 128
}

die() {
	echo >&2 "$@"
	exit 1
}

bold() {
	echo -e "\e[1m$1\e[0m"
}

get() {
	local result
	result=$(
		curl --connect-timeout 1 \
		     --max-time 1 \
		     --header "Connection: keep-alive" \
		     -s -D - "$1" -o /dev/null |
		awk 'NR==1{print $2}'
	)
    if [[ $result =~ ^-?[0-9]+$ ]] ;
    then
        echo >&2 "$(bold "$result") Sayfa bulundu."
    else
        echo "Sayfa bulunamadı."
    fi
}

resolv() {
	local addr
	addr=$(host "$1" 2>/dev/null || true)
	echo "$addr" | awk 'NR == 1 { print $4 }'
}

main() {
	[[ $# -ne 0 ]] || usage

	local domain=$1
	local addr
	local ip
	local desc
	local octets

	addr=$(resolv "$domain")
	IFS='.' read -r -a octets <<<"$addr"

	echo >&2 "$(bold "$addr") ip adresine sahip $(bold "$domain") taranıyor."

	for ip in ${octets[0]}.${octets[1]}.${octets[2]}.{0..255}; do
		printf '%s %s %s\n' "$ip" "$(get "$ip")"
	done
}

[[ "${BASH_SOURCE[0]}" != "$0" ]] || main "$@"