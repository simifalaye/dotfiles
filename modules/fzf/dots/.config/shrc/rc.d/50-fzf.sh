#-
#  Functions
#-

# Edit Git: Edit git files in current dir OR yadm if not in git dir
function eg {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    git ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
  elif command -v yadm >/dev/null; then
    yadm ls-files | fzf -m --preview "cat {}" | xargs "${EDITOR}"
  else
    echo "Not in git dir" && return
  fi
}
