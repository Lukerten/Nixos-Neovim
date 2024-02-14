{config, lib, ...}:
with lib;
with builtins; let
  cfg = config.vim.utils.vimwiki;
in {
  options.vim.utils.vimwiki = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable vimwiki extension";
    };

    wikiPath = mkOption {
      type = types.str;
      default = "vimwiki/";
      description = "Path to the vimwiki Directory";
    };

    wikiExt = mkOption {
      type = types.str;
      default = ".md";
      description = "Extension for the diary files";
    };

    wikiSyntax = mkOption {
      type = types.str;
      default = "markdown";
      description = "Syntax for the diary files";
    };
  };

  config =  mkIf cfg.enable {
    vim.startPlugins = ["vimwiki"];

    vim.nnoremap = {
      "<leader>d" =  ":VimwikiIndex 1<CR>"; # Main
      "<leader>Dt" = ":VimwikiIndex 2<CR>"; # Todo
    };

    vim.luaConfigRC.vimwiki =
      nvim.dag.entryAnywhere /* lua */''
        vim.g.vimwiki_list = {
          {
            path= ${"'~/" + cfg.wikiPath + "'"},
            syntax= ${"'" + cfg.wikiSyntax + "'"},
            ext= ${"'" + cfg.wikiExt + "'"},
          },
          {
            path= ${"'~/" + cfg.wikiPath + "todo/'"},
            syntax= ${"'" + cfg.wikiSyntax + "'"},
            ext= ${"'" + cfg.wikiExt + "'"},
          }
        }

        vim.g.vimwiki_ext2syntax = {
          ['.md'] = 'markdown',
          ['.markdown'] = 'markdown',
          ['.mdown'] = 'markdown',
        }

        vim.g.vimwiki_global_ext = 0
        vim.g.vimwiki_map_prefix = '<leader>W'
        vim.g.vimwiki_hl_headers = 0
        vim.g.vimwiki_hl_cb_checked = 0
        vim.g.vimwiki_path = ${"' ~/" + cfg.wikiPath + "'"}
      '';
    };
}


