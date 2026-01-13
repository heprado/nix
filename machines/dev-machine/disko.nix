{
disko.devices = {
    device = "/dev/sda";  # ← ajuste se for NVMe (/dev/nvme0n1)
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";  # EFI System Partition
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        lvm = {
          size = "100%";  # ocupa o resto do disco
          content = {
            type = "lvm_pv";
            vg = "vg0";
          };
        };
      };
    };
  };

  disko.devices.lvm_vg.vg0 = {
    type = "lvm_vg";
    lvs = {
      lv-swap = {
        size = "2G";
        content = {
          type = "swap";
          randomEncryption = false;  # ou true, se quiser criptografia
        };
      };
      lv-root = {
        size = "100%FREE"; #Ocupa tudo.
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
    };
};
}
