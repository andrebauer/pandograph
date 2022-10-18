from waflib import TaskGen, Utils, Context
from waflib.TaskGen import feature, after_method
from waflib.Configure import conf
import os, pprint, frontmatter

def to_list(l):
    if l is None: return l
    if not (type(l) is list):
        return [l]
    return l

@conf
def get_meta(ctx):
    ctx.env.meta = { 'kinds': {},
                     'output': {},
                     'dependencies': {},
                     'kind-defaults' : {},
                     'format-defaults' : {},
                     'suffix': {}
                    }
    ctx.start_msg('Reading metadata')
    for node in ctx.path.ant_glob(ctx.env.content,
                quiet=True,
                excl=ctx.env.exclude):
        path = node.srcpath()
        src = node.read(encoding='utf-8')
        post = frontmatter.loads(src)

        kinds = to_list(post.get('kinds') or ctx.env.default_kind)
        ctx.env.meta['kinds'][path] = kinds

        outpath = to_list(post.get('output')) or None
        ctx.env.meta['output'][path] = outpath

        """
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
        ctx.env.meta['dependencies'][path] = dependencies
        """

        ctx.env.meta['kind-defaults'][path] = {}
        for kind in kinds:
            segments = Utils.split_path(node.parent.srcpath())
            ctx.env.meta['kind-defaults'][path][kind] = ctx.env.data_dir + ['defaults', kind + '.yaml']
            while(len(segments) > 0):
                default_path = segments + [kind + '.yaml']
                if ctx.path.find_node(default_path):
                    ctx.env.meta['kind-defaults'][path][kind] = default_path
                    break
                segments.pop(-1)

        ctx.env.meta['format-defaults'][path] = {}
        ctx.env.meta['suffix'][path] = {}
        for format in ctx.env.formats:
            segments = Utils.split_path(node.parent.srcpath())
            ctx.env.meta['format-defaults'][path][format] = ctx.env.data_dir + ['defaults', format + '.yaml']
            while(len(segments) > 0):
                default_path = segments + [format + '.yaml']
                if ctx.path.find_node(default_path):
                    ctx.env.meta['format-defaults'][path][format] = default_path
                    break
                segments.pop(-1)

    ctx.end_msg(pprint.pformat(ctx.env.meta))

def configure(ctx):
    if not ctx.env.content:
        ctx.env.content = '**/*.md'
    ctx.env.content = to_list(ctx.env.content)
    ctx.env.ignore = ctx.env.ignore or []
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
    if not ctx.env.default_kind:
        ctx.env.default_kind = 'doc'
    if not ctx.env.formats:
        ctx.env.formats = {'html' : 'html', 'pdf': 'pdf', 'docx' : 'docx', 'odt' : 'odt', 'tex' : 'tex'}
    if not ctx.env.data_dir:
        ctx.env.data_dir = ['_pandoc']
    if not ctx.env.suffix:
        ctx.env.suffix = ''
    ctx.find_program('pandoc', var='PANDOC')
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

    for node in bld.path.ant_glob(base_dir + '/**/*.csl',
                                  excl=bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob(base_dir + '/writers/**/*.lua',
                                  excl=bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob(base_dir + '/templates/**/*',
                                  excl=bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob(base_dir + '/**/*.bib',
                                  excl=bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob(
            [base_dir + '/filters/*.lua',
             base_dir + '/filters/lua-filters/**/*.lua',
             base_dir + '/filters/lib/**/*.lua',
             base_dir + '/filters/pfs/**/*.lua'],
            excl=bld.env.assets_exclude):
        bld(features='subst',
            source=node.srcpath(),
            target=node.srcpath(),
            is_copy=True)

    for node in bld.path.ant_glob(base_dir + '/**/*.tex',
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



@feature('pandoc')
def init_pandoc(self):
    Utils.def_attrs(self,
                    options      = [],
                    defaults     = [],
                    variables    = {},
                    bibliography = [],
                    template     = None,
                    # csl          = 'csl/autor-jahr-3.csl',
                    # knitr = '',
                    to           = None, # 'pdf',
                    from_        = None, # 'markdown',
                    pdf_engine   = 'xelatex',
                    ext          = '',
                    standalone   = False)




@feature('pandoc')
@after_method('init_pandoc')
def pandoc(self):
    """
    srcpath = self.target.srcpath()
    node = self.target
    print('Node' , node)

    def scan(ctx):
        deps = self.env.meta['dependencies'][srcpath]

        depnodes = list(map(node.find_or_declare, deps))
        print('Depnodes:', depnodes)
        return (depnodes, [])
        # return ([], [])
    self.scan = scan
    """

    self.env.options = self.options

    def add_options(opts):
        self.env.append_value('options', opts)

    if self.to: add_options(['--to=%s' % self.to])

    if self.from_: add_options(['--from=%s' % self.from_])

    if self.standalone: add_options(['-s'])

    if not self.ext: self.ext = self.to

    if not(self.target):
        self.target = self.node.change_ext('.%s' % self.ext)

    self.target = self.target.change_ext('.%s' % self.ext)

    add_options(['--defaults=%s' % d for d in self.defaults])

    add_options(['-V %s=%s' % (k, v) for k, v in self.variables.items()])

    if self.bibliography: add_options(['--citeproc'])

    add_options(['--bibliography=%s' % x for x in self.bibliography])

    add_options(['--data-dir=' + os.sep.join(self.env.data_dir)])

    """
    ${resource_path} --data-dir=${data_dir}
    """

    self.rule= '${PANDOC} ${defaults} ${options} ${SRC} -o ${TGT}'



def build(bld):
    revision = bld.cmd_and_log(
        ['git', 'rev-parse', '--short=8', 'HEAD'],
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

            output = bld.env.meta['output'][srcpath]

            kinds = bld.env.meta['kinds'][srcpath] or [bld.env.default_kind]

            formats = bld.env.formats

            for kind in kinds:
                for format in formats:
                    defaults=[
                        os.sep.join(bld.env.meta['format-defaults'][srcpath][format]),
                        os.sep.join(bld.env.meta['kind-defaults'][srcpath][kind])
                    ]

                    suffix = bld.env.suffix
                    for default in defaults:
                        variables = bld.env.yaml[default].get('variables')
                        if variables:
                            suffix = variables.get('suffix') or suffix
                    # print("final SUFFIX", srcpath, kind, format, suffix)

                    if output:
                        targets = [bld.path.find_or_declare(o + suffix) for o in output]
                    else:
                        root, _ = os.path.splitext(srcpath)
                        targets = [bld.path.find_or_declare(root + suffix)]


                    for target in targets:
                        if bld.cmd == 'build_' + format or bld.cmd == 'build':
                            bld(features='pandoc',
                                source = source,
                                target = target,
                                ext = formats[format],
                                defaults = defaults,
                                variables = { 'revision': revision }
                                )


from waflib.Build import BuildContext

class tmp(BuildContext):
    cmd = 'build_pdf'

class tmp(BuildContext):
    cmd = 'build_docx'

class tmp(BuildContext):
    cmd = 'build_odt'

class tmp(BuildContext):
    cmd = 'build_tex'

class tmp(BuildContext):
    cmd = 'build_html'

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
