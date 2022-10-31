from waflib import Context
import os, yaml


"""
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
"""
from yaml import Loader, Dumper

def dependencies(ctx, cat, path):
    deps = {}
    for ty in ctx.env.dep_types:
        deps[ty] = []

    dependencies = ctx.generator.bld.cmd_and_log(
        ctx.generator.bld.env.PANDOC +
        ['-L',
         os.sep.join(ctx.env.data_dir +
                     ['filters', 'pfs', 'dependencies.lua']),
         '--to', 'plain',
         path],
        env={ 'CATEGORIES' : cat },
        output=Context.STDOUT, quiet=Context.STDOUT).strip().split('\n')

    if dependencies == ['']:
            dependencies = []

    for d in dependencies:
        # print('Dep:', d)
        [ty, dep] = d.split(' ')
        deps[ty].append(dep)
    return deps

def load_yaml(node):
    raw = node.read(encoding='utf-8')
    return yaml.load(raw, Loader)
