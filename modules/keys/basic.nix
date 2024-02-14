{ lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.keys;
in
{
  options.vim.keys = {
    coreKeys = mkOption {
      default = true;
      description = "Setup core keybindings";
      type = types.bool;
    };
  };
  config = {

    vim.nnoremap =
      if (cfg.coreKeys)
      then {
        "<C-h>" = "<C-w>h";
        "<C-j>" = "<C-w>j";
        "<C-k>" = "<C-w>k";
        "<C-l>" = "<C-w>l";

        "<A-Up>" = ":resize -3<CR>";
        "<A-Down>" = ":resize +3<CR>";
        "<A-Left>" = ":vertical resize +3<CR>";
        "<A-Right>" = ":vertical resize -3<CR>";
        "<F7>" = ":setlocal spell<CR>";

        # Copilot Keys
        "<leader>Cpd" = ":Copilot disable<CR>";
        "<leader>Cpe" = ":Copilot enable<CR>";
        "<leader>Cps" = ":Copilot split<CR>";

        # Return to last edit buffer.
        "<S-Tab>" = ":e #<CR>";

        # Move and center
        "<C-d>" = "<C-d>zz";
        "<C-u>" = "<C-u>zz";

        # utils
        "<leader>w" = ":wa!<CR>";
        "<leader>q" = ":qa<CR>";
      }
      else { };

    vim.vnoremap =
      if (cfg.coreKeys)
      then {
        # Move line up and down
        "J" = ":m '>+1<CR>gv=gv";
        "K" = ":m '<-2<CR>gv=gv";
      }
      else { };
  };
}
