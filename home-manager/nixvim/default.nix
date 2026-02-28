# ~/nixos/home-manager/nixvim/default.nix
{
  pkgs,
  lib,
  ...
}:
{
  globals = {
    # Disable useless providers
    loaded_ruby_provider = 0; # Ruby
    loaded_perl_provider = 0; # Perl
    loaded_python_provider = 0; # Python 2
  };

  clipboard = {
    # Use system clipboard
    register = "unnamedplus";

    providers.wl-copy.enable = true;
  };

  opts = {
    updatetime = 100; # Faster completion

    # Line numbers
    relativenumber = false; # Relative line numbers
    number = true; # Display the absolute line number of the current line
    hidden = true; # Keep closed buffer open in the background
    mouse = "a"; # Enable mouse control
    mousemodel = "extend"; # Mouse right-click extends the current selection
    splitbelow = true; # A new window is put below the current one
    splitright = true; # A new window is put right of the current one

    swapfile = false; # Disable the swap file
    modeline = true; # Tags such as 'vim:ft=sh'
    modelines = 100; # Sets the type of modelines
    undofile = true; # Automatically save and restore undo history
    incsearch = true; # Incremental search: show match for partly typed search command
    inccommand = "split"; # Search and replace: preview changes in quickfix list
    ignorecase = true; # When the search query is lower-case, match both lower and upper-case
    #   patterns
    smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper
    #   case characters
    scrolloff = 8; # Number of screen lines to show around the cursor
    cursorline = false; # Highlight the screen line of the cursor
    cursorcolumn = false; # Highlight the screen column of the cursor
    signcolumn = "yes"; # Whether to show the signcolumn
    laststatus = 3; # When to use a status line for the last window
    fileencoding = "utf-8"; # File-content encoding for the current buffer
    termguicolors = true; # Enables 24-bit RGB color in the |TUI|
    spell = false; # Highlight spelling mistakes (local to window)
    wrap = false; # Prevent text from wrapping

    # Tab options
    tabstop = 2; # Number of spaces a <Tab> in the text stands for (local to buffer)
    shiftwidth = 2; # Number of spaces used for each step of (auto)indent (local to buffer)
    expandtab = true; # Expand <Tab> to spaces in Insert mode (local to buffer)
    autoindent = true; # Do clever autoindenting

    textwidth = 0; # Maximum width of text that is being inserted.  A longer line will be
    #   broken after white space to get this width.

    # Folding
    foldlevel = 300; # Folds with a level higher than this number will be closed
  };
  enable = true;
  defaultEditor = true;
  colorschemes.catppuccin.enable = true;
  viAlias = true;
  vimAlias = true;
  luaLoader.enable = true;
  /*
    lsp.servers = {
      rust_analyzer = {
        enable = true;
        activate = true;
        settings = {
          cmd = [
            "rust-analyzer"
          ];
          filetypes = [
            "rs"
          ];
          checkOnSave = true;
        };
      };
    };
  */
  #plugins = {
  plugins.neorg = {
    enable = true;
    settings.load = {
      "core.concealer" = {
        config = {
          icon_preset = "varied";
        };
      };
      "core.defaults" = {
        __empty = null;
      };
      "core.dirman" = {
        config = {
          workspaces = {
            home = "~/Documents/notes";
          };
        };
      };
    };
  };
  plugins.treesitter.enable = true;
  #};
  #----------Plugins---------------
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        lsp_fallback = true;
        async = false;
        timeout_ms = 500;
      };
      notify_on_error = true;

      formatters_by_ft = {
        sh = [
          "shellcheck"
          "shfmt"
        ];
        python = [
          "isort"
          "black"
          "flake8"
        ];
        docker = [ "hadolint" ];
        css = [ "prettier" ];
        html = [ "prettier" ];
        json = [ "prettier" ];
        lua = [ "stylua" ];
        markdown = [ "prettier" ];
        #nix = ["alejandra"];
        #ruby = ["rubyfmt"];
        terraform = [ "tofu_fmt" ];
        tf = [ "tofu_fmt" ];
        #yaml = ["yamlfmt"]; # NOTE: Does not accept empty lines after keys
        yaml = [ "prettier" ];
      };
    };
  };

  plugins.lsp = {
    enable = true;
    inlayHints = true;
    keymaps = {
      diagnostic = {
        "<leader>E" = "open_float";
        "[" = "goto_prev";
        "]" = "goto_next";
        "<leader>do" = "setloclist";
      };
      lspBuf = {
        "K" = "hover";
        "gD" = "declaration";
        "gd" = "definition";
        "gr" = "references";
        "gI" = "implementation";
        "gy" = "type_definition";
        "<leader>ca" = "code_action";
        "<leader>cr" = "rename";
        "<leader>wl" = "list_workspace_folders";
        "<leader>wr" = "remove_workspace_folder";
        "<leader>wa" = "add_workspace_folder";
      };
    };
    preConfig = ''
      vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
        },
      })

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {border = 'rounded'}
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {border = 'rounded'}
      )
    '';
    postConfig = ''
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    '';
    servers = {
      pylsp = {
        # NOTE: Trouebleshooting this!
        enable = false;
        settings.plugins = {
          black.enabled = true;
          flake8.enabled = true;
          isort.enabled = true;
          jedi.enabled = true;
          pycodestyle.enabled = true;
          pydocstyle.enabled = true;
          pyflakes.enabled = true;
          mccabe.enabled = true;
          rope.enabled = true;
          yapf.enabled = true;
        };
      };
      lua_ls.enable = true; # Lua
      cssls.enable = true; # CSS
      html.enable = true; # HTML
      pyright.enable = true; # Python
      marksman.enable = true; # Markdown
      nil_ls.enable = true; # Nix
      dockerls.enable = true; # Docker
      docker_compose_language_service.enable = true; # Docker compose
      bashls.enable = true; # Bash
      yamlls.enable = true; # YAML
      terraformls.enable = true; # Terraform
      #ansiblels.enable = true; #Ansible
      nginx_language_server.enable = true; # Nginx
      ltex = {
        # English and grammar
        enable = true;
        autostart = true;
        filetypes = [
          "norg"
          "text"
          "txt"
          "latex"
          "tex"
          "html"
          "xhtml"
        ];
        settings = {
          additionalRules = {
            languageModel = "~/nixos/ngrams/en";
          };
        };
      };
    };
  };

  plugins.actions-preview = {
    enable = true;
    #autoLoad = true;
    settings = {
      highlight_command = [
        "require('actions-preview.highlight').delta 'delta --side-by-side'"
        "require('actions-preview.highlight').diff_so_fancy()"
        "require('actions-preview.highlight').diff_highlight()"
      ];
      telescope = {
        layout_config = {
          height = 0.9;
          preview_cutoff = 20;
          preview_height = ''
            function(_, _, max_lines)
              return max_lines - 15
            end
          '';
          prompt_position = "top";
          width = 0.8;
        };
        layout_strategy = "vertical";
        sorting_strategy = "ascending";
      };
    };
  };

  plugins.telescope = {
    enable = true;
  };

  plugins.mini = {
    enable = true;
  };

  plugins.web-devicons = {
    enable = true;
  };

  plugins.cmp = {
    enable = true;
    settings = {
      autoEnableSources = true;
      performance = {
        debounce = 150;
      };
      sources = [
        { name = "path"; }
        {
          name = "nvim_lsp";
          keywordLength = 1;
        }
        {
          name = "buffer";
          keywordLength = 3;
        }
      ];

      snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      formatting = {
        fields = [
          "menu"
          "abbr"
          "kind"
        ];
        format = lib.mkForce ''
          function(entry, item)
            local menu_icon = {
              nvim_lsp = '[LSP]',
              luasnip = '[SNIP]',
              buffer = '[BUF]',
              path = '[PATH]',
            }

            item.menu = menu_icon[entry.source.name]
            return item
          end
        '';
      };

      mapping = lib.mkForce {
        "<Up>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        "<Down>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";

        "<C-p>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        "<C-n>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";

        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";

        "<C-e>" = "cmp.mapping.abort()";
        "<C-y>" = "cmp.mapping.confirm({select = true})";
        "<CR>" = "cmp.mapping.confirm({select = false})";

        "<C-f>" = ''
          cmp.mapping(
            function(fallback)
              if luasnip.jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';

        "<C-b>" = ''
          cmp.mapping(
            function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';

        "<Tab>" = ''
          cmp.mapping(
            function(fallback)
              local col = vim.fn.col('.') - 1

              if cmp.visible() then
                cmp.select_next_item(select_opts)
              elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
              else
                cmp.complete()
              end
            end,
            { "i", "s" }
          )
        '';

        "<S-Tab>" = ''
          cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item(select_opts)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';
      };
      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          scrolloff = 0;
          colOffset = 0;
          sidePadding = 1;
          scrollbar = true;
        };
        documentation = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          maxHeight = 20;
        };
      };
    };
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp-treesitter.enable = true;
  plugins.dap.enable = true;
  plugins.trouble = {
    enable = true;
    settings = { };
  };
  plugins.none-ls = {
    enable = true;
    sources.formatting = {
      black.enable = true;
      alejandra.enable = true;
      hclfmt.enable = true;
      opentofu_fmt.enable = true;
      prettier.enable = true;
      sqlformat.enable = true;
      stylua.enable = true;
      yamlfmt.enable = true;
    };
    sources.diagnostics = {
      trivy.enable = true;
      yamllint.enable = true;
    };
  };

  plugins.lint = {
    enable = true;
    lintersByFt = {
      text = [ "vale" ];
      json = [ "jsonlint" ];
      markdown = [ "prettier" ];
      #ruby = ["rubyfmt"];
      dockerfile = [ "hadolint" ];
      terraform = [ "tofu_fmt" ];
      tf = [ "tofu_fmt" ];
      bash = [ "shellcheck" ];
      yaml = [ "yamlfmt" ];
      #nix = ["alejandra"];
      go = [ "golangci-lint" ];
      python = [ "flake8" ];
      haskell = [ "hlint" ];
      lua = [ "selene" ];
    };
    linters = {
      hadolint = {
        cmd = "${pkgs.hadolint}/bin/hadolint";
      };
      #alejandra = {
      #  cmd = "${pkgs.alejandra}/bin/alejandra";
      #};
      flake8 = {
        cmd = "${pkgs.python313Packages.flake8}/bin/flake8";
      };
    };
  };
  plugins.copilot-chat = {
    enable = false;
  };

  plugins.copilot-cmp = {
    enable = false;
  };
  plugins.copilot-lua = {
    enable = false;
    settings = {
      suggestion = {
        enabled = false;
      };
      panel = {
        enabled = false;
      };
    };
  };
  # extraConfigLua = ''
  #   require("copilot").setup({
  #     suggestion = { enabled = false },
  #     panel = { enabled = false },
  #   })
  # '';
  keymaps = [
    {
      key = "<leader>ct";
      action = "<CMD>CopilotChatToggle<CR>";
      options.desc = "Toggle Copilot Chat Window";
    }
    {
      key = "<leader>cs";
      action = "<CMD>CopilotChatStop<CR>";
      options.desc = "Stop current Copilot output";
    }
    {
      key = "<leader>cr";
      action = "<CMD>CopilotChatReview<CR>";
      options.desc = "Review the selected code";
    }
    {
      key = "<leader>ce";
      action = "<CMD>CopilotChatExplain<CR>";
      options.desc = "Give an explanation for the selected code";
    }
    {
      key = "<leader>cd";
      action = "<CMD>CopilotChatDocs<CR>";
      options.desc = "Add documentation for the selection";
    }
    {
      key = "<leader>cp";
      action = "<CMD>CopilotChatTests<CR>";
      options.desc = "Add tests for my code";
    }
  ];

  plugins.markdown-preview = {
    enable = true;
    settings.theme = "light";
  };
  plugins.render-markdown.enable = true;
  #----------End-Plugins----------------
  extraPlugins = [
  ];
  dependencies = {
    tree-sitter.enable = true;
    nodejs.enable = true;
  };
}
