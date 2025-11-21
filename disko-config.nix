{ lib, ... }:
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko-config.nix
{
  disko.devices = {
    disk.main = {
      device = lib.mkDefault "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # EFI system partition
          ESP = {
            name = "ESP";
            size = "100M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
            };
          };
          root = {
            name = "rootfs";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=root" "compress=zstd:1" "noatime"];
                  };
                "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "subvol=nix" "compress-force=zstd:1" "noatime"];
                  };
                "/var" = {
                    mountpoint = "/var";
                    mountOptions = [ "subvol=var" "compress=zstd:1" "noatime" "nodatacow" "nodatasum"];
                  };
                # Snapshot these
                "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "subvol=home" "compress=zstd:1" "noatime"];
                  };
                "/var/lib" = {
                    mountpoint = "/var/lib";
                    mountOptions = [ "subvol=var/lib" "compress=zstd:1" "noatime"];
                  };
              };
            };
          };
        };
      };
    };
  };
}
