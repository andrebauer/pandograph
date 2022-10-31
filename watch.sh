DIRECTORY_TO_OBSERVE="content"      # might want to change this
EXCLUDE="(.*~)|(.*\.#)"
function block_for_change {
  inotifywait -r \
	      -e modify,move,create,delete \
	      --exclude $EXCLUDE \
	      $DIRECTORY_TO_OBSERVE
}

function build {
    # build.sh
    # make --jobs=4 build
    waf build_svelte
}

build
while block_for_change; do
  build
done
