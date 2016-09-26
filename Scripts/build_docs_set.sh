#!/bin/sh

if [ ! -f .jazzy.yaml ]; then
    echo "error: - Could not find .jazzy.yaml. in $(pwd)" >&2
    exit 1
fi

if [ -z $GITHUB_TOKEN ]; then
    echo "error: - Could not find GitHub token." >&2
    exit 1
fi

git clone -b gh-pages https://github.com/aquarchitect/MyKit.git docs

echo ">>> Generating documentation sets ..."
jazzy

echo ">>> Minifying web files ..."
for file in $(find docs \( -name "*.html" -or -name "*.css" \)); do
    case ${file##*.} in
		html) cat $file | html-minifier --collapse-whitespace -o $file;;
		css) cat $file | cleancss --s0 -o $file;;
	esac
done

echo ">>> Commiting generated documentation ..."
git add .
git commit -m "Travis update on $(date +%D)"
git remote add upstream https://$GITHUB_TOKEN@github.com/aquarchitect/MyKit.git
git push upstream gh-pages
