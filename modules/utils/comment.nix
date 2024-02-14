{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.utils.comment;
in {
  options.vim.utils.comment = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Comment extension";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["comment"];

    vim.luaConfigRC.vimwiki =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require("Comment").setup {
          sticky = true,
          toggler = {
            line = '<leader>c',
            block = '<leader>Cb',
          },
          opleader = {
            line = '<leader>c',
            block = '<leader>Cb',
          },
          mappings = {
            basic = true,
            extra = false,
          },
        }
      '';
  };
}
