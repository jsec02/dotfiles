### dotfiles

Personal dotfiles and configuration management for my linux machines

<!-- CODE_STATISTICS_START -->

### Code Statistics

```
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Lua                             59            608            589           3931
TOML                             6             44             32            316
JSON                             3              0              0            250
Markdown                         2              9              4            140
-------------------------------------------------------------------------------
SUM:                            70            661            625           4637
-------------------------------------------------------------------------------
```
<!-- CODE_STATISTICS_END -->

<!-- PROJECT_STRUCTURE_START -->

### Project Structure

```
dotfiles
|-- README.md
|-- direnv
|   `-- direnv.toml
|-- git
|-- helix
|   |-- config.toml
|   |-- languages.toml
|   `-- themes
|       `-- astrodark.toml
|-- kak
|   `-- kakrc
|-- nvim
|   |-- COMMANDS.md
|   |-- after
|   |   `-- ftplugin
|   |       |-- css.lua
|   |       |-- html.lua
|   |       |-- htmldjango.lua
|   |       |-- javascript.lua
|   |       |-- json.lua
|   |       |-- kdl.lua
|   |       |-- lua.lua
|   |       |-- man.lua
|   |       |-- markdown.lua
|   |       |-- ps1.lua
|   |       |-- python.lua
|   |       |-- sh.lua
|   |       `-- sql.lua
|   |-- init.lua
|   |-- lazy-lock.json
|   |-- lua
|   |   |-- core
|   |   |   |-- autocommands.lua
|   |   |   |-- diagnostics.lua
|   |   |   |-- filetypes.lua
|   |   |   |-- init.lua
|   |   |   |-- keymaps.lua
|   |   |   |-- lazy.lua
|   |   |   `-- options.lua
|   |   |-- custom
|   |   |   |-- extensions
|   |   |   |   |-- heirline_path.lua
|   |   |   |   `-- highlights.lua
|   |   |   `-- modules
|   |   |       |-- code_debugger.lua
|   |   |       |-- code_runner.lua
|   |   |       |-- divider_generator.lua
|   |   |       |-- eof_padding.lua
|   |   |       |-- init.lua
|   |   |       |-- status_column.lua
|   |   |       |-- winbar_breadcrumbs.lua
|   |   |       `-- window_swapper.lua
|   |   `-- plugins
|   |       |-- coding
|   |       |   |-- autopairs.lua
|   |       |   |-- autotag.lua
|   |       |   |-- gitsigns.lua
|   |       |   |-- mini_ai.lua
|   |       |   |-- mini_surround.lua
|   |       |   `-- treesitter.lua
|   |       |-- lsp_completion
|   |       |   |-- blink_cmp.lua
|   |       |   |-- conform.lua
|   |       |   |-- lazydev.lua
|   |       |   |-- lsp_config.lua
|   |       |   |-- mason.lua
|   |       |   `-- nvim-lint.lua
|   |       |-- ui
|   |       |   |-- colorscheme.lua
|   |       |   |-- heirline.lua
|   |       |   |-- illuminate.lua
|   |       |   |-- mini_icons.lua
|   |       |   |-- nvim_highlight_colors.lua
|   |       |   |-- nvim_ufo.lua
|   |       |   `-- rainbow_delimiters.lua
|   |       `-- utils
|   |           |-- cmdline.lua
|   |           |-- flash.lua
|   |           |-- guess_indent.lua
|   |           |-- oil.lua
|   |           |-- quicker.lua
|   |           |-- snacks.lua
|   |           |-- todo_comments.lua
|   |           |-- whichkey.lua
|   |           `-- zellij_nav.lua
|   |-- snippets
|   |   |-- python.json
|   |   `-- sh.json
|   `-- spell
|       |-- en.utf-8.add
|       `-- en.utf-8.add.spl
|-- sqlite
|-- ssh
|   `-- config
|-- yazi
|   |-- theme.toml
|   `-- yazi.toml
|-- zellij
|   |-- config.kdl
|   `-- themes
|       `-- astrodark.kdl
`-- zsh

27 directories, 76 files
```
<!-- PROJECT_STRUCTURE_END -->
