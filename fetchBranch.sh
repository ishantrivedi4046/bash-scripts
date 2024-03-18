#!/usr/bin/bash

set -euo pipefail

source ~/Documents/projects/scripts/colors.sh
git fetch $1 $2 && git checkout -b $2 $1/$2 
echo -e "${YELLOW}BRANCH ${GREEN}$(git rev-parse --abbrev-ref HEAD) fetched from ${YELLOW}$1"