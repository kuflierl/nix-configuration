{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kuflierl";
  home.homeDirectory = "/home/kuflierl";

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
    ghidra_pkg = pkgs.ghidra.withExtensions (p: with p; [
        ret-sync
#        wasm
        machinelearning
#        ghidraninja-ghidra-scripts
    ]);
  in with pkgs; [
    # Esentials
    htop
    btop
    ncdu
    tree
    nix-output-monitor
    nh
    tldr
    ripgrep
    # network tools
    dig
    whois
    # gui tools
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
    # gui
    imhex
    logisim-evolution
    ## lsp
    nixd
    clang-tools
    python3Packages.python-lsp-server
    marksman # markdown
    yaml-language-server
    rust-analyzer
    # debuggers
    gdb
    # system/kde
    # kdePackages.kio-fuse
    # kdePackages.kio-extras
    syncthingtray
    # reverse engineering
    ghidra_pkg
    # nvim dep
    neovim
    clipcat
    nerd-fonts.fira-code
  ];

  fonts.fontconfig.enable = true;

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
  #  /etc/profiles/per-user/kuflierl/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.trackingprotection.enabled" = true;
        "privacy.sanitize.pending" = ''[{"id":"shutdown","itemsToClear":["cache","cookiesAndStorage"],"options":{}}]'';
        "privacy.fingerprintingProtection" = true;
        "captivedetect.canonicalURL" = "http://detectportal.firefox.com/canonical.html";
        "browser.contentblocking.category" = "strict";
      };
    };
    thunderbird.enable = false;
    neovim = {
      
    };
    git = {
      enable = true;
      settings = {
        user.email = "41301536+kuflierl@users.noreply.github.com";
        user.name = "kuflierl";
        init.defaultBranch = "main";
      };
      signing = {
        format = "openpgp";
        key = "0B3842DA5392223D";
        signByDefault = true;
      };
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
