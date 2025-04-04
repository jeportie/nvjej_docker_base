export DEFAULT_USER="nvjej"
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

ZSH_COMPDUMP=/tmp/zcompdump

plugins=(
    git
    dirhistory 
    copypath 
    web-search 
    sudo 
    npm
)

VENV_PATH="/root/venv/bin/activate"

if [ -f "$VENV_PATH" ]; then
    source "$VENV_PATH"
    echo "Virtual environment activated."
else
    echo "Virtual environment not found at $VENV_PATH"
fi

source $ZSH/oh-my-zsh.sh

alias venv="source /root/venv/bin/activate"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ensure Node.js and mcp-hub are installed on terminal start
# if ! nvm ls 22.14.0 > /dev/null 2>&1; then
#     nvm install v22.14.0
# fi
#
# if ! npm list -g mcp-hub@1.8.0 > /dev/null 2>&1; then
#     npm install -g mcp-hub@1.8.0
# fi

alias vi="vim"

vim() {
    FLAG="/root/.cache/nvim/mason_installed.flag"
    if [ ! -f "$FLAG" ]; then
        nvim -c 'MasonInstall clang-format codelldb' -c "TSInstall c cpp bash cmake make" "$@"
        # Create the flag file so we don't run initialization again
        touch "$FLAG"
    else
        nvim "$@"
    fi
}

pause() {
    if [ -n "$1" ]; then
        COMMIT=$(basename "$1")
    else
        COMMIT="push pause"
    fi
    git add . && git commit -m "$COMMIT" && git push && git status
}

sepcat() {
  # If no arguments, use the default glob pattern
  if [ "$#" -eq 0 ]; then
    set -- */*
  fi

  for file in "$@"; do
    if [ -f "$file" ]; then
      echo "===== $file ====="
      cat "$file"
    fi
  done
}

cform() {
  local builtin_styles=("LLVM" "Google" "Chromium" "Mozilla" "WebKit" "Microsoft" "GNU")
  local custom_styles_dir="$HOME/.clang-format-styles"
  local custom_styles=($(ls "$custom_styles_dir"))
  local styles=("${builtin_styles[@]}" "${custom_styles[@]}")

  echo "Select a clang-format style:"
  select style in "${styles[@]}"; do
    if [[ -z "$style" ]]; then
      echo "Invalid selection. Please try again."
      continue
    fi

    if [[ " ${builtin_styles[@]} " =~ " ${style} " ]]; then
      ~/.local/share/nvim/mason/bin/clang-format --style "$style" --dump-config > .clang-format
      echo ".clang-format file created with built-in style: $style"
    elif [[ -f "${custom_styles_dir}/${style}" ]]; then
      cp "${custom_styles_dir}/${style}" .clang-format
      echo ".clang-format file created with custom style: $style"
    else
      echo "Selected style not found. Please try again."
      continue
    fi
    break
  done
}

alias maj="bash /sh/update_makefile.sh"
