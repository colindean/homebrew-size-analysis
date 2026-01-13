FILES_DB = data

URL_FILES = $(shell fd .url data)
SIZE_FILES = $(URL_FILES:.url=.size)


formula.json:
	curl --output $@ https://formulae.brew.sh/api/formula.json


# TODO: can we pipe the output of jq to awk to build the mkdir/write commands
# list and pipe that to parallel?
urls: formula.json
	for triple_url in $$(jq -r -f extract.jq formula.json); do \
		file="data/$$(echo "$${triple_url}" | cut -d '=' -f 1)"; url="$$(echo "$${triple_url}" | cut -d '=' -f 2)"; \
		echo "$${url} is going into $${file}"; \
		mkdir -p $$(dirname "$${file}"); printf "%s" "$${url}" > "$${file}"; \
	done

CURL_OPTS = --disable --cookie /dev/null --globoff --show-error --user-agent "homebrew-pkg-size-analysis/0.0.1" --retry 3 --header "Authorization: Bearer QQ==" --fail --location --silent --head

# %.size: %.url
# 	curl $(CURL_OPTS) --write-out '%header{content-length}' "$(shell cat $<)" > $@

%.response: %.url
	curl $(CURL_OPTS) --output $@ "$(shell cat $<)"

%.size: %.response
	grep "content-length:" $< | cut -d ' ' -f 2 > $@

.PHONY: sizes
sizes: $(SIZE_FILES)


deps: Brewfile .pre-commit-config.yaml
	brew bundle --file=Brewfile --no-lock
	pre-commit install

.PHONY: all
all: sizes
.PHONY: clean
clean:
.PHONY: test
test:
