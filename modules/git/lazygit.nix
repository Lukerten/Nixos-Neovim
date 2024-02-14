{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.git.lazygit;
in
{
  options.vim.git.lazygit = {
    enable = mkOption {
      type = types.bool;
      description = "enable git plugin: [lazygit]";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [ "lazygit" ];

    vim.nnoremap = {
      "<leader>g" = ":LazyGit<CR>";
    } // (
      if config.vim.telescope.enable
      then {
       "<leader>Go" = ":Telescope git_status<cr>";
       "<leader>Gb" = ":Telescope git_branches<cr>";
       "<leader>Gc" = ":Telescope git_commits<cr>";
      }
      else {}
    );
  };
}
