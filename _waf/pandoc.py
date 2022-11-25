from waflib import TaskGen, Utils, Context, Logs
from waflib.TaskGen import feature, after_method
from waflib.Configure import conf
import os, pprint, frontmatter, utils

def to_list(l):
    if l is None: return l
    if not (type(l) is list):
        return [l]
    return l

@conf
def get_meta(ctx):
    meta = {}
    deps = {}

    ctx.start_msg('Reading metadata')
    for node in ctx.path.ant_glob(ctx.env.content,
                quiet=True,
                excl=ctx.env.exclude):
        path = node.srcpath()
        meta[path] = {}
        deps[path] = {}

        src = node.read(encoding='utf-8')
        post = frontmatter.loads(src)

        kinds = post.get('kinds') or ctx.env.default_kinds

        outpaths = to_list(post.get('output')) or None

        """
        for ty in ctx.env.dep_types:
            deps[path][ty] = []

        dependencies = ctx.cmd_and_log(
            ['pandoc',
             '-L',
             os.sep.join(ctx.env.data_dir +
                         ['filters', 'pfs', 'dependencies.lua']),
             '--to', 'plain',
             path],
            env={ 'YAML_KEY' : 'dependencies'},
            output=Context.STDOUT, quiet=Context.STDOUT).strip().split('\n')
                # kinds = proc.stdout.read()
        if dependencies == ['']:
            dependencies = []
        for d in dependencies:
            # print('Dep:', d)
            [ty, dep] = d.split(' ')
            deps[path][ty].append(dep)
        """

        if type(kinds) is str:
            meta[path][kinds] = {
                'outpaths' : outpaths,
            }

        elif type(kinds) is dict:
            for kind, outpaths in kinds.items():
                meta[path][kind] = {
                    'outpaths' : to_list(outpaths)
                }

        elif type(kinds) is list:
            for kind in kinds:
                if type(kind) is str:
                    meta[path][kind] = {
                        'outpaths' : outpaths,
                    }

                elif type(kind) is dict:
                    for kind, outpaths in kind.items():
                        meta[path][kind] = {
                            'outpaths' : to_list(outpaths)
                        }

        kinds = list(meta[path].keys())
        for kind in kinds:
            segments = Utils.split_path(node.parent.srcpath())
            meta[path][kind]['defaults'] = ctx.env.data_dir + ['defaults', kind + '.yaml']
            while(len(segments) > 0):
                default_path = segments + [kind + '.yaml']
                if ctx.path.find_node(default_path):
                    meta[path][kind]['defaults'] = default_path
                    break
                segments.pop(-1)

    ctx.env.meta = meta
    # ctx.env.deps = deps

    ctx.end_msg(pprint.pformat({ 'meta' : ctx.env.meta, 'deps' : ctx.env.deps }))

def configure(ctx):
    if not ctx.env.content:
        ctx.env.content = '**/*.md'
    ctx.env.content = to_list(ctx.env.content)
    ctx.env.dep_types = ['sourcecode', 'markup', 'image']
    ctx.env.ignore = to_list(ctx.env.ignore or [])
    if not ctx.env.assets_exclude:
        ctx.env.assets_exclude = ctx.env.ignore + [
            ctx.env.out + '/**/*',
            '_pandoc/filters/pfs/_build/**/*',
            '__pycache__/**/*',
            '_waf/**/*']
    if not ctx.env.exclude:
        ctx.env.exclude = ctx.env.ignore + [
            ctx.env.out + '/**/*',
            '_pandoc/**/*',
            '__pycache__/**/*',
            '_waf/**/*']
    ctx.env.add_resource_path = to_list(ctx.env.add_resource_path or [])
    ctx.env.resource_path = ['.'] + ctx.env.add_resource_path
    if not ctx.env.default_kinds:
        ctx.env.default_kinds = ['svelte', 'doc_pdf', 'doc_docx', 'solution_pdf']
    if not ctx.env.data_dir:
        ctx.env.data_dir = ['_pandoc']
    if not ctx.env.suffix:
        ctx.env.suffix = ''
    ctx.find_program('pandoc', var='PANDOC')
    ctx.find_program('git', var='GIT')
    ctx.get_meta()

def options(opt):
    opt.add_option("--path",
                   dest='paths',
                   action='append',
                   help='restrict build to path')


def read_yaml(node):
    rawyaml = node.read(encoding='utf8')
    yaml = frontmatter.loads("---\n" + rawyaml + "\n---\n")
    return yaml


def copy_pandoc_assets(bld):
    base_dir = os.sep.join(bld.env.data_dir)

    for node in bld.path.ant_glob(['**/*.png', '**/*.jpg', '**/*.jpeg', '**/*.pdf', '**/*.svg'],
                                  quiet=True,
                                  excl=bld.env.exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    bld.env.yaml = {}
    for node in bld.path.ant_glob('**/*.yaml',
                                  quiet=True,
                                  excl=bld.env.assets_exclude):
        bld.env.yaml[node.srcpath()] = read_yaml(node)
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob(
            [base_dir + '/**/*.csl',
             base_dir + '/writers/**/*.lua',
             base_dir + '/templates/**/*',
             base_dir + '/**/*.bib',
             base_dir + '/filters/**/*.lua',
             base_dir + '/**/*.tex'],
            excl=bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob('assets/**/*',
                                  excl= bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob('content/**/*.sh',
                                  excl= bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

@feature('pandoc')
def init_pandoc(self):
    Utils.def_attrs(self,
                    options      = [],
                    defaults     = [],
                    variables    = {},
                    bibliography = [],
                    template     = None,
                    to           = None,
                    from_        = None,
                    pdf_engine   = 'xelatex',
                    ext          = None,
                    standalone   = False,
                    resource_path = False)


@feature('pandoc')
@after_method('init_pandoc')
def pandoc(self):


    srcpath = self.target.srcpath()
    node = self.node


    # print('Node' , node)

    """
    def scan(ctx):
        deps = self.env.deps[srcpath]

        # depnodes = list(map(node.find_or_declare, deps))
        #print('Depnodes:', depnodes)
        return (depnodes, [])

    self.scan = scan
    """

    def scan(ctx):
        # print('SCAN', srcpath)

        # deps = self.env.deps[node.srcpath()]
        deps = utils.dependencies(ctx, 'pandoc', node.srcpath())

        nodes = []

        for d in to_list(self.defaults):
            nodes.append(self.path.find_resource(d))

        for ty in ctx.env.dep_types:
            # print('Ty:', ty )
            for dep in deps[ty]:
                # print('dep', dep)
                found = None
                for respath in self.resource_path:
                    # add another loop for the tex include paths?
                    Logs.debug('knitr: trying %s%s', respath, dep)
                    fi = self.path.find_resource([respath, dep])
                    if fi:
                        Logs.debug('knitr: found %s%s', respath, dep)
                        found = True
                        nodes.append(fi)
                        # no break
                if not found:
                    Logs.debug('knitr: could not find %s', dep)

        # print('Dep', ty, dep)
        # depnodes.append(self.path.parent.find_resource('content/' + dep))
        # print('Depnodes:', nodes)
        return (nodes, [])

    self.scan = scan

    self.env.options = self.options

    def add_options(opts):
        self.env.append_value('options', opts)

    if self.to: add_options(['--to=%s' % self.to])

    if self.from_: add_options(['--from=%s' % self.from_])

    if self.standalone: add_options(['-s'])

    if not self.ext: self.ext = self.to

    if not(self.target):
        self.target = self.node.change_ext(self.ext)

    self.target = self.target.change_ext(self.ext)

    add_options(['--defaults=%s' % d for d in to_list(self.defaults)])

    add_options(['-V %s=%s' % (k, v) for k, v in self.variables.items()])

    if self.bibliography: add_options(['--citeproc'])

    add_options(['--bibliography=%s' % x for x in self.bibliography])

    add_options(['--data-dir=' + os.sep.join(self.env.data_dir)])

    if self.resource_path:
        add_options(['--resource-path=%s' % ':'.join(self.resource_path)])

    self.rule= '"${PANDOC}" ${defaults} ${options} ${SRC} -o ${TGT}'

    """
    def scan(task):
        print('SCAN')
        return ([], [])

    self.scan = scan
    """

def build(bld):
    revision = bld.cmd_and_log(
        bld.env.GIT + ['rev-parse', '--short=8', 'HEAD'],
        output=Context.STDOUT, quiet=Context.STDOUT).strip()

    copy_pandoc_assets(bld)

    for path in (bld.options.paths or bld.env.content):
        for node in bld.path.ant_glob(path,
                quiet=True,
                excl= bld.env.exclude):
            srcpath = node.srcpath()


            if bld.env.knitr_dir:
                source = bld.bldnode.find_or_declare(os.sep.join([bld.env.knitr_dir, srcpath]))
            else:
                source = node


            kinds = list(bld.env.meta[srcpath].keys())

            for kind in kinds:
                default = os.sep.join(bld.env.meta[srcpath][kind]['defaults'])
                suffix = getattr(bld, 'suffix', bld.env.suffix)
                variables = bld.env.yaml[default].get('variables')
                if variables:
                    suffix = variables.get('suffix') or suffix

                # print("final SUFFIX ", srcpath, kind, " : " , suffix)

                outpaths = bld.env.meta[srcpath][kind]['outpaths']

                if outpaths:
                    targets = [bld.path.find_or_declare(o) for o in outpaths]
                else:
                    root, _ = os.path.splitext(srcpath)
                    targets = [bld.path.find_or_declare(root + suffix)]

                for target in targets:
                    if bld.cmd == 'build_' + kind or bld.cmd == 'build':
                        bld(features='pandoc',
                            node = node,
                            source = source,
                            target = target,
                            ext = bld.ext or kind,
                            defaults = default,
                            variables = { 'revision': revision },
                            resource_path = bld.env.resource_path + [node.parent.srcpath()],
                        )


from waflib.Build import BuildContext

class tmp(BuildContext):
    cmd = 'build_beamer'
    ext = '.pdf'

class tmp(BuildContext):
    cmd = 'build_handout'
    ext = '.pdf'

class tmp(BuildContext):
    cmd = 'build_notes'
    ext = '.pdf'

class tmp(BuildContext):
    cmd = 'build_doc_pdf'
    ext = '.pdf'

class tmp(BuildContext):
    cmd = 'build_doc_docx'
    ext = '.docx'

class tmp(BuildContext):
    cmd = 'build_doc_odt'
    ext = '.odt'

class tmp(BuildContext):
    cmd = 'build_doc_tex'
    ext = '.tex'

class tmp(BuildContext):
    cmd = 'build_svelte'
    ext = '.svelte'

class tmp(BuildContext):
    cmd = 'build_solution_pdf'
    ext = '-lsg.pdf'

class tmp(BuildContext):
    cmd = 'build_pandoc_assets'

"""
pandoc
--include-in-header=headers/common.tex
--include-in-header=headers/exam.tex
-V revision="ff9cc1c1"
--strip-comments
-L diagram-generator.lua
-L include-files.lua
-L list-table.lua
-L pagebreak.lua
--filter Text/Pandoc/Filter/exercise.hs
--citeproc
--resource-path=.:content
--bibliography literature/literature.bib
--bibliography literature/literature-ssueb-aud.bib
--template=templates/default/default.latex
--csl csl/autor-jahr-3.csl
--pdf-engine=xelatex
--from=markdown
metadata/common.yaml metadata/docs.yaml metadata/exam.yaml
content/exam/2022-09-30-klausur.md
-o "_build/exam/2022-09-30-klausur-auds-ssü-ss-2022.pdf"
"""


"""
pandoc
 --include-in-header=headers/common.tex
--include-in-header=headers/handout.tex
-V revision="21c98717"
--strip-comments
-L diagram-generator.lua
-L include-files.lua
-L list-table.lua
-L pagebreak.lua
--filter Text/Pandoc/Filter/slides.hs
--citeproc
--resource-path=.:content
--bibliography literature/literature.bib
--template=templates/slides/default.latex
--slide-level=3
--csl csl/autor-jahr-3.csl
--pdf-engine=xelatex
--from=markdown
-t beamer
metadata/common.yaml
metadata/handout.yaml
content/lecture/example-lecture-dagstuhl-dreieck.md
-o "_build/lecture/example-lecture-dagstuhl-dreieck-pandoc-template-handout-slides.pdf

pandoc  --include-in-header=headers/common.tex --include-in-header=headers/slides.tex -V revision="21c98717" --strip-comments -L diagram-generator.lua -L include-files.lua -L list-table.lua -L pagebreak.lua    --filter Text/Pandoc/Filter/slides.hs --citeproc --resource-path=.:content  --bibliography literature/literature.bib  --template=templates/slides/default.latex --slide-level=3  --csl csl/autor-jahr-3.csl  --pdf-engine=xelatex --from=markdown -t beamer  metadata/common.yaml  metadata/slides.yaml content/lecture/example-lecture-cs-unplugged.md -o "_build/lecture/example-lecture-cs-unplugged-pandoc-template-slides.pdf"
pandoc  --include-in-header=headers/common.tex --include-in-header=headers/notes.tex -V revision="21c98717" --strip-comments -L diagram-generator.lua -L include-files.lua -L list-table.lua -L pagebreak.lua    --filter Text/Pandoc/Filter/notes.hs --citeproc --resource-path=.:content  --bibliography literature/literature.bib   --template=templates/default/default.latex  --csl csl/autor-jahr-3.csl  --pdf-engine=xelatex --from=markdown   metadata/common.yaml metadata/docs.yaml metadata/notes.yaml content/lecture/example-lecture-cs-unplugged.md -o "_build/lecture/example-lecture-cs-unplugged-pandoc-template-notes.pdf"
"""

"""
TODO

- Autodetect kinds in _pandoc/defaults and generate BuildContexts

- waf build # fails
  → should run all special build commands

"""
