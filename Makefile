GITHUB_USER = aquarchitect

MYKIT_REPOSITORY = github.com/$(GITHUB_USER)/MyKit.git
GENERATE_APPICON = generate_appicon
GIST_TOKEN = a6f09c2cac5dff2c0286e9785dc1db50

test:
	xcodebuild test \
		-verbose \
		-project "$(FRAMEWORK).xcodeproj" \
    	-scheme "$(FRAMEWORK)-$(SCHEME)" \
    	-sdk "$(SDK)" \
    	-destination "$(DESTINATION)" \
    	-configuration Debug \
    	CODE_SIGN_IDENTITY="" \
    	CODE_SIGNING_REQUIRED=NO \
    	ONLY_ACTIVE_ARCH=NO \
    	GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
    	GCC_GENERATE_TEST_COVERAGE_FILES=YES \
    	| xcpretty \

fetch:
	@ echo "Downloading $(GENERATE_APPICON) script ..."
	@ git clone https://gist.github.com/$(GIST_TOKEN).git $(GENERATE_APPICON) > /dev/null 2>&1

docs: $(PUBLIC_ARTIFACTS)
	jazzy
	git config --global user.name "Hai Nguyen"
	git config --global user.email "aquarchitecture@gmail.com"
	@ cd $(PUBLIC_ARTIFACTS) && \
		git add . && git commit -m "Published #$(TRAVIS_BUILD_NUMBER)" && \
		git push -f https://$(GITHUB_TOKEN)@$(MYKIT_REPOSITORY) && \
		> /dev/null 2>&1

icons: AppIcon.pdf Demos/Assets.xcassets
	@ find folder in $$(find Demos -type d -name "*.appiconset"); do \
		$(GENERATE_APPICON)/$(GENERATE_APPICON).sh AppIcon.pdf $$folder/Contents.json; \
	done