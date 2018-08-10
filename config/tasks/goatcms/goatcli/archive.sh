#!/bin/sh
set -e

rm /data/archive/goatcms/goatcli/goatcli-latest
cp /data/archive/goatcms/goatcli/goatcli-latest-dev /data/archive/goatcms/goatcli/goatcli-latest
cp /data/archive/goatcms/goatcms/goatcli-latest "/data/archive/goatcms/goatcli/goatcli-$(date +%Y%m%d_%H%M%S)"
