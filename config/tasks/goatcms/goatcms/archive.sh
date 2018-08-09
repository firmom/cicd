#!/bin/sh
set -e

rm /data/archive/goatcms/goatcms/goatcms-latest
cp /data/archive/goatcms/goatcms/goatcms-latest-dev /data/archive/goatcms/goatcms/goatcms-latest
cp /data/archive/goatcms/goatcms/goatcms-latest "/data/archive/goatcms/goatcms/goatcms-$(date +%Y%m%d_%H%M%S)"
