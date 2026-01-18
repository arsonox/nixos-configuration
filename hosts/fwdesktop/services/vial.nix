{
  pkgs,
  ...
}:

let
  vialUdevRules = pkgs.writeTextFile {
    name = "vial-udev-rules";
    destination = "/etc/udev/rules.d/59-vial.rules";
    text = ''
      # For device specific access: https://get.vial.today/manual/linux-udev.html#device-specific-udev-rules
      # Change the rule if the keyboard changes
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0120", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
in
{
  environment.systemPackages = [ pkgs.vial ];
  services.udev.packages = [ vialUdevRules ];
}
