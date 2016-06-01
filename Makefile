GITHUB_BRANCH = gh_pages
PUBLIC_ARTIFACTS = docs

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
	@ echo "Downloading $(GITHUB_BRANCH) branch..."
	@ git clone -b $(GITHUB_BRANCH) https://$(GITHUB_TOKEN)@github.com/aquarchitect/MyKit.git $(PUBLIC_ARTIFACTS) >/dev/null 2>&1

docs: $(PUBLIC_ARTIFACTS)
	jazzy
	git config --global user.name "Hai Nguyen"
	git config --global user.email "aquarchitecture@gmail.com"
	cd $(PUBLIC_ARTIFACTS) && git add . && git commit -m "Published $(TRAVIS_BUILD_NUMBER)" && git push