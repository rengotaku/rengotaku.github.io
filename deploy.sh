#!/bin/sh

# If a command fails then the deploy stops
set -e

git checkout html

printf "\033[0;32m%s\033[0m\n" "Deploying updates to GitHub..."

cd hugo && HUGO_ENV=production hugo -v -d ../docs && cd -

printf "\033[0;32m%s\033[0m\n" "Done hugo..."

git add .

msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

git push origin html
