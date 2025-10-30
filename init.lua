-- bootstrap the node environment for neovim
require("config.node").configure_node_environment()
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
