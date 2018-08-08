#!/bin/sh
set -e

zip -r "/data/archive/gameinpl/beerpoly/beerpoly-$(date +%Y%m%d_%H%M%S).zip" "/data/code/gameinpl/beerpoly/dist"
