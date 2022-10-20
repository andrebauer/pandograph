from waflib import Context
import os

def dependencies(ctx, cat, path):
    deps = {}
    for ty in ctx.env.dep_types:
        deps[ty] = []

    dependencies = ctx.generator.bld.cmd_and_log(
        ['pandoc',
         '-L',
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
