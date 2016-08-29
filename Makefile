GITHUB_SECURE_URL = https://$(GITHUB_TOKEN)@github.com/aquarchitect/MyKit.git

define error-platform
	echo "Err: Unsupportive platform - $(1)";										\
	echo "Only support iOS and macOS!";												\
	exit 1
endef

define package-platform
	if [ "$(1)" == "iOS" ]; then 														\
		echo ">>> Packaging MyKit for iOS ... ";										\
		$(MAKE) xcbuild SCHEME=iOS SDK=iphoneos9.3;										\
		$(MAKE) xcbuild SCHEME=iOS SDK=iphonesimulator9.3;								\
		cp -r Build/Release-iphoneos iOS;												\
		cp -r Build/Release-iphonesimulator/MyKit.framework/Modules/MyKit.swiftmodule/ 	\
			iOS/MyKit.framework/Modules/MyKit.swiftmodule;								\
		lipo -create -output iOS/MyKit.framework/MyKit 									\
			Build/Release-iphoneos/MyKit.framework/MyKit 								\
			Build/Release-iphonesimulator/MyKit.framework/MyKit;						\
		zip -rq MyKit-iOS.zip iOS;														\
	elif [ "$(1)" == "macOS" ]; then													\
		echo ">>> Packaging MyKit for macOS ... ";										\
		$(MAKE) xcbuild SCHEME=macOS SDK=macosx10.11;									\
		cp -r Build/Release macOS;														\
		zip -rq MyKit-macOS.zip macOS;													\
	else																				\
		$(call error-platform,$(1));													\
	fi
endef
s
define minify-web
	file=$(1);																\
	echo ">>> Minifying $$file ... ";										\
	case $${file##*.} in													\
		html) cat $$file | html-minifier --collapse-whitespace -o $$file;;	\
		css) cat $$file | cleancss --s0 -o $$file;;							\
	esac
endef

define commit-pages
	echo ">>> Commiting generated documentation ...";	\
	git init;											\
	git add .;											\
	git commit -m "$(1)";								\
	git remote add upstream $(GITHUB_SECURE_URL);		\
	git push -f upstream master:gh-pages
endef

define commit-tag
	echo ">>> Commiting $(1) tag ... ";				\
	git remote add upstream $(GITHUB_SECURE_URL);	\
	git tag -a $(1) -m "$(2)";						\
	git push upstream $(1)
endef

define invalidate-tag
	if [[ ! $(1) =~ ^([0-9]+\.){2}[0-9]+ ]]; then		\
		echo "Error: Invalid version!" >&2 && exit 1;	\
	elif [ -z $(2) ]; then								\
		echo "Error: Invalid message!" >&2 && exit 2;	\
	fi
endef

install:
	brew unlink node && brew install npm
	npm install -g html-minifier clean-css
	gem install jazzy

xctest:
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

xcbuild:
	@ xcodebuild clean build							\
		-verbose										\
		-project MyKit.xcodeproj						\
		-target "MyKit-$(SCHEME)"			 			\
		-sdk "$(SDK)"									\
		-toolchain com.apple.dt.toolchain.XcodeDefault	\
		-configuration Release							\
		OBJROOT=$$(pwd)/Build							\
		SYMROOT=$$(pwd)/Build							\
		CODE_SIGN_IDENTITY=""							\
		CODE_SIGNING_REQUIRED=NO						\
		ONLY_ACTIVE_ARCH=NO								\
		| xcpretty

packages:
	@ if [ -z "$(PLATFORM)" ]; then				\
		$(call package-platform,iOS);			\
		$(call package-platform,macOS);			\
	  else										\
	  	$(call package-platform,$(PLATFORM));	\
	  fi
	$ $(MAKE) clean

jazzy:
	@ echo ">>> Generating documentation ... "
	@ jazzy
	@ if true; then 												\
		doc=$$(find docs \( -name "*.html" -or -name "*.css" \));	\
		for file in $$doc; do $(call minify-web,$$file); done;		\
	  fi
	@ if true; then													\
		msg="Publish from TravisCI on $$(date +%D)";				\
		cd docs && $(call commit-pages,$$msg) > /dev/null 2>&1;		\
	  fi

tag:
	@ if true; then	\
		version=$$(echo $(MESSAGE) | awk -F '[][]' '{print $$4}');	\
		message=$$(echo $(MESSAGE) | awk -F '[][]' '{print $$5}');	\
		$(call invalidate-tag,$$version,$$message);					\
		$(call commit-tag,$$version,$$message) > /dev/null 2>&1;	\
	  fi

clean:
	@ if [ -d Build ]; then rm -fr Build; fi
	@ if [ -d iOS ]; then rm -fr iOS; fi
	@ if [ -d macOS ]; then rm -fr macOS; fi
