local platform = require("utils.platform")

local options = {
  default_prog = nil,
  launch_menu = {},
}

if platform.is_win then
  if platform.is_wsl then
    options.default_domain = "WSL:Ubuntu"
  else
    options.default_prog = { "powershell" }
  end
  options.launch_menu = {
    { label = "PowerShell Desktop", args = { "powershell" } },
    { label = "Command Prompt", args = { "cmd" } },
    { label = "Msys2", args = { "ucrt64.cmd" } },
  }
elseif platform.is_mac then
  options.default_prog = { "zsh", "-l" }
  options.launch_menu = {
    { label = "Bash", args = { "bash", "-l" } },
    { label = "Fish", args = { "/opt/homebrew/bin/fish", "-l" } },
    { label = "Nushell", args = { "/opt/homebrew/bin/nu", "-l" } },
    { label = "Zsh", args = { "zsh", "-l" } },
  }
elseif platform.is_linux then
  options.default_prog = { "zsh", "-l" }
  options.launch_menu = {
    { label = "Bash", args = { "bash", "-l" } },
    { label = "Fish", args = { "fish", "-l" } },
    { label = "Zsh", args = { "zsh", "-l" } },
  }
end

return options
