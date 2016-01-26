#!/usr/bin/env bash

[ $(basename $(pwd) != "MyKit") ] && { echo "Only run on the project's root directory."; exit 1; }
[ ! -z '$(git status -s)' ] && { echo "Jazzy process requires a clean directory."; exit 1; }

# generate documentation
echo "Start documentation generation process..."

jazzy \
   -c \
   --author HaiNguyen \
   --author_url https://aquarchitect.github.io \
   --github_url https://github.com/aquarchitect/MyKit \
   --module-version 0.9.2 \
   --output ~/Documents/X-code/MyKit/docs/ \
   --skip-undocumented \
   --readme ~/Documents/X-code/MyKit/README.md \

# clean up main
rm -r build/

# forward files into gh-pages branch
git add docs/
git stash
git checkout gh-pages
git stash pop

# clean up gh-pages directory
rsync -avr --remove-source-files docs/* . && rm -r docs

# git with gh-pages
if [[ ! -z $(git status -s) ]]; then
   git add .
   git commit -m "Generated on $(date "+%m-%d-%Y")"
   git push -u origin gh-pages
fi

git checkout master