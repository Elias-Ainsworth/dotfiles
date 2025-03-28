return {
    'echasnovski/mini.nvim',
    --
    config = function()
        local miniclue = require 'mini.clue'
        miniclue.setup {
            triggers = {
                -- Leader triggers
                { mode = 'n', keys = '<leader>' },
                { mode = 'x', keys = '<leader>' },
                { mode = 'v', keys = '<leader>' },
                { mode = 'n', keys = '<localleader>' },
                { mode = 'x', keys = '<localleader>' },
                { mode = 'v', keys = '<localleader>' },
                { mode = 'n', keys = '\\' },

                -- Built-in completion
                { mode = 'i', keys = '<C-x>' },

                -- `g` key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },

                -- Marks
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },

                -- Registers
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },

                -- Window commands
                { mode = 'n', keys = '<C-w>' },

                -- `z` key
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },
            },

            clues = {
                -- normal mode
                { mode = 'n', keys = '<leader>a', desc = '[A]dd to Harpoon' },
                { mode = 'n', keys = '<leader>c', desc = '[C]ode' },
                { mode = 'n', keys = '<leader>d', desc = '[D]ap/[D]ocument' },
                { mode = 'n', keys = '<leader>g', desc = '[G]it' },
                { mode = 'n', keys = '<leader>r', desc = '[R]ust' },
                { mode = 'n', keys = '<leader>l', desc = '[L]spsaga' },
                { mode = 'n', keys = '<leader>n', desc = '[N]otifications' },
                { mode = 'n', keys = '<leader>s', desc = '[S]nippets/[S]upermaven' },
                { mode = 'n', keys = '<leader>f', desc = '[F]ind' },
                { mode = 'n', keys = '<leader>w', desc = '[W]orkspace' },
                { mode = 'n', keys = '<leader>t', desc = 'Neo[T]est', icon = '' },
                { mode = 'n', keys = '<leader>h', desc = 'Git [H]unk' },
                { mode = 'n', keys = '<leader>l', desc = 'Format' },
                { mode = 'n', keys = '<localleader>w', desc = '[W]orkspace' },
                { mode = 'n', keys = '<localleader>d', desc = '[D]iffview' },
                { mode = 'n', keys = '<localleader>t', desc = '[T]oggle' },

                -- visual mode
                { mode = 'v', keys = '<leader>h', desc = 'Git [H]unk' },

                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
        }
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        local ai = require 'mini.ai'
        local gen_ai_spec = require('mini.extra').gen_ai_spec
        require('mini.ai').setup {
            n_lines = 500,
            custom_textobjects = {
                l = ai.gen_spec.treesitter { a = '@block.outer', i = '@block.inner' },
                o = ai.gen_spec.treesitter {
                    a = { '@conditional.outer', '@loop.outer' },
                    i = { '@conditional.inner', '@loop.inner' },
                },
                f = ai.gen_spec.treesitter {
                    a = '@function.outer',
                    i = '@function.inner',
                },                                                                     -- function
                c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
                t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },    -- tags
                d = { '%f[%d]%d+' },                                                   -- digits
                e = {                                                                  -- Word with case
                    {
                        '%u[%l%d]+%f[^%l%d]',
                        '%f[%S][%l%d]+%f[^%l%d]',
                        '%f[%P][%l%d]+%f[^%l%d]',
                        '^[%l%d]+%f[^%l%d]',
                    },
                    '^().*()$',
                },
                i = gen_ai_spec.indent(),
                g = gen_ai_spec.buffer(),
                u = ai.gen_spec.function_call(),                          -- u for "Usage"
                U = ai.gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
                k = {                                                     -- this for "# %%" blocks in python files
                    { '# %%.-\n().-().\n# %%', '^# %%.-().*\n()' },
                },
            },

            -- TODO: don't hardcode 'q' but how to get id?
            vim.keymap.set('v', '<Tab>', function()
                local id = 'q'
                if id then
                    MiniAi.select_textobject('i', id, { search_method = 'next' })
                end
            end),
            vim.keymap.set('v', '<S-Tab>', function()
                local id = 'q'
                if id then
                    MiniAi.select_textobject('i', id, { search_method = 'prev' })
                end
            end),
        }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()
        require('mini.align').setup() -- gAip=
        require('mini.move').setup()  -- 'v' <A-hjkl>

        require('mini.basics').setup {
            -- enables \ binds (toggling options), <C-s> for saving and g/ for search in visual mode
            mappings = {
                windows = false,      -- remapped <C-hjkl> to zellij plugin
                move_with_alt = true, -- move with <A-hjkl> in insert and command modes
            },
        }

        require('mini.bracketed').setup()
        -- NOTE: haven't explored this yet but wanna
        -- require('mini.extra').setup {}

        require('mini.files').setup {
            windows = {
                preview = true,
            },
            vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<CR>', { desc = 'File Tree' }),
        }

        require('mini.jump').setup() -- better f,F,t,T
        local jump2d = require 'mini.jump2d'
        require('mini.jump2d').setup {
            mappings = {
                start_jumping = '', -- disable default <CR>
            },

            vim.keymap.set('n', 'H', function()
                jump2d.start(jump2d.builtin_opts.single_character)
            end, { desc = 'Jump Anywhere' }),

            vim.keymap.set('n', '<leader>j', function()
                jump2d.start(jump2d.builtin_opts.line_start)
            end, { desc = '[J]ump to line' }),

            vim.keymap.set('n', '<leader>sq', function()
                jump2d.start(jump2d.builtin_opts.query)
            end, { desc = 'Jump by [Q]uery' }),
        } -- basically hop
        vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = '#ff007c', bold = true })

        require('mini.cursorword').setup()
        local hipatterns = require 'mini.hipatterns'
        require('mini.hipatterns').setup {
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        }
        require('mini.icons').setup()
        require('mini.starter').setup()
        require('mini.tabline').setup()
        require('mini.trailspace').setup()

        local statusline = require 'mini.statusline'
        statusline.setup {
            use_icons = vim.g.have_nerd_font,
        }

        -- TODO: customize
        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field

        -- statusline.section_location = function()
        --   return '%2l:%-2v'
        -- end
        --

        require('mini.operators').setup {

            replace = {
                prefix = 'cr', -- to avoid conflicts with gr
            },
            -- don't forget to remap default gx bc operators' exchange overwrites it
        }
    end,
}
