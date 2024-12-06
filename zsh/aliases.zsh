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
alias dk='docker'
alias dc='docker-compose'
alias dkill='docker stop $(docker ps -q)'
alias dlast='docker exec -it $(docker ps -l -q)'

# Watson aliases
alias wt='watson'
alias wtd='watsond'
alias wtagt='watsonagt'
alias wtfzf='watsonfzf'

# Watson command to dynamically use current directory as project
alias watsond='f() { watson "$1" --confirm-new-project "$(basename $(pwd))" "${@:2}"; unset -f f; }; f'

# Watson aggregate command for the current day
alias watsonagt='watson aggregate --from $(date +%Y-%m-%d) --current'

# Fzf edit watson frames
alias watsonfzf="watson frames | tac | fzf --height 40% --prompt \"Select a Watson frame ID: \" | awk '{print \$1}' | xargs -I {} watson edit {}"

# Jumpstart work mode
alias start='apps=("Microsoft Teams" "Microsoft Outlook" "Kitty" "Firefox Developer Edition" "Obsidian"); for app in "${apps[@]}"; do open -a $app; done'

# Homebrew force update everything
alias brewupdate='brew upgrade --greedy && brew upgrade --casks --greedy'

# Git init and create a repo (--private or --public flag required)
alias gitinitdir='git init \
          && git commit -m "batman" --allow-empty \
          && gh repo create ${PWD##*/} --push -s . '

# Go init project with current dir name
alias goinitdir='go mod init "github.com/dGilli/${PWD##*/}"'

# Create a new dir in ~/Projects
alias mkpjt='mkdir $HOME/Projects/$@'
