{
  config,
  pkgs,
  user,
  ...
}: {
  # sops is always enabled because github token
  environment.systemPackages = with pkgs; [age sops];

  # to edit secrets file, run "sops hosts/secrets.json"
  sops.defaultSopsFile = ../hosts/secrets.json;

  # use full path to persist as the secrets activation script runs at the start
  # of stage 2 boot before impermanence
  sops.age.sshKeyPaths = ["/persist/home/${user}/.ssh/id_ed25519"];
  sops.gnupg.sshKeyPaths = [];
  sops.age.keyFile = "/persist/home/${user}/.config/sops/age/keys.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = false;

  users.users.${user}.extraGroups = [config.users.groups.keys.name];

  iynaix-nixos.persist.home = {
    directories = [
      ".config/sops"
    ];
  };
}
