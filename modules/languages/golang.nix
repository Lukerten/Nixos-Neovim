{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.golang;

  defaultServer = "gopls";
  servers = {
    gopls = {
      package = pkgs.gopls;
      lspConfig =
        /*
        lua
        */
        ''
          lspconfig.gopls.setup{
            on_attach = attach_keymaps,
            cmd = {'${cfg.lsp.package}/bin/gopls'};
            filetypes = {'gox', 'go'};
          }
        '';
    };
  };
  in {
  options.vim.languages.golang = {
    enable = mkEnableOption "Golang language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Golang treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "go";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Golang LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Golang LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Golang LSP server package";
        type = types.package;
        default = servers.${cfg.lsp.server}.package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.package];
    })

    (mkIf cfg.lsp.enable {
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.golang-lsp = servers.${cfg.lsp.server}.lspConfig;
    })
  ]);
}
