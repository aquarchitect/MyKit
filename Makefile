NAME = MyKit
BUILD = build
DOCS = docs

jazzy: $(NAME)/ $(NAME)iOS/ $(NAME)OSX/
	@if [[ ! -z $$(git status -s) ]]; then \
		echo "Generating docs requires a clean directory."; \
		exit 1; \
	fi; \

	@jazzy -c \
	   	--author HaiNguyen \
	   	--author_url https://aquarchitect.github.io \
	   	--github_url https://github.com/aquarchitect/MyKit \
	   	--exclude $(NAME)Test/*.swift \
	   	--output $(DOCS)/ \
	   	--skip-undocumented \
	   	--readme README.md

	@rm -r $(BUILD)/
	
	@$(MAKE) stash
	
	@[ -z '$(git status -s '] || \
		git add . \
		git commit -m "Generate on $$(date "+%m-%d-%Y")" \
		git push -u ogrigin gh-pages \
	@git checkout master

stash: $(DOCS)
	@git add $(DOCS)/
	@git stash
	@git check-out gh-pages
	@git stash pop

clean: $(BUILD) $(DOCS)
	rm -r $(BUILD)/ $(DOCS)/

