# Makefile for documents written pandoc's markdown 
# generate all pdfs with: make --jobs=3 build

# general settings

shortname = pandoc-template
default_latex_template = templates/default/default.latex
latex_slides_template = templates/slides/default.latex
literature = literature/literature.bib
csl_style = csl/autor-jahr-3.csl
inline_csl_style = csl/inline-bibliography.csl

docsdir = content
builddir = _build

lsg = lsg

revision = $(shell git rev-parse --short=8 HEAD)
date = $(shell date "+%e. %B %Y")

default: build

# debug output
# example usage (1): make info DEBUG=all | less
# example usage (2): make info DEBUG="dirs kinds build" | less

all_debug_infos = dirs sources before-body kinds targets rules phony build all

define debug
  $(eval print = $(findstring $(1),$(if $(findstring all,$(DEBUG)),$(all_debug_infos),$(DEBUG))))
  $(if $(print),$(info $(2)))
  $(if $(print),$(info ))
endef


# directories
$(eval $(call debug,dirs,============ directories ============))

lsg_dirs = exercise exam
$(eval $(call debug,dirs,  lsg: [$(lsg_dirs)]))

lecture_dirs = lecture
$(eval $(call debug,dirs,  lecture: [$(lecture_dirs)]))

doc_dirs = docs
$(eval $(call debug,dirs,  doc: [$(doc_dirs)]))

image_dirs = images
$(eval $(call debug,dirs,  image: [$(image_dirs)]))

assets_dirs = assets
$(eval $(call debug,dirs,  assets: [$(assets_dirs)]))

header_partials_dirs = headers/partials
$(eval $(call debug,dirs,  header_partials: [$(header_partials_dirs)]))

content_dirs = $(doc_dirs) $(lsg_dirs) $(lecture_dirs)
$(eval $(call debug,dirs,  content: [$(content_dirs)]))

filter_dir = Text/Pandoc/Filter
$(eval $(call debug,dirs,  filter: [$(filter_dir)]))

# before-body
$(eval $(call debug,before-body,============ before-body ============))

exam_before-body = include/exam-before-body.md
$(eval $(call debug,before-body,    exam: [$(exam_before-body)]))

# sources
$(eval $(call debug,sources,============ sources ============))

define create-md-sources
  $(1)_sources = $(shell find $(docsdir)/$(1)/ -type f -name '*.md')
endef

$(foreach dir,$(content_dirs),\
  $(eval $(call create-md-sources,$(dir))))
$(foreach dir,$(content_dirs),\
  $(eval $(call debug,sources,    $(dir): [$($(dir)_sources)])))

image_sources = $(foreach dir,$(image_dirs),\
  $(shell find $(docsdir)/$(dir) \
    -type f -name '*.png' -or -name '*.jpg' -or -name '*.pdf'))
$(eval $(call debug,sources,    image: [$(image_sources)]))

assets_sources = $(foreach dir,$(assets_dirs),\
  $(shell find $(dir) \
    -type f -name '*.png' -or -name '*.jpg' -or -name '*.pdf'))
$(eval $(call debug,sources,    assets: [$(assets_sources)]))

header_partials_sources = $(foreach dir,$(header_partials_dirs),\
  $(shell find $(dir) -type f -name '*.tex'))
$(eval $(call debug,sources,    header_partials: [$(header_partials_sources)]))

# kinds
$(eval $(call debug,kinds,============ kinds ============))

output_kinds = pdf tex docx odt
$(eval $(call debug,kinds,    output: [$(output_kinds)]))

slide_kinds = slides handout
$(eval $(call debug,kinds,    slides: [$(slide_kinds)]))

lecture_kinds = $(slide_kinds) notes
$(eval $(call debug,kinds,    lecture: [$(lecture_kinds)]))


# targets
$(eval $(call debug,targets,============ targets ============))

define create-rule
build_$(1)_$(2)$(if $(3),_$(3),): $$($(1)_$(2)$(if $(3),_$(3),)_targets)
endef

image_targets = $(patsubst $(docsdir)/%, $(builddir)/%, $(image_sources))
images: $(image_targets)
$(eval $(call debug,targets,images: [$(image_targets)]))

assets_targets = $(patsubst %, $(builddir)/%, $(assets_sources))
assets: $(assets_targets)
$(eval $(call debug,targets,assets: [$(assets_targets)]))

header_partials_targets = $(patsubst %, $(builddir)/%, $(header_partials_sources))
header_partials: $(assets_targets)
$(eval $(call debug,targets,header_partials: [$(header_partials_targets)]))


phony = build clean info images assets
build_goals =

define create-targets
  $(eval build = build_$(1)_$(2)$(if $(3),_$(3),))
  $(eval targets = $(patsubst $(docsdir)/$(1)/%.md, $(builddir)/$(1)/%-$(shortname)$(if $(3),-$(3),).$(2), $($(1)_sources)))
  $(eval dependencies = $(targets) $(if $(findstring $(2),tex),$(image_targets) $(assets_targets) $(header_partials_targets)))
$(build): $(dependencies)
  $(eval $(call debug,targets,$(build): $(dependencies)))
phony += $(build)
build_goals += $(if $(findstring $(2),pdf), \
		 $(if $(findstring $(3),handout),,$(build)))
endef

$(foreach okind,$(output_kinds), \
  $(foreach dir,$(doc_dirs) $(lsg_dirs), \
    $(eval $(call create-targets,$(dir),$(okind)))) \
  $(foreach dir,$(lsg_dirs), \
    $(eval $(call create-targets,$(dir),$(okind),$(lsg)))) \
  $(if $(findstring $(okind),docx odt),, \
    $(foreach lkind,$(lecture_kinds), \
      $(foreach dir,$(lecture_dirs), \
        $(eval $(call create-targets,$(dir),$(okind),$(lkind)))))))


# phony
$(eval $(call debug,phony,============ phony ============))

.PHONY: $(phony)
$(eval $(call debug,phony,.PHONY: $(phony)))


# goals
$(eval $(call debug,build,============ build ============))

build: $(build_goals)
$(eval $(call debug,build,build: $(build_goals)))


# rules
$(eval $(call debug,rules,============ rules ============))

define eval-and-print
  $$(eval $$(call $1,$2,$3,$4,$5,$6,$7))
  $$(eval $$(call debug,rules,$$(call $1,$2,$3,$4,$5,$6,$7)))
endef

define copy-rule
$(builddir)/$(1)/%: $(if $(2),$(2)/)$(1)/%
	@mkdir -p "$$(@D)"
	cp -a "$$<" "$$@"
endef

$(foreach dir,$(image_dirs),\
  $(eval $(call eval-and-print,\
    copy-rule,$(dir),$(docsdir))))

$(foreach dir,$(assets_dirs) $(header_partials_dirs),\
  $(eval $(call eval-and-print,\
    copy-rule,$(dir))))

define slides-filters
  --filter $(filter_dir)/slides.hs
endef

define notes-filters
  --filter $(filter_dir)/notes.hs
endef

define exercise-filters
  --filter $(filter_dir)/exercise.hs
endef

define lsg-filters
  --filter $(filter_dir)/lsg.hs
endef

# +yaml_metadata_block+smart+latex_macros

define pandoc-rule
$2.$1: $($(4)_before-body) $3
	@mkdir -p "$$(@D)"
	pandoc \
    $(if $(findstring $(1),docx odt),, \
	    --include-in-header=headers/common.tex \
	    --include-in-header=headers/$(4).tex) \
	  -V revision="$(revision)" \
	  --strip-comments \
	  -L diagram-generator.lua \
	  -L include-files.lua \
	  -L list-table.lua \
	  -L pagebreak.lua \
	  $(5) \
	  --citeproc \
	  --resource-path=.:$(docsdir) \
	  $(foreach lit,$(literature), \
	    --bibliography $(lit)) \
	  $(if $(findstring $4,$(slide_kinds)),\
	    --template=$(latex_slides_template) --slide-level=3, \
      $(if $(findstring $(1),docx odt),, \
	      --template=$(default_latex_template))) \
	  $(if $(findstring $4,$(lsg_dirs)), \
	    --csl $(inline_csl_style), \
	    --csl $(csl_style)) \
    $(if $(findstring $(1),docx odt),, \
	    --pdf-engine=xelatex) \
	  --from=markdown \
	  $(if $(findstring $4,$(slide_kinds)),-t beamer,) \
	  $(if $(findstring $1,tex),--standalone,) \
	  metadata/common.yaml \
	  $(if $(6),metadata/$(6).yaml,) \
	  metadata/$(4).yaml \
	  $$^ \
	  -o "$$@"
endef

$(foreach okind,$(output_kinds), \
  $(foreach dir,$(doc_dirs), \
    $(eval $(call eval-and-print,\
      pandoc-rule,$(okind),\
      $(builddir)/$(dir)/%-$(shortname),\
      $(docsdir)/$(dir)/%.md,$(dir),\
      $(exercise-filters)))) \
  \
  $(foreach dir,$(lsg_dirs), \
    $(eval $(call eval-and-print,\
      pandoc-rule,$(okind),\
      $(builddir)/$(dir)/%-$(shortname),\
      $(docsdir)/$(dir)/%.md,$(dir),\
      $(exercise-filters),docs)) \
    \
    $(eval $(call eval-and-print,\
      pandoc-rule,$(okind),\
      $(builddir)/$(dir)/%-$(shortname)-$(lsg),\
      $(docsdir)/$(dir)/%.md,$(dir),\
      $(lsg-filters),docs))) \
  \
  $(foreach dir,$(lecture_dirs), \
    $(foreach lkind,$(lecture_kinds), \
      $(eval $(call eval-and-print,\
        pandoc-rule,$(okind),\
	$(builddir)/$(dir)/%-$(shortname)-$(lkind)$(if $(findstring $(lkind),handout),-slides,),\
        $(docsdir)/$(dir)/%.md,$(lkind),\
        $(if $(findstring $(lkind),slides handout),$(slides-filters),$(notes-filters)),$(if $(findstring $(lkind),notes),docs,))))) \
)

$(builddir)/%-handout.pdf: $(builddir)/%-handout-slides.pdf
	pdfjam --a4paper --keepinfo --nup 1x2 --frame true \
	  --scale 0.92 --no-landscape --delta '0 20mm' \
	  --outfile "$@" \
	  "$<"


# clean
clean:
	rm -rf $(builddir)


# tests
test:
	shelltest $(filter_dir)/test/tests
