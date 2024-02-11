{pkgs, config, lib, ... }:
with lib;
with builtins; let
  cfg = config.vim.visuals.toggleterm;
in {
  options.vim.visuals.toggleterm = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable toggleTerm";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["toggleterm"];

    vim.nnoremap = {
      "<leader>t" = ":ToggleTerm<CR>";
    };

    vim.luaConfigRC.toggleterm = nvim.dag.entryAnywhere /* lua */ ''
      require("toggleterm").setup({
        direction = 'vertical',
        size = 80,
      })


      -- Define a command to open terminal in vertical split
      vim.cmd("command! -nargs=1 VTerm :lua require'toggleterm'.open_vertical(tonumber(<f-args>))")

      -- Set additional options for toggleterm (optional)
      vim.g.toggleterm_close_on_exit = 2  -- Close the terminal window when the process inside it exits
      vim.g.toggleterm_auto_insert = 1
    '';
  };
}
