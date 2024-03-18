#!/usr/bin/bash

set -euo pipefail

source ~/Documents/projects/scripts/colors.sh
git fetch $1 && git reset --hard $(git log -n 1 --pretty=format:"%H" $1/$(git rev-parse --abbrev-ref HEAD))
echo -e "${YELLOW}BRANCH ${GREEN}$(git rev-parse --abbrev-ref HEAD) ${YELLOW}SYNCHED"