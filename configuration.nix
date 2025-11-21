{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./disko-config.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      device = "nodev";
      efiSupport = true;
    };
  };
  
  fileSystems."/sharepoint" = {
    device = "sharepoint";
    fsType = "virtiofs";
    options = [ "defaults" "nofail" ];
  };

  networking.hostName = "ahab2";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";
  
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
 
  services.printing.enable = true;

  services.pipewire = {
     enable = true;
     pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.seal = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    fastfetch
    btop
    kitty
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
