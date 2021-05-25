{ ... }: {
  services.openssh = {
    enable = true;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    forwardX11 = true;
    permitRootLogin = "yes";
    startWhenNeeded = true;
    openFirewall = true;
  };
}
