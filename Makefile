ALUMNOS := $(notdir $(wildcard src/reportes/alumnos/*))
PDFS := $(ALUMNOS:%=reportes/%.pdf)
# Se puede cambiar si biber del sistema no funciona: make BIBER=/ruta/a/biber
BIBER ?= biber
COMUN := $(wildcard src/reportes/comun/* src/reportes/compartido/*)

.PHONY: all clean $(ALUMNOS)

# make compila todos; make facundo-barbera compila solo ese reporte
all: $(PDFS)

$(ALUMNOS): %: reportes/%.pdf

reportes/%.pdf: src/reportes/alumnos/%/main.tex src/reportes/alumnos/%/investigacion.tex src/reportes/alumnos/%/references.bib $(COMUN)
	cd src/reportes/alumnos/$* && latexmk -pdf -e '$$biber=q($(BIBER) %O %S)' -interaction=nonstopmode -halt-on-error main.tex
	cp src/reportes/alumnos/$*/main.pdf $@

clean:
	for d in src/reportes/alumnos/*/; do (cd $$d && latexmk -C); done
