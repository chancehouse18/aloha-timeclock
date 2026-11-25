#!/bin/zsh
# Encrypts the time clock and publishes it to GitHub Pages.
# Usage: ./deploy.sh ["commit message"]
# Password lives in .timeclock-password (change it there, then redeploy).
set -e
cd "$(dirname "$0")"
export npm_config_cache="${TMPDIR:-/tmp}/npm-cache-aloha"
PASS="$(cat .timeclock-password)"
MSG="${1:-Update time clock}"
npx -y staticrypt timeclock.html -p "$PASS" --remember 365 \
  --template-title "Aloha Time Clock" \
  --template-instructions "Enter the time clock password" \
  -d .encrypted
cp .encrypted/timeclock.html index.html
git add index.html
git commit -m "$MSG" --quiet || echo "nothing to commit"
git push origin main
echo "Deployed (encrypted): https://chancehouse18.github.io/aloha-timeclock/"
