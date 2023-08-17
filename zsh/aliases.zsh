# Docker aliases
alias composer='docker run --rm -it -v "$PWD":/app -v ${COMPOSER_HOME:-$HOME/.composer}:/tmp composer '
alias composer1='docker run --rm -it -v "$PWD":/app -v ${COMPOSER_HOME:-$HOME/.composer}:/tmp composer:1 '
alias node='docker run --rm -it -v "$PWD":/app -w /app node:16-alpine '
alias node20='docker run --rm -it -v "$PWD":/app -w /app node:20-alpine '
alias node16='docker run --rm -it -v "$PWD":/app -w /app node:16-alpine '
alias node14='docker run --rm -it -v "$PWD":/app -w /app node:14-alpine '
alias npm='docker run --rm -it -v "$PWD":/app -w /app node:16-alpine npm '
alias deno='docker run --rm -it -v "$PWD":/app -w /app denoland/deno '
alias aws='docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli '
alias ffmpeg='docker run --rm -it -v "$PWD":/app -w /app jrottenberg/ffmpeg '
alias yo='docker run --rm -it -v "$PWD":/app nystudio107/node-yeoman:16-alpine '
alias tree='f(){ docker run --rm -it -v "$PWD":/app johnfmorton/tree-cli tree "$@";  unset -f f; }; f'

# Watson aliases
alias wt='watson'
alias wtd='watsond'

# Watson command to dynamically use current directory as project
alias watsond='f() { watson "$1" --confirm-new-project "$(basename $(pwd))" "${@:2}"; unset -f f; }; f'
