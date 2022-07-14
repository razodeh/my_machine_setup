export HOME_LOCAL_BIN=$HOME/.local/bin
export PATH=$HOME/bin:$HOME_LOCAL_BIN:$PATH

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# VirutalEnv
export WORKON_HOME="$HOME/.virtualenvs"
source $HOME_LOCAL_BIN/virtualenvwrapper.sh

# jEnv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  
# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# pip aliases
function purge-pip-deps() {
  pip freeze | grep -e '^-e' | awk -F/ '{print $NF}' | xargs pip uninstall -y
  pip freeze | grep -v "^-e" | awk '{print $1}' | xargs pip uninstall -y
}

# Git
function git_current_branch() {
  local ref
  ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo develop
}

function git_repo_https_url() {
  echo "$(git config --get remote.origin.url | sed -e 's/:/\//g'| sed -e 's/ssh\/\/\///g'| sed -e 's/git@/https:\/\//g' | sed 's/....$//')"
}

alias g='git'

alias ga='git add'
alias gaa='git add .'

alias gc='git commit -v -s'
alias gc!='git commit -v --amend -s'
alias gcn!='git commit -v --no-edit --amend'
alias gca='git commit -v -a -s'
alias gca!='git commit -v -a -s --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcmsg='git commit -s -m'

alias gcf='git config --list'

alias gcl='git clone --recurse-submodules'

alias gco='git checkout'
alias gcb='git checkout -b'
alias gcd='git checkout $(git_develop_branch)'
alias gcm='git checkout $(git_main_branch)'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gd='git diff'
alias gds='git diff --staged'
alias gdup='git diff @{upstream}'

alias gfa='git fetch --all'

alias gp='git push'
alias gpf!='git push --force'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

alias gb='git branch'
alias gbd='git branch -d'
alias gbdr='git push origin --delete $(git_current_branch) && git branch --unset-upstream"'
alias gbD='git branch -D'
alias gbr='git branch --remote'
alias gbnm='git branch --no-merged'

alias gl='git pull'

alias glg='git log --stat'
alias glgg='git log --graph --decorate'
alias glgga='git log --graph --decorate --all'

alias gclean='git clean -id'
alias gpristine='git reset --hard && git clean -dffx'

alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grbd='git rebase $(git_develop_branch)'
alias grbm='git rebase $(git_main_branch)'

alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmd='git merge $(git_develop_branch) --no-ff'
alias gmm='git merge $(git_main_branch) --no-ff'

alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'

alias gst='git status'

alias gsta='git stash'
alias gstaa='git stash apply'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gstc='git stash clear'
alias gstl='git stash list'

alias grpo='git remote prune origin'

alias ghub-pr='open $(git_repo_https_url)/pull/new/$(git_current_branch)'
