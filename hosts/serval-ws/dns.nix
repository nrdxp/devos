{ self, ... }: {
  age.secrets.cloudflare = {
    file = "${self}/secrets/cloudflare.age";
    owner = "cfdyndns";
  };

  services.cfdyndns = {
    enable = true;
    email = "tim.deh@pm.me";
    records = [ "serval.nrdxp.dev" ];
    apikeyFile = "/run/secrets/cloudflare";
  };
}
