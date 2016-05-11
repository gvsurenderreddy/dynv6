#!/bin/sh -e

ipv6n="$(ip -6 addr list scope global | grep -E 'inet6 [0-9a-f:]+/' | sed -r 's/^ *inet6 ([0-9a-f:]+)\/.*/\1/' | head -n 1)"

[ -z "$ipv6n" ] && \
	exit 1

[ -f "$DYNV6_ADDRPATH" ] && \
	ipv6o="$(cat "$DYNV6_ADDRPATH")"

if [ "$ipv6o" != "$ipv6n" ]
then
	echo "$ipv6n" >"$DYNV6_ADDRPATH"

	curl -s -S -f \
		"https://dynv6.com/api/update?hostname=$DYNV6_HOSTNAME&ipv6=$ipv6n&token=$DYNV6_TOKEN" \
		"https://ipv4.dynv6.com/api/update?hostname=$DYNV6_HOSTNAME&ipv4=auto&token=$DYNV6_TOKEN"
fi
