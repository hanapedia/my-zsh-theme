# Function to get the current Kubernetes context
function k8s_context() {
  local ctx=$(kubectl config current-context 2>/dev/null)
  [ -n "$ctx" ] && echo "%F{blue}($ctx)%f "
}

# Function to get the current directory in a shortened form
function short_pwd() {
  echo "%F{cyan}$(pwd | sed -e "s,^$HOME,~," -e 's,\([^/]\)[^/]*/,\1/,g')%f"
}

# Function to get the current Git branch and status
function git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    local gitstatus=$(git status --porcelain=v1 2>/dev/null)
    local color="%F{green}"
    # if [[ -n $(echo "$gitstatus" | grep '^??') ]]; then
    #   color="%F{red}" # untracked changes
    elif [[ -n $(echo "$gitstatus" | grep '^ M') ]]; then
      color="%F{red}" # modified files
    elif [[ -n $(echo "$gitstatus" | grep '^M') ]]; then
      color="%F{yellow}" # staged changes
    fi
    echo "${color}${branch}%f "
  fi
}

PROMPT='$(k8s_context)$(short_pwd) $(git_branch) \n$'
