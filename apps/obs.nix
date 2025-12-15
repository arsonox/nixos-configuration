{ config, pkgs, ... }: 
{
  program.obs-studio = {
    enable = true;
    plugins = [
      obs-input-overlay
    ];
  };
}
