{ lib, ... }:
{
  flake.lib = {
    generators = rec {
      # Helper to escape strings safely
      escapeString = s: "\"" + (lib.replaceStrings [ "\"" "\n" ] [ "\\\"" "\\n" ] s) + "\"";

      # Recursive converter
      toRONValue =
        value:
        if value == null then
          "None"
        else if lib.isBool value then
          (if value then "true" else "false")
        else if lib.isInt value || lib.isFloat value then
          toString value
        else if lib.isString value then
          escapeString value
        else if lib.isList value then
          "[${lib.concatStringsSep ", " (map toRONValue value)}]"
        else if lib.isAttrs value then
          "(${attrsToRON value})"
        else
          throw "Unsupported RON type: ${builtins.typeOf value}";

      # Helper for attrsets
      attrsToRON =
        attrs:
        lib.concatStringsSep ",\n" (lib.mapAttrsToList (name: val: "    ${name}: ${toRONValue val}") attrs);
    };
  };
}
