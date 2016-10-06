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

define commit-tag
	echo ">>> Commiting $(1) tag ... ";				\
	git remote add upstream $(GITHUB_SECURE_URL);	\
	git tag -a $(1) -m "$(2)";						\
	git push upstream $(1)
endef

xctest:
	@ xcodebuild clean test								\
		-scheme "MyKit-$(SCHEME)"						\
		-configuration Debug							\
		-destination "$(DESTINATION)"					\
		CODE_SIGN_IDENTITY=""							\
		CODE_SIGNING_REQUIRED=NO						\
		| xcpretty

xcbuild:
	@ xcodebuild clean build							\
		-target "MyKit-$(SCHEME)"			 			\
		-configuration Release							\
		OBJROOT=$$(pwd)/Build							\
		SYMROOT=$$(pwd)/Build							\
		CODE_SIGN_IDENTITY=""							\
		CODE_SIGNING_REQUIRED=NO						\
		| xcpretty

packages:
	@ if [ -z "$(PLATFORM)" ]; then				\
		$(call package-platform,iOS);			\
		$(call package-platform,macOS);			\
	  else										\
	  	$(call package-platform,$(PLATFORM));	\
	  fi
	$ $(MAKE) clean

tag:
	@ if true; then	\
		version=$$(echo $(MESSAGE) | awk -F '[][]' '{print $$4}');	\
		message=$$(echo $(MESSAGE) | awk -F '[][]' '{print $$5}');	\
		$(call commit-tag,$$version,$$message) > /dev/null 2>&1;	\
	  fi

clean:
	@ if [ -d Build ]; then rm -fr Build; fi
	@ if [ -d iOS ]; then rm -fr iOS; fi
	@ if [ -d macOS ]; then rm -fr macOS; fi
