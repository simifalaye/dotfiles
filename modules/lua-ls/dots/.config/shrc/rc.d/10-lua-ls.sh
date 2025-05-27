if test -d /opt/lua-language-server/bin; then
  [[ "${PATH}" =~ /opt/lua-language-server/bin ]] || \
    export PATH="/opt/lua-language-server/bin:${PATH}"
fi
