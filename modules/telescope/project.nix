{pkgs, config, lib, ...}:
with lib;
with builtins; let
  cfg = config.vim.project;
in {
  options.vim.project = {
    enable = mkEnableOption "enable project.nvim";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "project_nvim"
    ];

    vim.nnoremap = {

    };

    vim.luaConfigRC.projects =
      nvim.dag.entryAnywhere /* lua */ ''
        require("project_nvim").setup {
          active = true,
          on_config_done = nil,
          manual_mode = false,
          detection_methods = { "pattern" },
          patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
          show_hidden = false,
          silent_chdir = true,
          ignore_lsp = {},
          datapath = vim.fn.stdpath("data"),
        }
        -- require("telescope").load_extensions('project_nvim')
      '';
  };
}
