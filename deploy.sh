#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

cd hugo && HUGO_ENV=production hugo -v -d ../docs && cd -

git add .

msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

git push origin master
