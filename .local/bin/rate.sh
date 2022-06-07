#!/bin/sh
currency="$1"
rate="$(curl -Ls gbp.rate.sx/1$currency)"
rate_rounded="$(echo "$rate" | awk '{printf "%0.2f", $1 "\n"}')"
echo "1 $currency = £$rate_rounded"
