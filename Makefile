SRC_DIR ?= src
DOC_DIR ?= doc
TESTS_DIR ?= .

all: test

test:
	v test $(TESTS_DIR)

doc:
	v doc -f html -m ./$(SRC_DIR) -o $(DOC_DIR)

serve: clean doc
	v -e "import net.http.file; file.serve(folder: '$(DOC_DIR)')"

clean:
	rm -r $(DOC_DIR) || true

cli:
	v cmd/mkembedfs -o mkembedfs
