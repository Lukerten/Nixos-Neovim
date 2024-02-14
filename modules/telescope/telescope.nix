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
        "<leader>Hb" = "<cmd>Telescope git_branches<cr>";
        "<leader>Hc" = "<cmd>Telescope colorscheme<cr>";
        "<leader>Hh" = "<cmd>Telescope help_tags<cr>";
        "<leader>Hm" = "<cmd>Telescope man_pages<cr>";
        "<leader>Hr" = "<cmd>Telescope oldfiles<cr>";
        "<leader>HR" = "<cmd>Telescope registers<cr>";
        "<leader>Hk" = "<cmd>Telescope keymaps<cr>";
        "<leader>HC" = "<cmd>Telescope commands<cr>";

        # Buffers
        "<Tab>" = "<cmd> Telescope buffers<CR>";
      }
      // (
        if config.vim.lsp.enable
        then {
          "<leader>Lds" = "<cmd> Telescope lsp_document_symbols<CR>";
          "<leader>Lsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";
          "<leader>Llr" = "<cmd> Telescope lsp_references<CR>";
          "<leader>Lli" = "<cmd> Telescope lsp_implementations<CR>";
          "<leader>LlD" = "<cmd> Telescope lsp_definitions<CR>";
          "<leader>Llt" = "<cmd> Telescope lsp_type_definitions<CR>";
          "<leader>Lld" = "<cmd> Telescope diagnostics<CR>";
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
