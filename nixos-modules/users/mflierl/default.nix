{ config, lib, pkgs, ... }:
{
  sops.secrets."users/mflierl/unix_hash" = {
    format = "yaml";
    key = "unix_hash";
    sopsFile = ../../secrets/users/mflierl.yaml;
    neededForUsers = true;
  };
  users.users."mflierl" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/mflierl/unix_hash".path;
    openssh.authorizedKeys.keys = [
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDw2wn8wz/BNwbCtDu5cbsyVFuCRe/lnsmVRsj1GaRIXoGRAAZ9IhPOkQRDfqdGi0Tu5vx7cByBn3euZnbQMSVcys9dj76sf87vz8vckO0iEF3blzeXjpXTBjJEjDRVyk7xZewqYRsAl7G+QvBISqFlSIZh1u3MoD63dokqatdAOsWJ6LkCNePrx5XTLvHYeh0IA/Oib/PYkXRGd089KMOxxzWU15k6XaF7msDCj7HfFS0liqJJ2PfOeEBQjEyG75zSGzlFqas8XooCG3/VQ+eHB22yH7vkQo47/nuzdGqBK3Fut1IhxXbcS1uKAbswLdOU+KcuCbEQ7DCAL2hLbIH32yvn0xwdpT5kj8rZYDWMdNWUtpyOVG5tgSyvlkrLQJO3CwGggWZZN8RdaEff/glIQRxqMKkJ8Sp2xwPB06PWQUDqJCCpkvdlj96wSIsBaqZGWMIwiSa8+irt5PgalcExvmsxw4peLo7bEkXDFM129rL5UPc1O+TYRNCKTGV+92c= mflierl@msl4.local
    ];
  };
}
