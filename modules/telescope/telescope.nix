{pkgs, config, lib, ...}:
with lib;
with builtins; let
  cfg = config.vim.telescope;
in {
  options.vim.telescope = {
    enable = mkEnableOption "enable telescope";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "telescope"
    ];

    vim.nnoremap = {
        # Find Files
        "<leader>f" = "<cmd> Telescope find_files<CR>";
        "<leader>F" = "<cmd> Telescope live_grep<CR>";

        # Help
        "<leader>hb" = "<cmd>Telescope git_branches<cr>";
        "<leader>hc" = "<cmd>Telescope colorscheme<cr>";
        "<leader>hh" = "<cmd>Telescope help_tags<cr>";
        "<leader>hm" = "<cmd>Telescope man_pages<cr>";
        "<leader>hr" = "<cmd>Telescope oldfiles<cr>";
        "<leader>hR" = "<cmd>Telescope registers<cr>";
        "<leader>hk" = "<cmd>Telescope keymaps<cr>";
        "<leader>hC" = "<cmd>Telescope commands<cr>";

        # Buffers
        "<Tab>" = "<cmd> Telescope buffers<CR>";

        "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
        "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
        "<leader>fvs" = "<cmd> Telescope git_status<CR>";
        "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
      }
      // (
        if config.vim.lsp.enable
        then {
          "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
          "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";

          "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
          "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
          "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
          "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
          "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
        }
        else {}
      )
      // (
        if config.vim.treesitter.enable
        then {
          "<leader>fs" = "<cmd> Telescope treesitter<CR>";
        }
        else {}
      );

    vim.luaConfigRC.telescope =
      nvim.dag.entryAnywhere /* lua */ ''
        require("telescope").setup {
          defaults = {
            vimgrep_arguments = {
              "${pkgs.ripgrep}/bin/rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case"
            },
            pickers = {
              find_command = {
                "${pkgs.fd}/bin/fd",
              },
            },
          }
        }
      require("telescope").load_extension('projects')
      '';
  };
}
