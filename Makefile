GITHUB_USER = aquarchitect
GITHUB_PAGES = gh-pages

MYKIT_FRAMEWORK = MyKit
MYKIT_REPOSITORY = github.com/$(GITHUB_USER)/$(MYKIT_FRAMEWORK).git

GENERATE_APPICON = generate_appicon
GIST_TOKEN = a6f09c2cac5dff2c0286e9785dc1db50

install:
	brew install jq
	brew unlink node && brew install npm
	npm install -g html-minifier clean-css
	gem install jazzy xcpretty

test:
	@ xcodebuild test \
		-verbose \
		-project "$(MYKIT_FRAMEWORK).xcodeproj" \
    	-scheme "$(MYKIT_FRAMEWORK)-$(SCHEME)" \
    	-sdk "$(SDK)" \
    	-destination "$(DESTINATION)" \
    	-configuration Debug \
    	CODE_SIGN_IDENTITY="" \
    	CODE_SIGNING_REQUIRED=NO \
    	ONLY_ACTIVE_ARCH=NO \
    	GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
    	GCC_GENERATE_TEST_COVERAGE_FILES=YES \
    	| xcpretty

docs:
	jazzy

	@ for file in $$(find docs -type f \( -name "*.html" -or -name "*.css" \)); do \
		echo "Minifying $$file ..."
		case $${file##*.} in \
			html) cat $$file | html-minifier --collapse-whitespace -o $$file;; \
			css) cat $$file | cleancss --s0 -o $$file;; \
		esac \
	done

	git config --global user.name "Hai Nguyen"
	git config --global user.email "aquarchitecture@gmail.com"

	@ echo "Pushing back to gh-pages branch ..."
	@ cd docs && \
		git init && \
		git add . && \
		git commit -m "Published #$(TRAVIS_BUILD_NUMBER)" && \
		git remote add origin https://$(GITHUB_TOKEN)@$(MYKIT_REPOSITORY) && \
		git push -f origin master:$(GITHUB_PAGES) \
		> /dev/null 2>&1