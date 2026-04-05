final: prev: {
  fceux = prev.fceux.override { minizip = final.minizip-ng-compat; };
  minizip-ng-compat = prev.minizip-ng.overrideAttrs (prev: {
    cmakeFlags = prev.cmakeFlags ++ [ "-DMZ_LIB_SUFFIX=''" ];
  });
}
