#!/bin/bash
set -e

echo $PATH
cd /go/src/github.com/goatcms/goatcms
dep ensure
