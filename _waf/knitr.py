from waflib import TaskGen, Utils, Logs, Context
from waflib.TaskGen import feature, after_method
import os, utils

def configure(ctx):
    ctx.find_program('Rscript', var='RSCRIPT')

    ctx.env.KNITR = os.sep.join(
            ctx.env.knitr_path or
            ([ctx.path.abspath()] +
             ctx.env.data_dir +
             ['preprocessors', 'knit.R']))
    ctx.env.knitr_dir = '_knitr'


@feature('knitr')
def init_knitr(self):
    Utils.def_attrs(self, ext_in = '.md')

@feature('knitr')
@after_method('init_knitr')
def knitr(self):
    srcpath = self.source.srcpath()

    def scan(ctx):
        # print('SCAN', srcpath)

        # deps = self.env.deps[srcpath]
        deps = utils.dependencies(ctx, 'knitr', srcpath)
        # print(deps)

        nodes = []

        for ty in ctx.env.dep_types:
            # print('Ty:', ty )
            for dep in deps[ty]:
                # print('dep', dep)
                found = None
                for respath in self.resource_path + ['']:
                    # add another loop for the tex include paths?
                    # print('knitr: trying %s%s', self.path, respath, dep)
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
        # print('Knitr Depnodes:', nodes)
        return (nodes, []) # deps['markup'])

    self.scan = scan

    node = self.to_nodes(self.source)[0]
    self.target = self.bld.bldnode.find_or_declare(
        os.sep.join([self.env.knitr_dir, node.srcpath()]))
    if self.verbose > 1:
        self.rule='"${RSCRIPT}" "${KNITR}" "${SRC}" "${TGT}"'
    else:
        self.rule='"${RSCRIPT}" "${KNITR}" "${SRC}" "${TGT}" quiet'


def build(bld):
    for path in (bld.options.paths or bld.env.content):
        for node in bld.path.ant_glob(
                [path + '/**/*.' + ext
                 for ext in bld.env.content_extensions],
                quiet=True,
                excl= bld.env.exclude):
            bld(features = 'knitr',
                source = node,
                verbose = bld.options.verbose, # bld.env.options.get('verbose'),
                resource_path = bld.env.resource_path + [node.parent.srcpath()]
                )
