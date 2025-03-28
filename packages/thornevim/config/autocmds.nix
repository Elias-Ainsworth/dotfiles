_: {
  vim = {
    # autocmds
    luaConfigPost = # lua
      ''
        -- use default colorscheme in tty
        -- https://github.com/catppuccin/nvim/issues/588#issuecomment-2272877967
        vim.g.has_ui = #vim.api.nvim_list_uis() > 0
        vim.g.has_gui = vim.g.has_ui and (vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil)

        if not vim.g.has_gui then
          if vim.g.has_ui then
            vim.o.termguicolors = false
            vim.cmd.colorscheme('default')
          end
          return
        end

        -- remove trailing whitespace on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*",
          command = "silent! %s/\\s\\+$//e",
        })

        -- save on focus lost
        vim.api.nvim_create_autocmd("FocusLost", {
          pattern = "*",
          command = "silent! wa",
        })

        -- absolute line numbers in insert mode, relative otherwise
        vim.api.nvim_create_autocmd("InsertEnter", {
          pattern = "*",
          command = "set number norelativenumber",
        })
        vim.api.nvim_create_autocmd("InsertLeave", {
          pattern = "*",
          command = "set number relativenumber",
        })
      '';
  };
}
