{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.utils.glow;
in {
  options.vim.utils.glow = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the glow plugin for markdown preview.";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["glow"];

    vim.luaConfigRC.glow =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require('glow').setup({})
        -- Define the autocommand to set the keybind for Markdown files
        vim.cmd([[
          augroup MarkdownKeybind
            autocmd!
            autocmd FileType markdown nnoremap <buffer> <leader>p :Glow<CR>
        augroup END
        ]])
      '';
  };
}
