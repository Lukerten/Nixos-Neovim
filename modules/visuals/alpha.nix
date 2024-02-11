{ config, lib, ...}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
in {
  vim.startPlugins = ["alpha-nvim"];

  vim.nnoremap = {
  "<leader>a" = ":Alpha<CR>";
  };


  vim.luaConfigRC.alpha-nvim = nvim.dag.entryAnywhere /* lua */ ''

    function _CREATE_PROJECT()
      vim.cmd('silent! cd ~/projects')
      vim.cmd('silent! !mkdir my_project')
      vim.cmd('silent! cd my_project')
    end

    function _RECENT_PROJECTS()
      require'telescope'.extensions.frecency.frecency()
    end

    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }


    dashboard.section.buttons.val = {
      dashboard.button("n", "  New Project", "lua _CREATE_PROJECT() <CR>"),
      dashboard.button("p", "  Find project", ":silent! Telescope projects <CR>"),
      dashboard.button("f", "  Find files", ":silent! Telescope find_files <CR>"),
      dashboard.button("s", "󱎸  Find text", ":silent! Telescope live_grep <CR>"),
      dashboard.button("t", "  Open Terminal", ":silent! ToggleTerm direction=float<CR>"),
      dashboard.button("r", "  Recently used files", ":silent! Telescope oldfiles <CR>"),
      dashboard.button("e", "󰄐  View Extensions", ":silent! Lazy profile<CR>"),
      dashboard.button("d", "  Vimwiki", ":silent! VimwikiIndex<CR>"),
      dashboard.button("c", "  Configuration", ":silent! e $MYVIMRC <CR>"),
      dashboard.button("q", "  Quit Neovim", ":silent! qa<CR>"),
    }

    dashboard.section.footer.val = {
      "    if debugging is the process of removing bugs",
      " then programming must be the process of adding them ",
      " ",
      "          - Edsger W. Dijkstra - ",
    }

    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.header.opts.spacing = 0

    dashboard.opts.opts.noautocmd = true
    require("alpha").setup(dashboard.opts)
  '';
}
