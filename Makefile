GITHUB_SECURE_URL = https://$(GITHUB_TOKEN)@github.com/aquarchitect/MyKit.git

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
	elif [ "$(1)" == "macOS" ]; then													\
		$(MAKE) xcodebuild TARGET=MyKit-macOS SDK=macosx10.11;							\
		cp -r build/Release macOS;														\
		zip -r MyKit-macOS.zip macOS;													\
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
	git init;										\
	git add .;										\
	git commit -m $(1);								\
	git remote add upstream $(GITHUB_SECURE_URL);	\
	git push -f upstream master:gh-pages
endef

define commit-tag
	git remote add upstream $(GITHUB_SECURE_URL);	\
	git tag -a $(1) -m "$(2)";						\
	git push upstream $(1)
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
	@ echo ">>> Packaging MyKit for macOS ... "
	@ $(call package-platform,macOS)

jazzy:
	@ echo ">>> Generating documentation ... "
	@ jazzy
	@ if true; then 												\
		doc=$$(find docs \( -name "*.html" -or -name "*.css" \));	\
		for file in $$doc; do 										\
			echo ">>> Minifying $$file ... ";						\
			$(call minify-web,$$file);								\
	    done;														\
	  fi
	@ if true; then														\
		echo ">>> Pushing generated documentation to gh-pages branch ...";	\
		msg="Publish from TravisCI on $$(date +%D)";					\
		cd docs && $(call commit-pages,$$msg) > /dev/null 2>&1;			\
	  fi

tag:
	@ if [ "$$(echo $(STRING) | awk -F '[][]' '{print $$2}')" == "tag" ]; then	\
		version=$$(echo $(STRING) | awk -F '[][]' '{print $$4}');				\
		message=$$(echo $(STRING) | awk -F '[][]' '{print $$5}');				\
		if [[ ! $$version =~ ^([0-9]+\.){2}[0-9]+ ]]; then						\
			echo "Error: Invalid version!" >&2 && exit 1;						\
		else																	\
			echo ">>> Pushing generated tag to main branch ... ";				\
			$(call commit-tag,$$version,$$message);								\
		fi;																		\
	  fi

todo:
	@ if [ "$(JOB)" == "doc" ]; then					\
		$(MAKE) jazzy;									\
	  elif [ "$(JOB)" == "tag" ]; then					\
	    $(MAKE) tag STRING="$$(git log --oneline -1)";	\
	  elif [ "$(JOB)" == "release" ]; then				\
		$(MAKE) tag STRING="$$(git log --oneline -1)";	\
	  	$(MAKE) jazzy;									\
	  fi

clean:
	@ if [ -d build ]; then rm -fr build; fi
	@ if [ -d iOS ]; then rm -fr iOS; fi
	@ if [ -d macOS ]; then rm -fr macOS; fi
