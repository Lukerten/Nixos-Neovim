{lib, ... }:
with lib;
with builtins;{
  vim.startPlugins = ["toggle-term"];
  vim.nnoremap = {
    "<leader>Tf" = ":ToggleTerm<CR>";
    "<leader>Tn" = ":lua _Node_Term<CR>";
    "<leader>Tu" = ":lua _NCDU_Term<CR>";
    "<leader>Th" = ":lua _HTOP_Term<CR>";
    "<leader>Tp" = ":lua _PYTHON_Term<CR>";
    "<leader>t"  = ":lua _Shell_Term<CR>";
  };

  vim.luaConfigRC.toggle-term = nvim.dag.entryAnywhere /* lua */ ''
  require("toggleterm").setup({
    size = 20;
    open_mapping = [[<C-%]],
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  })

  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
  local shell = Terminal:new({ direction = "horizontal", hidden = true, size = 20, start_in_insert = false})
  local node = Terminal:new({ cmd = "node", hidden = true })
  local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })
  local htop = Terminal:new({ cmd = "htop", hidden = true })
  local python = Terminal:new({ cmd = "python", hidden = true })
  function _Node_Term()
    node:toggle()
  end

  function _NCDU_Term()
    ncdu:toggle()
  end

  function _HTOP_Term()
    htop:toggle()
  end

  function _PYTHON_Term()
    python:toggle()
  end

  function _Shell_Term()
    shell:toggle()
    vim.cmd("NvimTreeToggle")
    vim.cmd("NvimTreeToggle")
  end
  '';
}
