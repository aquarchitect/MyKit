GITHUB_USER = aquarchitect
GITHUB_PAGES = gh-pages

MYKIT_FRAMEWORK = MyKit
MYKIT_REPOSITORY = github.com/$(GITHUB_USER)/$(MYKIT_FRAMEWORK).git

install:
	brew unlink node && brew install npm
	npm install -g html-minifier clean-css
	gem install jazzy

test:
	@ xcodebuild clean test								\
		-verbose										\
		-project $(MYKIT_FRAMEWORK).xcodeproj			\
    	-scheme $(MYKIT_FRAMEWORK)-$(SCHEME)			\
    	-sdk $(SDK)										\
    	-toolchain com.apple.dt.toolchain.XcodeDefault	\
    	-configuration Debug							\
    	-destination $(DESTINATION)						\
    	CODE_SIGN_IDENTITY=""							\
    	CODE_SIGNING_REQUIRED=NO						\
    	ONLY_ACTIVE_ARCH=NO								\
    	GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES			\
    	GCC_GENERATE_TEST_COVERAGE_FILES=YES			\
    	| xcpretty

package:
	@ xcodebuild clean build							\
		-verbose										\
		-project $(MYKIT_FRAMEWORK).xcodeproj			\
		-target $(MYKIT_FRAMEWORK)-iOS 					\
		-target $(MYKIT_FRAMEWORK)-OSX					\
		-toolchain com.apple.dt.toolchain.XcodeDefault	\
		-configuration Release							\
		-parallelizeTargets								\
		OBJROOT=$$(pwd)/build							\
		SYMROOT=$$(pwd)/build							\
		CODE_SIGN_IDENTITY=""							\
    	CODE_SIGNING_REQUIRED=NO						\
    	ONLY_ACTIVE_ARCH=NO								\
    	| xcpretty

	mv build/Release OSX && zip -r $(MYKIT_FRAMEWORK)-OSX.zip OSX
	mv build/Release-iphoneos iOS && zip -r $(MYKIT_FRAMEWORK)-iOS.zip iOS

jazzy:
	jazzy

	@ for file in $$(find docs -type f \( -name "*.html" -or -name "*.css" \)); do 	\
		echo ">>> Minifying $$file ...";											\
		case $${file##*.} in 														\
			html) cat $$file | html-minifier --collapse-whitespace -o $$file;;		\
			css) cat $$file | cleancss --s0 -o $$file;;								\
		esac																		\
	done

	git config --global user.name "Hai Nguyen"
	git config --global user.email "aquarchitecture@gmail.com"

	@ echo ">>> Pushing to gh-pages branch ..."
	@ cd docs &&																\
		git init &&																\
		git add . &&															\
		git commit -m "Published on $$(date +%D)" &&							\
		git remote add origin https://$(GITHUB_TOKEN)@$(MYKIT_REPOSITORY) &&	\
		git push -f origin master:$(GITHUB_PAGES)								\
		> /dev/null 2>&1