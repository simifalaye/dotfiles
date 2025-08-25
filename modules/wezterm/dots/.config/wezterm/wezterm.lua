local Config = require("config")

return Config:init()
  :append(require("config.appearance"))
  :append(require("config.bindings"))
  :append(require("config.domains"))
  :append(require("config.general"))
  :append(require("config.launch")).options
