{
  pkgs,
  ...
}:

let
  # Must sort before 73-seat-late.rules, otherwise the uaccess tag is ignored
  # (which is why services.udev.extraRules / 99-local.rules won't work here).
  webhidUdevRules = pkgs.writeTextFile {
    name = "webhid-udev-rules";
    destination = "/etc/udev/rules.d/60-webhid.rules";
    text = ''
      # Grant the logged-in user access to Keychron hidraw devices for WebHID configurators
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", TAG+="uaccess"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ENV{ID_USB_INTERFACES}=="*:fe0102:*", TAG+="uaccess"
    '';
  };
in
{
  services.udev.packages = [ webhidUdevRules ];
}
