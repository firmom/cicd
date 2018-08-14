#!/bin/bash
set -e

killall goatcms-latest-dev || echo "Process is not exist"
cd /data/serve/goatcms/goatcms
mkdir -p /data/archive/logs/goatcms/
/data/archive/goatcms/goatcms/goatcms-latest-dev run > /data/archive/logs/goatcms/goatcms.log 2>&1 &
