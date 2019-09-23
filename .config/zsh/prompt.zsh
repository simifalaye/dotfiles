PROMPT_LEAN_COLOR1="3"
PROMPT_LEAN_COLOR2="8"
PROMPT_LEAN_COLOR3="5"
PROMPT_LEAN_TMUX=""
PROMPT_LEAN_VIMODE=true
PROMPT_LEAN_LEFT="_prompt_lean_left"

function _prompt_lean_left()
{
    echo " %F{"$PROMPT_LEAN_COLOR2"}── "
}

