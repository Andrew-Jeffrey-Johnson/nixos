{
  #config,
  pkgs,
  lib,
  ...
}:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = "main";
    }
  );
  #utfCli = pkgs.callPackage ./utf-cli.nix;
in
{
  imports = [
    nixvim.homeModules.nixvim
    ./nixvim.nix
    ./hyprland.nix
    #./lsp.nix
  ];
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "andrewj";
  home.homeDirectory = "/home/andrewj";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Preparation for Hyprland
    pkgs.wofi
    pkgs.calcurse
    pkgs.tmux
    #pkgs.termpdfpy
    pkgs.wget
    pkgs.nix-index
    pkgs.manix
    #utfCli
    pkgs.wl-clipboard
    pkgs.catppuccin
    pkgs.wordbook
    pkgs.epy
    pkgs.trash-cli
    pkgs.kiwix
    pkgs.duckdb
    pkgs.sqlite
    pkgs.gamescope # For steam games
    pkgs.wf-recorder

    # For nixvim
    #pkgs.alejandra
    pkgs.gcc # For Neorg
    pkgs.python313Packages.flake8

    pkgs.jdk25
    pkgs.libreoffice-fresh
    pkgs.hunspell
    pkgs.hunspellDicts.en_US-large
    pkgs.prismlauncher
    pkgs.qalculate-qt
    pkgs.qbittorrent
    pkgs.chromium
    pkgs.librewolf
    pkgs.gimp
    pkgs.audacity
    pkgs.inkscape
    pkgs.texstudio
    pkgs.texlive.combined.scheme-full
    pkgs.vlc
    pkgs.poppler
    pkgs.quarto
    pkgs.mermaid-filter
    pkgs.pandoc
    pkgs.mpv
    pkgs.kicad
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      initExtra = "eval \"$(direnv hook bash)\"\n"; # hook direnv
    };
    git = {
      enable = true;
      settings = {
        user.email = "andrew.jeffrey.johnson@gmail.com";
        user.name = "Andrew-Jeffrey-Johnson";
        init.defaultBranch = "main";
        core.excludesFile = "~/.gitignore";
      };
      signing = {
        signByDefault = true;
        key = "ED4D0E25B7FBFAEA62DE63BD71576CF0B1AF61F6";
      };
    };
    gh = {
      enable = true;
    };
    waybar = {
      enable = true;
      systemd.enable = true;
      settings.main = {
        modules-right = [
          "clock"
        ];
        "clock" = {
          format = "{:%I:%M %p}";
        };
      };
    };
    yazi = {
      enable = true;
      settings = {
        mgr = {
          show_hidden = true;
          ratio = [
            1
            3
            4
          ];
        };
        opener = {
          openBook = [
            {
              run = pkgs.epy + /bin/epy + " \"$@\"";
              block = true;
            }
          ];
        };
        open = {
          prepend_rules = [
            {
              name = "*.epub";
              use = "openBook";
            }
          ];
        };
      };
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = "u";
              run = "plugin restore";
              desc = "Restore last deleted files/folders";
            }
            # ... Other keymaps
          ];
        };
      };
      plugins = {
        restore = pkgs.yaziPlugins.restore;
        duckdb = pkgs.yaziPlugins.duckdb;
      };
    };
    nixvim = {
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
    };
    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      enableGitIntegration = true;
      themeFile = "Catppuccin-Latte";
    };
    eww = {
      enable = true;
      configDir = ./eww;
      enableBashIntegration = true;
    };
  };

  services.udiskie = {
    enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".gitignore".text = ''
      debug.txt
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/andrewj/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    LANG = "en_US.UTF-8";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
