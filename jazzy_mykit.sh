#!/usr/bin/env bash

if [[ $(basename $(pwd)) != "MyKit" ]]; then
	echo "Only run on the project's root directory"
	exit 1
fi

# ensure a clean directory because new changes will be stashes to gh-pages branch
read -p 'Ensure the working directory clearn! Continue the process? [y|n]: ' answer
answer=$(tr '[:upper:]' '[:lower:]' <<< $answer)

# exit early
if [[ ${answer:0:1} == "n" ]]; then
	echo 'Documentation generating process terminated!'
	exit 1
fi

if [[ ${answer:0:1} != "y" ]]; then
	echo 'Invalid answer! Jazzy terminated!'
	exit 1
fi

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

# forward files into gh-pages branch
git checkout gh-pages

# clean up directory
rm -r build && mv docs/* . && rm -r docs

# git on gh-pages
git add .
git commit -m "Generated on $(date "+%m-%d-%Y")"
git push -u origin gh-pages

git checkout master
