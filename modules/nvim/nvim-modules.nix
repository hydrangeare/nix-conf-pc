{ pkgs, ... }:
{
  # The theme doesn't work properly on MacOS using the default terminal
  imports = [
  	./treesitter.nix
	./cmp.nix
	./lsp.nix
	./options.nix
  ];
  programs.nixvim = {

    enable = true;
    
    plugins.bufferline = { enable = true; };
    plugins.nvim-autopairs = { enable = true; };
    plugins.lightline = { enable = true; };

    plugins.gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };

    plugins.wilder = {
      enable = true;
      modes = [ ":" "/" "?" ];
    };

    plugins.nvim-tree = {
      enable = true;
      openOnSetupFile = true;
      autoReloadOnWrite = true;
    };

    plugins.telescope = {
      enable = true;
      keymaps = {
        "<leader>fg" = "live_grep";
        "<C-p>" = {
          action = "git_files";
          options = {
            desc = "Telescope Git Files";
          };
        };
      };
      extensions.fzf-native = { enable = true; };
    };

    globals.mapleader = " ";

    extraPlugins = with pkgs.vimPlugins; [
#    	monokai-pro-nvim
        {
          plugin = comment-nvim;
          config = "lua require(\"Comment\").setup()";
      	}
    ];
    colorschemes.ayu.enable = true;
#    extraConfigLua = ''
#        require("monokai-pro").setup({
#         	-- ... your config
#        })
#        -- lua
#        vim.cmd([[colorscheme monokai-pro]])
#    '';

    keymaps = [
      # Global Mappings
      # Default mode is "" which means normal-visual-op
      {
        # Toggle NvimTree
        key = "<C-n>";
        action = "<CMD>NvimTreeToggle<CR>";
      }
      {
        # Format file
        key = "<leader>fm";
        action = "<CMD>lua vim.lsp.buf.format()<CR>";
      }

      # Terminal Mappings
      {
        # Escape terminal mode using ESC
        mode = "t";
        key = "<esc>";
        action = "<C-\\><C-n>";
      }

      # Rust
      {
        # Start standalone rust-analyzer (fixes issues when opening files from nvim tree)
        mode = "n";
        key = "<leader>rs";
        action = "<CMD>RustStartStandaloneServerForBuffer<CR>";
      }

      # {
      #   # Mode can be a string or a list of strings
      #   mode = "n";
      #   key = "<leader>p";
      #   action = "require('my-plugin').do_stuff";
      #   lua = true;
      #   # Note that all of the mapping options are now under the `options` attrs
      #   options = {
      #     silent = true;
      #     desc = "My plugin does stuff";
      #   };
      # }
      ];
   };
}
