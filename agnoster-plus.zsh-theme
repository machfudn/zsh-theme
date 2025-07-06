# Unicode Separators
local SEP_RIGHT=$'\uE0B0' # 
local DIAMOND_L=$'\uE0B6' # 
local DIAMOND_R=$'\uE0B4' # 

# Ikon
local ICON_SHELL=$'\uF120'   # 
local ICON_FOLDER=$'\uF07B'  # 
local ICON_BRANCH=$'\uE725'  # 
local ICON_CLOCK=$'\uF017'   # 
local ICON_OK=$'\u2714'      # ✔
local ICON_FAIL=$'\u2718'    # ✘

# Warna ANSI (kode bisa kamu ubah kalau mau tema lain)
local FG_WHITE="%F{15}"
local FG_BLACK="%F{0}"
local FG_BLUE="%F{33}"
local FG_ORANGE="%F{208}"
local FG_YELLOW="%F{226}"
local FG_PURPLE="%F{141}"
local BG_BLUE="%K{33}"
local BG_ORANGE="%K{208}"
local BG_YELLOW="%K{226}"
local BG_PURPLE="%K{141}"
local FG_GREEN="%F{2}"
local RESET="%f%k"

# Powerline Separator Helper
function powerline_sep() {
  local fg=$2  # Foreground (next)
  local bg=$1  # Background (current)
  echo "%F{${fg}}%K{${bg}}${SEP_RIGHT}%f%k"
}

# Git segment
function git_segment() {
  local next_bg="$1"  # Warna latar setelah git segment (default ke 0 jika kosong)
  [[ -z "$next_bg" ]] && next_bg=0

  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  local dirty=$(git status --porcelain 2>/dev/null)
  if [[ -n "$branch" ]]; then
    local status_icon=" $ICON_OK"
    [[ -n "$dirty" ]] && status_icon=" $ICON_FAIL"
    echo "${BG_YELLOW}${FG_BLACK} ${ICON_BRANCH} ${branch}${status_icon} $(powerline_sep ${next_bg} 226)"
  fi
}



function precmd() {
  PROMPT=''

  # Segmen: Shell
  PROMPT+="${FG_BLUE}${DIAMOND_L}${RESET}"
  PROMPT+="${BG_BLUE}${FG_WHITE} ${ICON_SHELL} Machfudin "
  PROMPT+="$(powerline_sep 208 33)"  # Biru → Oranye

  # Segmen: Path
  git rev-parse --is-inside-work-tree &>/dev/null
  if [[ $? -eq 0 ]]; then
    NEXT_COLOR=226
  else
    NEXT_COLOR=0
  fi

  PROMPT+="${BG_ORANGE}${FG_WHITE} ${ICON_FOLDER} %1~ "
  PROMPT+="$(powerline_sep ${NEXT_COLOR} 208)"

  # Segmen: Git
  PROMPT+="$(git_segment)"

  PROMPT+="${RESET} "

  # Baris prompt bawah
  PROMPT+=$'\n'
  PROMPT+="${FG_GREEN}→ ${RESET}"
}


# RPROMPT (kanan atas, misalnya waktu)
RPROMPT='${FG_WHITE}${ICON_CLOCK} $(date +%H:%M)'
