{ pkgs, ... }:
{
    users.users.nox = {
    isNormalUser = true;
    description = "nox";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" ];

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
      (ollama.override {
        acceleration = "rocm";
      })
      jq
      nixd
      nixfmt
    ];
  };
}
