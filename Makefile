OUT_DIR=output
IN_DIR=markdown
IN_DIR_BUILD=markdown/Builds
STYLES_DIR=styles
STYLE=chmduquesne
CV_NAME=Shashank_P_Rao_CV

all: html pdf docx rtf

pdf: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=$(CV_NAME); \
		echo $$FILE_NAME.pdf; \
		pandoc --standalone --template $(STYLES_DIR)/$(STYLE).tex \
			--from markdown --to context \
			--variable papersize=A4 \
			--output $(OUT_DIR)/$$FILE_NAME.tex $$f > /dev/null; \
		context $(OUT_DIR)/$$FILE_NAME.tex \
			--result=$(OUT_DIR)/$$FILE_NAME.pdf > $(OUT_DIR)/context_$$FILE_NAME.log 2>&1; \
	done

pdfAll: init
	for f in $(ls $IN_DIR_BUILD/*.md); do \
		FILE_NAME=$(CV_NAME); \
		echo $$FILE_NAME.pdf; \
		pandoc --standalone --template $(STYLES_DIR)/$(STYLE).tex \
			--from markdown --to context \
			--variable papersize=A4 \
			--output $(OUT_DIR)/$$FILE_NAME.tex $$f > /dev/null; \
		context $(OUT_DIR)/$$FILE_NAME.tex \
			--result=$(OUT_DIR)/$$FILE_NAME.pdf > $(OUT_DIR)/context_$$FILE_NAME.log 2>&1; \
	done

html: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=$(CV_NAME); \
		echo $$FILE_NAME.html; \
		pandoc --standalone --include-in-header $(STYLES_DIR)/$(STYLE).css \
			--from markdown --to html \
			--output $(OUT_DIR)/$$FILE_NAME.html $$f; \
	done

docx: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=$(CV_NAME); \
		echo $$FILE_NAME.docx; \
		pandoc --standalone $$SMART $$f --output $(OUT_DIR)/$$FILE_NAME.docx; \
	done

rtf: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=$(CV_NAME); \
		echo $$FILE_NAME.rtf; \
		pandoc --standalone $$SMART $$f --output $(OUT_DIR)/$$FILE_NAME.rtf; \
	done

init: dir version

dir:
	mkdir -p $(OUT_DIR)

version:
	PANDOC_VERSION=`pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`; \
	if [ "$$PANDOC_VERSION" -eq "2" ]; then \
		SMART=-smart; \
	else \
		SMART=--smart; \
	fi \

clean:
	rm -f $(OUT_DIR)/*
