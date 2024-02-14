{ config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.git;
in
{
  options.vim.git = {
    enable = mkEnableOption "Git support";

    gitsigns = {
      enable = mkEnableOption "gitsigns";

      codeActions = mkEnableOption "gitsigns codeactions through null-ls";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.gitsigns.enable (mkMerge [
      {
        vim.startPlugins = [ "gitsigns-nvim" ];

        vim.nnoremap = {
          "<leader>Gj" = ":lua require 'gitsigns'.next_hunk()<cr>";
          "<leader>Gk" = ":lua require 'gitsigns'.prev_hunk()<cr>";
          "<leader>Gl" = ":lua require 'gitsigns'.blame_line()<cr>";
          "<leader>Gp" = ":lua require 'gitsigns'.preview_hunk()<cr>";
          "<leader>Gr" = ":lua require 'gitsigns'.reset_hunk()<cr>";
          "<leader>GR" = ":lua require 'gitsigns'.reset_buffer()<cr>";
          "<leader>Gs" = ":lua require 'gitsigns'.stage_hunk()<cr>";
          "<leader>Gu" = ":lua require 'gitsigns'.undo_stage_hunk()<cr>";
          "<leader>Gd" = ":Gitsigns diffthis HEAD<cr>";
        };

        vim.luaConfigRC.gitsigns = nvim.dag.entryAnywhere /* lua */''
          require('gitsigns').setup {
            watch_gitdir = {
              interval = 1000,
              follow_files = true
            },
            attach_to_untracked = true,
            current_line_blame = false,
            current_line_blame_opts = {
              virt_text = true,
              virt_text_pos = 'eol',
              delay = 1000,
              ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            max_file_length = 3000,
            preview_config = {
              -- Options passed to nvim_open_win
              border = 'single',
              style = 'minimal',
              relative = 'cursor',
              row = 0,
              col = 1
            },
            yadm = {
              enable = false
            },
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end
            end
          }
        '';
      }

      (mkIf cfg.gitsigns.codeActions {
        vim.lsp.null-ls.enable = true;
        vim.lsp.null-ls.sources.gitsigns-ca = /* lua */''
          table.insert(
            ls_sources,
            null_ls.builtins.code_actions.gitsigns
          )
        '';
      })
    ]))
  ]);
}
