{ pkgs, ... }:

{
  users.users.nox = {
    isNormalUser = true;
    description = "nox";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
    ];

    packages = with pkgs; [
      lutris
      moonlight-qt
      fzf
      discord
      gajim
      telegram-desktop
      winbox4
      wakelan
      haruna
      yt-dlp
      ungoogled-chromium
      iperf3
      mission-center
      jq
      nixd
      nixfmt
      nil
      package-version-server
      go
      gopls
      lmstudio
      trezor-suite
      trezord
    ];
  };
}
