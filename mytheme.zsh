local branch_glyph=""
local right_black_arrow_glyph=""
local right_arrow_glyph=""
local left_black_arrow_glyph=""
local left_arrow_glyph=""

# Function to get separator
function k8s_separator() {
  echo "%K{black}%F{blue}$right_black_arrow_glyph %k%f"
}

# Function to get the current Kubernetes context
function k8s_context() {
  local ctx=$(kubectl config current-context 2>/dev/null)
  [ -n "$ctx" ] && echo "%K{blue}%F{black} $ctx %k%f$(k8s_separator)"
}

# Function to get the current directory in a shortened form
function short_pwd() {
  echo "%K{black}%F{white}$(pwd | sed -e "s,^$HOME,~," -e 's,\([^/]\)[^/]*/,\1/,g') %k%f"
}

# Function to get the current Git branch and status
function git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    local gitstatus=$(git status --porcelain=v1 2>/dev/null)
    local color="%K{green}"
    local separator="%K{green}%F{black}$right_black_arrow_glyph %k%f"
    local tail="%F{green}$right_black_arrow_glyph%f"
    if [[ -n $(echo "$gitstatus" | grep '^ M') ]]; then
      color="%K{red}" # modified files
      separator="%K{red}%F{black}$right_black_arrow_glyph %k%f"
      tail="%F{red}$right_black_arrow_glyph %f"
    elif [[ -n $(echo "$gitstatus" | grep '^M') ]]; then
      color="%K{yellow}" # staged changes
      separator="%K{yellow}%F{black}$right_black_arrow_glyph %k%f"
      tail="%F{yellow}$right_black_arrow_glyph %f"
    fi
    echo "${separator}${color}%F{black}$branch_glyph ${branch} %k%f${tail}"
  fi
}

PROMPT="$(k8s_context)$(short_pwd)$(git_branch)
%F{grey}$%f "
