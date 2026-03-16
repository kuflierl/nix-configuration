_: {
  config.vim = {
    viAlias = true;
    vimAlias = true;
    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    options = {
      shiftwidth = 2;
    };

    spellcheck = {
      enable = true;
      programmingWordlist.enable = false; # issues
    };

    lsp = {
      # This must be enabled for the language modules to hook into
      # the LSP API.
      enable = true;

      formatOnSave = true;
      # lspkind.enable = false;
      lightbulb.enable = true;
      # lspsaga.enable = false;
      trouble.enable = true;
      # lspSignature.enable = false; # conflicts with blink in maximal
      otter-nvim.enable = true; # completion help
      nvim-docs-view.enable = true;
      harper-ls.enable = true; # spellcheck
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    # This section does not include a comprehensive list of available language modules.
    # To list all available language module options, please visit the NVF manual.
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      # Configuration File Languages
      toml.enable = true;
      xml.enable = true;
      json.enable = true;

      # Documentation
      markdown.enable = true;

      # Favourite Languages
      nix = {
        enable = true;
        format.type = [ "nixfmt" ];
        lsp.servers = [ "nixd" ];
      };
      bash.enable = true;
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      python.enable = true;
      clang.enable = true;

      # common languages
      assembly.enable = true;
      arduino.enable = true;

      # Build Systems
      make.enable = true;
      cmake.enable = true;

      # Web Languages
      html.enable = true;
      css.enable = true;

      # interesting Langs
      sql.enable = false;
      java.enable = false;
      kotlin.enable = false;
      ts.enable = false;
      go.enable = false;
      lua.enable = false;
      zig.enable = false;

      # Language modules that are not as common.
      typst.enable = false;
      astro.enable = false;
      nu.enable = false;
      csharp.enable = false;
      julia.enable = false;
      vala.enable = false;
      scala.enable = false;
      r.enable = false;
      gleam.enable = false;
      glsl.enable = false;
      dart.enable = false;
      ocaml.enable = false;
      elixir.enable = false;
      haskell.enable = false;
      hcl.enable = false;
      ruby.enable = false;
      fsharp.enable = false;
      just.enable = false;
      qml.enable = false;
      jinja.enable = false;
      tailwind.enable = false;
      svelte.enable = false;
      tera.enable = false;

      # Nim LSP is broken on Darwin and therefore
      # should be disabled by default. Users may still enable
      # `vim.languages.vim` to enable it, this does not restrict
      # that.
      # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
      nim.enable = false;
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      blink-indent.enable = true;
      indent-blankline.enable = true;

      # Fun
      # cellular-automaton.enable = false;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "auto";
      };
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    # nvf provides various autocomplete options. The tried and tested nvim-cmp
    # is enabled in default package, because it does not trigger a build. We
    # enable blink-cmp in maximal because it needs to build its rust fuzzy
    # matcher library.
    autocomplete = {
      # nvim-cmp.enable = !isMaximal;
      blink-cmp.enable = true;
    };

    snippets.luasnip.enable = true;

    filetree = {
      neo-tree = {
        enable = true;
      };
    };

    tabline = {
      nvimBufferline.enable = true;
    };

    treesitter.context.enable = true;

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    git = {
      enable = true;
      gitsigns.enable = true;
      # gitsigns.codeActions.enable = false; # throws an annoying debug message
      neogit.enable = true;
    };

    minimap = {
      # minimap-vim.enable = false;
      codewindow.enable = false; # lighter, faster, and uses lua for configuration
    };

    dashboard = {
      # dashboard-nvim.enable = false;
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = true;
    };

    projects = {
      project-nvim.enable = true;
    };

    utility = {
      # ccc.enable = false;
      # vim-wakatime.enable = false;
      diffview-nvim.enable = true;
      # yanky-nvim.enable = false;
      # qmk-nvim.enable = false; # requires hardware specific options
      icon-picker.enable = true;
      surround.enable = true;
      # leetcode-nvim.enable = false;
      multicursors.enable = true;
      # smart-splits.enable = false;
      undotree.enable = true;
      # nvim-biscuits.enable = true;
      grug-far-nvim.enable = true;

      motion = {
        hop.enable = true;
        leap.enable = true;
        precognition.enable = true;
      };
      images = {
        # image-nvim.enable = false;
        img-clip.enable = false;
      };
    };

    notes = {
      neorg.enable = false;
      orgmode.enable = false;
      mind-nvim.enable = false;
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = false;
      noice.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          ruby = "120";
          java = "130";
          go = [
            "90"
            "130"
          ];
        };
      };
      fastaction.enable = true;
    };

    # assistant = {
    #   chatgpt.enable = false;
    #   copilot = {
    #     enable = false;
    #     cmp.enable = false;
    #   };
    #   codecompanion-nvim.enable = false;
    #   avante-nvim.enable = false;
    # };

    session = {
      nvim-session-manager.enable = false;
    };

    gestures = {
      gesture-nvim.enable = false;
    };

    comments = {
      comment-nvim.enable = true;
    };

    presence = {
      neocord.enable = false;
    };
  };
}
