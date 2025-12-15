# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, libs, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./boot.nix
      #./home-manager.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
    priority = 100;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  console.keyMap = "us";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.fwupd.enable = true;

  services.libinput.enable = true;

  users.users.nox = {
    isNormalUser = true;
    description = "nox";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
      lutris
      moonlight-qt
      fzf
      discord
      gajim
      telegram-desktop
    ];
  };

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker"= 1;
    };
    package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) {});
  };
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    #gamescopeSession.enable = true;
    protontricks.enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.virt-manager.enable = true;
  #users.groups.libvirtd.members = [ "nox" ]; # is this even required?
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    btrfs-progs
    libsForQt5.qtstyleplugin-kvantum
    tealdeer
    onlyoffice-desktopeditors
    python3
    kdePackages.discover
    kdePackages.sddm-kcm
    kdePackages.kcolorchooser
    vlc
    wayland-utils
    streamcontroller
    wireguard-tools
    protonvpn-gui
    gamescope-wsi
    protonup-qt
  ];

  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    #noto-fonts-color-emoji
    twemoji-color-font
    vista-fonts
  ]; 

  # OnlyOffice cant handle symlinks
  # issue #1859 on github
  # system.userActivationScripts = {
  #   copy-fonts-local-share = {
  #     text = ''
  #       rm -rf ~/.local/share/fonts
  #       mkdir -p ~/.local/share/fonts
  #       cp ${pkgs.corefonts}/share/fonts/truetype/* ~/.local/share/fonts/
  #       cp ${pkgs.noto-fonts}/share/fonts/truetype/* ~/.local/share/fonts/
  #       cp ${pkgs.twemoji-color-font}/share/fonts/truetype/* ~/.local/share/fonts/
  #       cp ${pkgs.vista-fonts}/share/fonts/truetype/* ~/.local/share/fonts/
  #       chmod 544 ~/.local/share/fonts
  #       chmod 444 ~/.local/share/fonts/*
  #     '';
  #   };
  # };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };
  
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3";
    #flake = /home/user/my-nixos-config";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    checkReversePath = false;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
