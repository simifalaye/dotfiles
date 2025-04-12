function edit
  if test -n "$VISUAL"
    eval $VISUAL
  else
    eval $EDITOR
  end
end
