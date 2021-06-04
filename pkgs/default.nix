final: prev: {
  sddm-chili =
    prev.callPackage ./applications/display-managers/sddm/themes/chili { };
  pure = prev.callPackage ./shells/zsh/pure { };
  wii-u-gc-adapter = prev.callPackage ./misc/drivers/wii-u-gc-adapter { };
  libinih = prev.callPackage ./development/libraries/libinih { };
  steamcompmgr =
    prev.callPackage ./applications/window-managers/steamcompmgr { };
  widevine-cdm = prev.callPackage ./applications/networking/browsers/widevine { };
}
