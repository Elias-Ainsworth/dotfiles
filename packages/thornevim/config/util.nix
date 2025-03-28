rec {
  mkKeymap = mode: key: action: { inherit mode key action; };
  mkKeymapWithOpts =
    mode: key: action: opts:
    (mkKeymap mode key action) // opts;
  mkTrigger = mode: keys: { inherit mode keys; };
  mkClue = mode: keys: desc: { inherit mode keys desc; };
  # mkPattern =
  #   pattern: # lua
  #   "
  #   function(buf_id)
  #       local commentstring = vim.bo[buf_id].commentstring
  #           if not commentstring or commentstring == '' then
  #               return nil
  #           end
  #           -- Escape special characters in the comment string
  #           local escaped_commentstring = vim.pesc(commentstring):gsub('%%s', '')
  #           -- Pattern to match the comment string followed by TODO and optional colon
  #           return string.format('%s%s:?', escaped_commentstring, '${pattern}')
  #   end,
  #   ";
  # mkHighlighter = pattern: group: {
  #   inherit group;
  #   pattern = mkPattern pattern;
  # };
}
