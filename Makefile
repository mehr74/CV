-include Makefile.local

OUTPUT_PREFIX   := CV_Mehrshad.Lotfi_
CV_SHORT_EN     := short-en
CV_SHORT_DE     := short-de

CV_SHORT_EN_TEX := $(CV_SHORT_EN).tex
CV_SHORT_DE_TEX := $(CV_SHORT_DE).tex
CV_SHORT_EN_PDF := $(OUTPUT_PREFIX)$(CV_SHORT_EN).pdf
CV_SHORT_DE_PDF := $(OUTPUT_PREFIX)$(CV_SHORT_DE).pdf

TEX := $(shell find ./ -type f -name "*.tex")
CLS := $(shell find ./ -type f -name "*.cls")
BIB := $(shell find ./ -type f -name "*.bib")

all:                 \
	$(CV_SHORT_EN_PDF) \
	$(CV_SHORT_DE_PDF)


include .devcontainer/rules.mk

GNUPLOTS   := $(addsuffix .pdf,$(basename $(shell find ./figures -type f -name "*.gnuplot" | grep -v common)))
PAPER_DEPS := $(TEX) $(CLS) $(BIB) $(FIG) $(GNUPLOTS)

LATEX := python3 ./bin/latexrun --color auto --bibtex-args="-min-crossrefs=9000"

%.eps: %.dia
	dia -e $@ -t eps $<

%.pdf: %.eps
	epspdf $< $@.tmp.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 \
	  -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH \
	  -sOutputFile=$@ $@.tmp.pdf
	rm -f $@.tmp.pdf

%.pdf: %.gnuplot %.dat figures/common.gnuplot
	(cd $(dir $@) ; gnuplot $(notdir $<)) | pdfcrop - $@

$(CV_SHORT_EN_PDF): $(PAPER_DEPS)
	$(LATEX) $(CV_SHORT_EN_TEX) -O .latex.out -o $@

$(CV_SHORT_DE_PDF): $(PAPER_DEPS)
	$(LATEX) $(CV_SHORT_DE_TEX) -O .latex.out -o $@


HELP_MSG          += \tall                      Build\
       CV pdf using latex.\n

check-hadolint:
	@hadolint .devcontainer/texlive.Dockerfile

help:
	@printf "Usage: make [target]\n"
	@printf "\n"
	@printf "Available targets:\n"
	@printf "\n"
	@printf "\thelp                     Show this help message\n";
	@printf "$(HELP_MSG)"
	@printf "\n";
	@printf "\n";

clean:
	$(LATEX) --clean-all -O .latex.out
	@rm -frv .latex.out $(PDFS) $(GNUPLOTS) arxiv arxiv.tar.gz
	@rm -rfv $(CV_SHORT)
