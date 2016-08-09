define package-platform
	if [ "$(1)" == "iOS" ]; then 														\
		$(MAKE) xcodebuild TARGET=MyKit-iOS SDK=iphoneos9.3;							\
		$(MAKE) xcodebuild TARGET=MyKit-iOS SDK=iphonesimulator9.3;						\
		cp -r build/Release-iphoneos iOS;												\
		cp -r build/Release-iphonesimulator/MyKit.framework/Modules/MyKit.swiftmodule/ 	\
			iOS/MyKit.framework/Modules/MyKit.swiftmodule;								\
		lipo -create -output iOS/MyKit.framework/MyKit 									\
			build/Release-iphoneos/MyKit.framework/MyKit 								\
			build/Release-iphonesimulator/MyKit.framework/MyKit;						\
		zip -r MyKit-iOS.zip iOS;														\
	elif [ "$(1)" == "OSX" ]; then														\
		$(MAKE) xcodebuild TARGET=MyKit-OSX SDK=macosx10.11;							\
		cp -r build/Release OSX;														\
		zip -r MyKit-OSX.zip OSX;														\
	fi
endef

define minify-web
	file=$(1);																\
	case $${file##*.} in													\
		html) cat $$file | html-minifier --collapse-whitespace -o $$file;;	\
		css) cat $$file | cleancss --s0 -o $$file;;							\
	esac
endef

define commit-pages
	git init;																			\
	git add .;																			\
	git commit -m "$(1)";																\
	git remote add origin https://$(GITHUB_TOKEN)@github.com/aquarchitect/MyKit.git;	\
	git push -f origin master:gh-pages
endef

install:
	brew unlink node && brew install npm
	npm install -g html-minifier clean-css
	gem install jazzy

test:
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

build:
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
	@ echo ">>> Packaging MyKit for iOS ... "
	@ $(call package-platform,iOS)
	@ echo ">>> Packaging MyKit for OSX ... "
	@ $(call package-platform,OSX)

jazzy:
	@ jazzy
	@ export DOCS=$$(find docs \( -name "*.html" -or -name "*.css" \))
	@ for file in $(DOCS); do 				\
		echo ">>> Minifying $$file ... ";	\
		$(call minify-web,$$file);			\
	  done
	@ echo ">>> Push generated documentation to gh-pages branch ..."
	@ cd docs && $(call commit-pages,"Publish from TravisCI on $$(date +%D)") > /dev/null 2>&1

clean:
	@ if [ -d build ]; then rm -fr build; fi
	@ if [ -d iOS ]; then rm -fr iOS; fi
	@ if [ -d OSX ]; then rm -fr OSX; fi
