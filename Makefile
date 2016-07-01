GITHUB_USER = aquarchitect
GITHUB_PAGES = gh-pages

MYKIT_FRAMEWORK = MyKit
MYKIT_REPOSITORY = github.com/$(GITHUB_USER)/$(MYKIT_FRAMEWORK).git
MYKIT_SCHEME=$(MYKIT_FRAMEWORK)-$(SCHEME)

install:
	brew unlink node && brew install npm
	npm install -g html-minifier clean-css
	gem install jazzy

xcodebuild:
	xcodebuild clean $(ACTION) \
		-verbose \
		-project $(MYKIT_FRAMEWORK).xcodeproj \
    	-scheme $(MYKIT_SCHEME) \
    	-sdk $(SDK) \
    	-toolchain com.apple.dt.toolchain.XcodeDefault \
    	-configuration $(CONFIGURATION) \
    	$(DESTINATION_OPTION) \
    	OBJROOT=$$(pwd)/build \
    	SYMROOT=$$(pwd)/build \
    	CODE_SIGN_IDENTITY="" \
    	CODE_SIGNING_REQUIRED=NO \
    	ONLY_ACTIVE_ARCH=NO \
    	GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
    	GCC_GENERATE_TEST_COVERAGE_FILES=YES \
    	| xcpretty

packages:
	mv build/$(PRODUCT) build/$(MYKIT_SCHEME)
	zip -r $(MYKIT_SCHEME).zip build/$(MYKIT_SCHEME)

jazzy:
	jazzy

	@ for file in $$(find docs -type f \( -name "*.html" -or -name "*.css" \)); do \
		echo ">>> Minifying $$file ..."; \
		case $${file##*.} in \
			html) cat $$file | html-minifier --collapse-whitespace -o $$file;; \
			css) cat $$file | cleancss --s0 -o $$file;; \
		esac \
	done

	git config --global user.name "Hai Nguyen"
	git config --global user.email "aquarchitecture@gmail.com"

	@ echo ">>> Pushing to gh-pages branch ..."
	@ cd docs && \
		git init && \
		git add . && \
		git commit -m "Published on $$(date +%D)" && \
		git remote add origin https://$(GITHUB_TOKEN)@$(MYKIT_REPOSITORY) && \
		git push -f origin master:$(GITHUB_PAGES) \
		> /dev/null 2>&1