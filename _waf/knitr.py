from waflib import TaskGen, Utils
from waflib.TaskGen import feature, after_method
import os

def configure(ctx):
    ctx.find_program(
        os.sep.join(
            ctx.env.knitr_program or
            [ctx.path.abspath()] +
            ctx.env.data_dir +
            ['preprocessors',
             'knit.R'])
        , var='KNITR')
    ctx.env.knitr_dir = '_knitr'

@feature('knitr')
def init_knitr(self):
    Utils.def_attrs(self, ext_in = '.md')

@feature('knitr')
@after_method('init_knitr')
def knitr(self):
    node = self.to_nodes(self.source)[0]
    self.target = self.bld.bldnode.find_or_declare(
        os.sep.join([self.env.knitr_dir, node.srcpath()]))
    self.rule='${KNITR} ${SRC} ${TGT} quiet'


def build(bld):
    for path in bld.options.paths or bld.env.content:
        for node in bld.path.ant_glob(path,
                quiet=True,
                excl= bld.env.exclude):
            bld(features = 'knitr', source = node)
