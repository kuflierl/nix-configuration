_final: prev: {
  minizip-ng-compat = prev.minizip-ng.overrideAttrs (prev: {
    cmakeFlags = prev.cmakeFlags ++ [ "-DMZ_LIB_SUFFIX=''" ];
  });
}
