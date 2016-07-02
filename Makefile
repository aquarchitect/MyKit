install:
	brew unlink node && brew install npm
	npm install -g html-minifier clean-css
	gem install jazzy

xcodetest:
	@ xcodebuild clean test								\
		-verbose										\
		-project MyKit.xcodeproj						\
		-scheme "MyKit-$(SCHEME)"						\
		-sdk "$(SDK)"									\
		-toolchain com.apple.dt.toolchain.XcodeDefault	\
		-configuration Debug							\
		-destination "$(DESTINATION)"					\
		CODE_SIGN_IDENTITY=""							\
		CODE_SIGNING_REQUIRED=NO						\
		ONLY_ACTIVE_ARCH=NO								\
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES			\
		GCC_GENERATE_TEST_COVERAGE_FILES=YES			\
		| xcpretty

xcodebuild:
	@ xcodebuild clean build							\
		-verbose										\
		-project MyKit.xcodeproj						\
		-target "$(TARGET)"			 					\
		-sdk "$(SDK)"									\
		-toolchain com.apple.dt.toolchain.XcodeDefault	\
		-configuration Release							\
		OBJROOT=$$(pwd)/build							\
		SYMROOT=$$(pwd)/build							\
		CODE_SIGN_IDENTITY=""							\
		CODE_SIGNING_REQUIRED=NO						\
		ONLY_ACTIVE_ARCH=NO								\
		| xcpretty

packages:
	@ echo ">>> Packaging MyKit framework for iOS plateform..."
	@ $(MAKE) xcodebuild TARGET=MyKit-iOS SDK=iphoneos9.3
	@ $(MAKE) xcodebuild TARGET=MyKit-iOS SDK=iphonesimulator9.3

	cp -r build/Release-iphoneos iOS
	cp -r build/Release-iphonesimulator/MyKit.framework/Modules/MyKit.swiftmodule/ \
		iOS/MyKit.framework/Modules/MyKit.swiftmodule

	lipo -create -output iOS/MyKit.framework/MyKit 			\
		build/Release-iphoneos/MyKit.framework/MyKit 		\
		build/Release-iphonesimulator/MyKit.framework/MyKit \

	zip -r MyKit-iOS.zip iOS

	@ echo ">>> Packaging MyKit framework for OSX plateform..."
	@ $(MAKE) xcodebuild TARGET=MyKit-OSX SDK=macosx10.11

	cp -r build/Release OSX
	zip -r MyKit-OSX.zip OSX

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
	@ cd docs &&																			\
		git init &&																			\
		git add . &&																		\
		git commit -m "Published on $$(date +%D)" &&										\
		git remote add origin https://$(GITHUB_TOKEN)@github.com/aquarchitect/MyKit.git &&	\
		git push -f origin master:gh-pages													\
		> /dev/null 2>&1