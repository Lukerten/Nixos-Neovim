{ lib, ...}:
with lib;
with builtins;
{
  vim.startPlugins = ["alpha-nvim"];

  vim.nnoremap = {
  "<leader>a" = ":Alpha<CR>";
  };


  vim.luaConfigRC.alpha-nvim = nvim.dag.entryAnywhere /* lua */ ''

    function _RECENT_PROJECTS()
      require'telescope'.extensions.frecency.frecency()
    end

    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
    [[                                                                     ]],
    [[       ███████████           █████      ██                     ]],
    [[      ███████████             █████                             ]],
    [[      ████████████████ ███████████ ███   ███████     ]],
    [[     ████████████████ ████████████ █████ ██████████████   ]],
    [[    █████████████████████████████ █████ █████ ████ █████   ]],
    [[  ██████████████████████████████████ █████ █████ ████ █████  ]],
    [[ ██████  ███ █████████████████ ████ █████ █████ ████ ██████ ]],
    [[ ██████   ██  ███████████████   ██ █████████████████ ]],
    [[ ██████   ██  ███████████████   ██ █████████████████ ]],
    }


    dashboard.section.buttons.val = {
      dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
      dashboard.button("f", "  Find files", ":Telescope find_files <CR>"),
      dashboard.button("s", "󱎸  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
      dashboard.button("t", "  Open Terminal", ":ToggleTerm direction=float<CR>"),
      dashboard.button("d", "  Open Vimwiki", ":VimwikiIndex<CR>"),
      dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
    }

    dashboard.section.footer.val = {
      "    if debugging is the process of removing bugs",
      " then programming must be the process of adding them ",
      " ",
      "          - Edsger W. Dijkstra - ",
    }

    dashboard.section.footer.opts.hl = "Error"
    dashboard.section.header.opts.hl = "Function"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.header.opts.spacing = 0

    dashboard.opts.opts.noautocmd = true
    require("alpha").setup(dashboard.opts)
  '';
}
