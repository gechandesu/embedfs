DOC_DIR = doc

all: test

test:
	v test $(TESTS_DIR)

doc:
	v doc -f html -m . -o $(DOC_DIR)

serve: clean doc
	v -e "import net.http.file; file.serve(folder: '$(DOC_DIR)')"

clean:
	rm -r $(DOC_DIR) >/dev/null 2>&1 || true
	rm mkembedfs >/dev/null 2>&1 || true

build:
	v cmd/mkembedfs -o mkembedfs
