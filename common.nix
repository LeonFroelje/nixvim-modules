{
  config,
  lib,
  pkgs,
  ...
}:
{
  colorschemes.gruvbox = {
    enable = true;
    settings = {
      terminal_colors = true;
      undercurl = true;
      underline = true;
      bold = true;
      italic = {
        comments = true;
        strings = true;
        emphasis = true;
        operators = false;
        folds = true;
      };
      strikethrough = true;
      contrast = "soft";
    };
  };
  diagnostic.settings = {
    virtual_lines = {
      current_line = true;
    };
    severity_sort = true;
    update_in_insert = true;
  };
  globals = {
    mapleader = ",";
    wrap = false;
  };
  keymaps = [
    {
      mode = "i"; # insert mode
      key = "<C-n>";
      action = "<Esc>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>b";
      action = "<cmd>NvimTreeOpen<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>c";
      action = "<cmd>NvimTreeClose<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>o";
      action = "<cmd>Oil<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>t";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>j";
      action = "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>";
      options = {
        silent = true;
        desc = "Go to next error";
      };
    }
    {
      mode = "n";
      key = "<leader>k";
      action = "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>";
      options = {
        silent = true;
        desc = "Go to previous error";
      };
    }
  ];
  opts = {
    background = "dark";
    number = true;
    autoindent = true;
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    relativenumber = true;
    swapfile = false;
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldtext = "v:lua.vim.treesitter.foldtext()"; # Gives nicely formatted fold text (Neovim 0.10+)
    foldlevel = 99; # Start with everything open
    foldlevelstart = 99; # Start with everything open
    foldenable = true; # Enable folding
  };
  plugins = {
    telescope = {
      enable = true;
      keymaps = {
        "<leader>fg" = "live_grep";
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Find project files";
          };
        };
        "<leader>fd" = {
          action = "diagnostics";
          options = {
            desc = "Find diagnostics";
          };
        };
        "<leader>fc" = {
          action = "git_commits";
          options = {
            desc = "Find commit";
          };
        };
        "<leader>fb" = {
          action = "git_branches";
          options = {
            desc = "Find branch";
          };
        };
        "<leader>fh" = {
          action = "neoclip";
          options = {
            desc = "Find neoclip command history";
          };
        };
        "<leader>gd" = {
          action = "lsp_definitions";
          options = {
            desc = "go to definition of word under cursor";
          };
        };
        "<leader>gt" = {
          action = "lsp_type_definitions";
          options = {
            desc = "go to type definition of word under cursor";
          };
        };
        "<leader>fr" = {
          action = "lsp_references";
        };
        "<C-f>" = {
          action = "current_buffer_fuzzy_find";
        };
        "<leader>ca" = {
          action = "lsp_code_actions";
          options = {
            desc = "LSP Code Actions";
          };
        };
      };
    };
    oil = {
      enable = true;
      settings = {
        view_options = {
          show_hidden = true;
        };
      };
    };

    # ts-autotag = {
    #   enable = true;
    # };

    autoclose = {
      enable = true;
    };
    nvim-autopairs = {
      enable = true;
    };
    nvim-tree = {
      enable = true;
      openOnSetupFile = true;
    };

    web-devicons.enable = true;
    rainbow-delimiters.enable = true;
    lualine.enable = true;
    which-key.enable = true;
    todo-comments.enable = true;
    treesitter-context.enable = true;

    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
            };
          };
          documentation = {
            auto_show = true;
          };
        };
        keymap = {
          preset = "default";
        };
      };
    };

    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        lua
        markdown
        nix
        regex
        toml
        vim
        vimdoc
        yaml
        html
      ];
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    lsp = {
      enable = true;
      servers = {
        nixd = {
          enable = true;
        };
      };
    };
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
      };
    };
    lsp-signature = {
      enable = true;
    };
    trouble = {
      enable = true;
      settings = {
        auto_refresh = true;
      };
    };
    neoclip = {
      enable = true;
    };
    illuminate = {
      enable = true;
    };
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
        };
      };
    };

  };
}
