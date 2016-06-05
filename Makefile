GITHUB_USER = aquarchitect
GITHUB_PAGES = gh-pages

MYKIT_FRAMEWORK = MyKit
MYKIT_REPOSITORY = github.com/$(GITHUB_USER)/$(MYKIT_FRAMEWORK).git

GENERATE_APPICON = generate_appicon
GIST_TOKEN = a6f09c2cac5dff2c0286e9785dc1db50

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

fetch:
	@ echo "Downloading $(GENERATE_APPICON) script ..."
	@ git clone https://gist.github.com/$(GIST_TOKEN).git $(GENERATE_APPICON) > /dev/null 2>&1

docs:
	jazzy
	git config --global user.name "Hai Nguyen"
	git config --global user.email "aquarchitecture@gmail.com"

	@ echo "Pushing back to gh-pages branch ..."
	@ cd docs && \
		git init && \
		git add . && \
		git commit -m "Published #$(TRAVIS_BUILD_NUMBER)" && \
		git remote add origin https://$(GITHUB_TOKEN)@$(MYKIT_REPOSITORY) && \
		git push -f origin master:$(GITHUB_PAGES) && \
		> /dev/null 2>&1

icons: AppIcon.pdf Demos
	chmod +x $(GENERATE_APPICON)/$(GENERATE_APPICON).sh
	@ for folder in $$(find Demos -type d -name "*.appiconset"); do \
 		$(GENERATE_APPICON)/$(GENERATE_APPICON).sh AppIcon.pdf $$folder; \
	done

	git config --global user.name "Hai Nguyen"
	git config --global user.email "aquarchitecture@gmail.com"

	@ git add Demos/ && \
		git commit -m "Generated app icons" && \
		git checkout -b $(GENERATE_APPICON) && \
		git push https://$(GITHUB_TOKEN)@$(MYKIT_REPOSITORY) $(GENERATE_APPICON):$(TRAVIS_BRANCH) && \
		> /dev/null 2>&1