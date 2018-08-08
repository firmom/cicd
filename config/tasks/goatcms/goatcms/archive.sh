#!/bin/sh
set -e

rm "/data/archive/goatcms/goatcms/latest.zip"
zip -r "/data/archive/goatcms/goatcms/latest.zip" "/go/bin/goatcms"
cp "/data/archive/goatcms/goatcms/latest.zip" "/data/archive/goatcms/goatcms/goatcms-$(date +%Y%m%d_%H%M%S).zip"
