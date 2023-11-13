# Function to get the current Kubernetes context
function k8s_context() {
  local ctx=$(kubectl config current-context 2>/dev/null)
  [ -n "$ctx" ] && echo "($ctx) "
}

# Function to get the current directory in a shortened form
function short_pwd() {
  echo $(pwd | sed -e "s,^$HOME,~," -e 's,\([^/]\)[^/]*/,\1/,g')
}

# Function to get the current Git branch and status
function git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    local gitstatus=$(git status --porcelain=v1 2>/dev/null)
    local color="%F{green}"
    if [[ -n $(echo "$gitstatus" | grep '^??') ]]; then
      color="%F{red}" # untracked changes
    elif [[ -n $(echo "$gitstatus" | grep '^ M') ]]; then
      color="%F{yellow}" # modified files
    elif [[ -n $(echo "$gitstatus" | grep '^M') ]]; then
      color="%F{cyan}" # staged changes
    fi
    echo "${color}${branch}%f "
  fi
}

PROMPT='$(k8s_context)$(short_pwd) $(git_branch)%# '
