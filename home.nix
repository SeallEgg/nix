{ config, pkgs, ...}:

{
  home.username = "seal";
  home.homeDirectory = "/home/seal";
  programs.git.enable = true;
  home.stateVersion = "25.05";
}
