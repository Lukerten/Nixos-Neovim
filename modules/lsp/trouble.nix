{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    trouble = {
      enable = mkEnableOption "trouble diagnostics viewer";
    };
  };

  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = ["trouble"];

    vim.nnoremap = {
      "<leader>Xx" = "<cmd>TroubleToggle<CR>";
      "<leader>Lwd" = "<cmd>TroubleToggle workspace_diagnostics<CR>";
      "<leader>Ld" = "<cmd>TroubleToggle document_diagnostics<CR>";
      "<leader>Lr" = "<cmd>TroubleToggle lsp_references<CR>";
      "<leader>Xq" = "<cmd>TroubleToggle quickfix<CR>";
      "<leader>Xl" = "<cmd>TroubleToggle loclist<CR>";
    };

    vim.luaConfigRC.trouble =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        -- Enable trouble diagnostics viewer
        require("trouble").setup {}
      '';
  };
}
