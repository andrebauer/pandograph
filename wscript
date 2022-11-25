top = '.'
out = '_build'
tooldir = '_waf'

def configure(ctx):
    ctx.env.out = out
    ctx.env.content_extensions = 'md'
    ctx.env.suffix = '-pt'
    ctx.env.add_resource_path = 'content'
    ctx.load('pandoc', tooldir=tooldir)
    ctx.load('knitr', tooldir=tooldir)

def options(opt):
    opt.load('pandoc', tooldir=tooldir)

def build(bld):
    bld.load('knitr', tooldir=tooldir)
    bld.load('pandoc', tooldir=tooldir)
