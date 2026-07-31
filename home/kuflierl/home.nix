{
  self,
  config,
  pkgs,
  lib,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kuflierl";
  home.homeDirectory = "/home/${config.home.username}";

  nixpkgs.overlays = [ self.overlays.default ];

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
  home.packages =
    let
      ghidra_pkg = pkgs.ghidra.withExtensions (
        p: with p; [
          ret-sync
          # wasm
          machinelearning
          ghidraninja-ghidra-scripts
        ]
      );

    in
    with pkgs;
    [
      # Essentials
      htop
      btop
      ncdu
      tree
      nix-output-monitor
      tldr
      ripgrep
      file
      pdftk
      # network tools
      dig
      whois
      traceroute
      nmap
      # GUI tools
      keepassxc
      gnome-calculator
      qpwgraph
      signal-desktop
      vlc
      thunderbird
      mpv
      finamp
      kdePackages.kleopatra
      kdePackages.yakuake
      wireshark
      krename
      handbrake
      # office
      libreoffice-qt6
      # creative
      krita
      gimp
      audacity
      kdePackages.kdenlive
      blender
      obs-studio
      rnote
      # technical
      kicad

      # emulators
      cemu
      fceux
      dolphin-emu

      # programming
      # GUI
      imhex
      logisim-evolution
      ## LSP
      nixd
      clang-tools
      python3Packages.python-lsp-server
      marksman # markdown
      yaml-language-server
      rust-analyzer
      # debuggers
      gdb
      # system/kde
      syncthingtray
      # reverse engineering
      ghidra_pkg
      # nvim dep
      neovim
      clipcat
      nerd-fonts.fira-code
    ];

  fonts.fontconfig.enable = true;

  programs = {
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.trackingprotection.enabled" = true;
        "privacy.sanitize.pending" =
          ''[{"id":"shutdown","itemsToClear":["cache","cookiesAndStorage"],"options":{}}]'';
        "privacy.fingerprintingProtection" = true;
        "captivedetect.canonicalURL" = "http://detectportal.firefox.com/canonical.html";
        "browser.contentblocking.category" = "strict";
      };
    };
    thunderbird.enable = false;
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.email = "41301536+kuflierl@users.noreply.github.com";
        user.name = "kuflierl";
        init.defaultBranch = "main";
        rerere.enabled = true;
      };
      signing = {
        format = "openpgp";
        key = "0B3842DA5392223D";
        signByDefault = true;
      };
      includes = [
        {
          condition = "gitdir:~/Documents/Uni/";
          path = "~/Documents/Uni/.gitconfig";
        }
      ];
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    nh = {
      enable = true;
      flake = "~/nix-configuration";
    };
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    helix = {
      enable = true;
      settings = {
        theme = "onedark";
        editor = {
          mouse = true;
          line-number = "relative";
          auto-completion = true;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt;
        }
      ];
    };
  };

  # todo
  # restic -r sftp:kuflierl@kulnas1.lan:/srv/data/backups/kuflierl/kul6 backup /home/kuflierl --exclude-caches --exclude-file ~/restic-exclude.txt
  # duplicity restore --path-to-restore home/kuflierl/.ssh sftp://kuflierl@kulnas1//srv/data/backups/kuflierl/kul2 ~/ssh.old

  services = {
    syncthing = {
      enable = true;
      tray.enable = false; # we use the plasmoid instead
    };
    kdeconnect.enable = true;
  };
}
