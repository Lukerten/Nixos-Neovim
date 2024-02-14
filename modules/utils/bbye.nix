{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.utils.bbye;
in {
  options.vim.utils.bbye = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the bbye extension";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["bbye"];

    vim.nnoremap = {
      "<leader>b" = ":Bdelete!<CR>";
    };
  };
}
