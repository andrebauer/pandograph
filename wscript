top = '.'
out = '_build'
tooldir = '_waf'

def configure(ctx):
    ctx.env.out = out
    ctx.env.suffix='-pandoc-template'
    ctx.env.ignore=['web/**/*']
    ctx.load('pandoc', tooldir=tooldir)
    ctx.load('knitr', tooldir=tooldir)
    ctx.env.formats['html'] = 'svelte'

def options(opt):
    opt.load('pandoc', tooldir=tooldir)

def build(bld):
    bld.load('knitr', tooldir=tooldir)
    bld.load('pandoc', tooldir=tooldir)
