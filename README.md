# Pandoc-Projekt-Vorlage

Dies ist eine Vorlage zum Erstellen von 

- Vortragsfolien und Speakernotes,
- Übungsaufgaben mit optionalen Lösungshinweisen,
- Klausuren mit optionalen Lösungshinweisen und
- Textdokumenten

in [Pandoc's Markdown](https://pandoc.org/MANUAL.html#pandocs-markdown), 
die mit [Pandoc](https://pandoc.org/) in PDF-Dokumente umgewandelt werden.

## Benötigte Software

- [Pandoc und pandoc-citeproc](https://pandoc.org/installing.html)
- [GNU Make](https://www.gnu.org/software/make/)
- [LaTeX](https://www.latex-project.org/get/) einschließlich [PGF/TikZ](https://github.com/pgf-tikz/pgf)
- [Haskell](https://www.haskell.org/downloads/) zum Ausführen der Filter

## Erste Schritte

Um Weiterentwicklungen per Merging oder Cherry-Picking übernehmen zu können,
ist es empfehlenswert, das Repository zu clonen.

Der Ordner `content` enthält vier Beispiel-Dokumente und die zugehörigen Bilder.
Mit `make build` werden die entsprechenden PDF-Dokumente im Ordner `_build`
generiert. Der Befehl `make build_handout` generiert Handouts zu den 
Dokumenten in `content/lecture`. 
Die Ziele `build_slides_tex`, `build_notes_tex`, `build_exam_tex` und 
`build_exercise_tex` generieren LaTeX-Dokumente statt PDFs. 

## Build-Automation

Mit dem Shell-Skript `watch.sh` wird automatisch `make build` bei Änderungen 
im Ordner `content` ausgeführt.
