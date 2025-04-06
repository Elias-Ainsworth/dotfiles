# ThorneVim

ThorneVim is my personalized configuration of [nvf](https://github.com/NotAShelf/nvf), customized to enhance productivity and development workflows.

## Features

### Language Support

- Comprehensive support for multiple languages including:
- C/C++
- Bash
- Go(lang)
- HTML
- Haskell
- Lua
- Markdown
- Norg
- Nix
- OCaml
- Odin
- Python
- Rust
- Tailwind CSS
- TypeScript
- Typst
- Zig

### Appearance

- Multiple [theme](./config/theme.nix:) options:
- [Catppuccin](https://github.com/catppuccin/nvim) (with transparency option)
- [Oxocarbon](https://github.com/nyoom-engineering/oxocarbon.nvim)
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim) (with transparency option)

- Visual enhancements:
- [Smart column](https://github.com/m4xshen/smartcolumn.nvim) guides
- [Indent scope](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md) visualization
- Icons for file types and Git status via [Nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- Color highlighting via [colorizer](https://github.com/norcalli/nvim-colorizer.lua)
- [Lualine](https://github.com/nvim-lualine/lualine.nvim) for a graceful status line.
- Tab/buffer navigation via [Bufferline](https://github.com/akinsho/bufferline.nvim)

### Development Tools

- [Git](./config/git.nix) integration:
    - [Vim Fugitive](https://github.com/tpope/vim-fugitive)
    - Custom Pre-Commit function

- Intelligent code completion:
    - [Blink.cmp](https://github.com/Saghen/blink.cmp) with snippet support
    - [LuaSnip](https://github.com/L3MON4D3/LuaSnip) for extensible snippet management

- Project management:
    - [Project-nvim](https://github.com/ahmedkhalf/project.nvim/) for project navigation
    - [Rooter](https://github.com/airblade/vim-rooter/) for automatic project root detection
    - [Direnv](https://github.com/direnv/direnv.vim/) integration


### Navigation and Editing

- Ergonomic file navigation with [Harpoon2](https://github.com/ThePrimeagen/harpoon)

- [Mini.nvim](https://github.com/echasnovski/mini.nvim) suite providing:
    - Efficient text manipulation (ai, move, operators)
    - Smart brackets and pairs handling
    - Advanced jumping capabilities (jump, jump2d)
    - Code splitting and joining
    - Intuitive surround operations

- [Tmux integration](https://github.com/christoomey/vim-tmux-navigator):
    - Seamless navigation between panes
    - Window resizing via custom keymaps

- [Which-key](https://github.com/folke/which-key.nvim) for keymap discovery and guidance

### Productivity

- Todo-Comments for highlighting TODO, FIXME, NOTE, and BUG annotations
- LaTeX formula parsing via [nabla](https://github.com/jbyuki/nabla.nvim)
- [Neorg](https://github.com/nvim-neorg/neorg) for structured note-taking
- [Wakatime](https://github.com/wakatime/vim-wakatime) integration for tracking coding activity


### Core Mini.nvim Plugins

- [ai](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md) - Text objects for argument manipulation
- [bracketed](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md) - Enhanced bracket navigation
- [bufremove](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bufremove.md) - Buffer removal with window preservation
- [comment](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md) - Code commenting utilities
- [extra](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-extra.md) - Extra pickers
- [files](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-files.md) - File management
- [indentscope](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md) - Visual indent guides
- [notify](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-notify.md) - Notification system
- [operators](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-operators.md) - Text edit operators
- [pairs](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md) - Auto-pair completion
- [pick](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pick.md) - Fuzzy finder
- [splitjoin](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-splitjoin.md) - Split and join code blocks
- [starter](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-starter.md) - Start screen

### Optional Alternatives

The mini plugins can replace these traditional options by setting `maxi` to true
  via an override:
- [Oil](https://github.com/stevearc/oil.nvim) → mini.files
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) → mini.pick

### Custom Wrappers

- Simplified declaration for:
- Keymaps (with and without options)
- Clues and triggers for mini-clue
- Patterns and highlights for mini-hipatterns

## Installation

### NixOS

Include the following input in your `flake.nix` file:

```nix
{
    inputs.thornevim.url = "github:Elias-Ainsworth/thornevim";
}
```

Then include it in you `environment.systemPackages` or `home.packages` by referencing the input:

```nix
inputs.thornevim.packages.${pkgs.system}.default
```

Alternatively, it can also be run directly:

```console
nix run github:Elias-Ainsworth/thornevim
```

Color schemes, their variants and transparency, as well as whether to enable the `maxi` plugins can be declared via an override:

```nix
(inputs.thornevim.packages.${pkgs.system}.default.override {
    colorscheme = "gruvbox";
    variant = "dark";
    maxi = true;
    transparency = true;
})
```

### Legacy *NIX based operating systems

1. [Install home-manager](https://nix-community.github.io/home-manager/)
2. Then go back to the section on [NixOS](#nixos) and follow those steps.

## Configuration

For options on configuring nvf itself, checkout the
[manual](https://notashelf.github.io/nvf/), and for specific options the
[configuration options](https://notashelf.github.io/nvf/options.html) section.

## Usage

You're kidding me...right? It's neovim...use it like neovim.

## Documentation

This is more so for my reference than anything else. But, if you would like to view my documentation, check out [./docs](./docs).

## Hacking

Just use `nix develop`

## TO-DO

- [ ] Oxocarbon with transparency.
- [ ] Find a way to pass banner value via string interpolation.

## Credits

- [@iynaix](https://github.com/iynaix):
    - This nvf config started with [neovim-iynaix](https://github.com/iynaix/dotfiles/tree/main/packages/neovim-iynaix)...unsurprisingly.
    - I also ~~stole~~ took inspiration from [iynaix/focal](https://github.com/iynaix/focal) for the flake as well as this README.

- [@NotAShelf](https://github.com/NotAShelf)
    - For providing amazing help, even though my questions would have been answered easily by reading the manual.

> [!NOTE] To future me, from past you. RTFM!!!

- [@LilleAila](https://github.com/LilleAila):
    - The overall structure of this flake was ~~stolen~~ inspired by [LilleAila/nvf-config](https://github.com/LilleAila/nvf-config)...what do you expect from me at this point?
    - Further thanks for the extra help regarding configuring nvf's mini.nvim modules.

- [@justchokingaround](https://github.com/justchokingaround):
    - For convincing me to use mini.nvim and for providing me his mini configuration for me to ~~steal~~ take inspiration from.

- [@LuminarLeaf](https://github.com/LuminarLeaf):
    - For helping me with a stupid mistake with my flake [package call](I did not include `inherit inputs;` in my {./flake.nix:39)}. It was literally two words and a semi-colon but I would have spent a millennia trying to fix it to no avail.

- [@TeamWolfyta](https://github.com/TeamWolfyta):
    - For taking an interest in this shitty project...and for bugging me to make this README.

