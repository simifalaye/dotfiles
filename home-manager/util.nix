{config, ...}: rec {
  dot = path: "${config.home.homeDirectory}/dotfiles/home-manager/${path}";

  isDir = path: builtins.pathExists (toString path + "/.");

  linkAll_ = fromOrig: from: to: let
    entries = builtins.readDir from;
    processEntry = name: let
      path = "${from}/${name}";
      link_name = "${to}" + (builtins.substring (builtins.stringLength fromOrig) (builtins.stringLength path) path);
    in
      if isDir path
      then linkAll_ fromOrig path to
      else {
        "${link_name}" = {source = link path;};
      };
    mergeAttrs = lists: builtins.foldl' (acc: elem: acc // elem) {} lists;
  in
    mergeAttrs (map processEntry (builtins.attrNames entries));

  linkAll = from: to: linkAll_ from from to;

  link = path: config.lib.file.mkOutOfStoreSymlink path;
}
