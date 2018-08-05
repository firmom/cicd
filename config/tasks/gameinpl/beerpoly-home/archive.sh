#!/bin/sh
set -e

zip -r "data/archive/gameinpl/beerpoly-home/beerpoly-home-$(date +%Y%m%d_%H%M%S).zip" "data/code/gameinpl/beerpoly-home"
