# Personal Nvim setup


## Setup

### lsp

to get the lsp's to you also have to download the packages onto your PC

lua-language-server (windows)

1. (skip if scoop is installed)..
` iwr -useb get.scoop.sh | iex `
2. (download lua language server)..
` scoop install lua-language-server `

3. (check if it installed correctly)..
` lua-language-server --version `

### WezTerm and Zellij workspace

The Windows WezTerm configuration at `%USERPROFILE%\.wezterm.lua` launches the native
`WSL:Ubuntu` domain with Fish. Fish then automatically opens or attaches to the
persistent `work` Zellij session. The same auto-attach behavior remains enabled
for Windows Terminal.

The shared `Comms` tab runs `slk` and Iamb, and the `Terminal` tab provides a
general-purpose shell. To bypass automatic attachment, start Fish with
`ZELLIJ_DISABLE_AUTO_ATTACH=1`. WezTerm, Zellij, and `slk` use the Kitty graphics
protocol end-to-end for high-quality inline images.

Open a project in the integrated code layout with:

```sh
zcode .
zcode ~/projects/client/project
```

Inside Zellij this adds a project-named tab to the current session. Outside
Zellij it starts the `code` layout in the selected directory. The layout opens
Neovim, PI, and a bottom terminal. `zwork` manually opens the shared workspace.

Use `Ctrl-h/j/k/l` to move seamlessly between Neovim splits and Zellij panes.
`Alt-m` opens Zellij's pane-move mode. Chat notifications set a visual marker
on their Zellij pane/tab and request a Windows Terminal taskbar notification.

The single-row `zjstatus` bar shows the session, tabs, current time, and Spotify
track while the Music tab is running.

### Media, notes, and Git

Authenticate Spotify once:

```sh
spotify_player authenticate
```

Then use `zmusic` to open or focus the Spotify TUI. Press `D` there and select
the Windows Spotify device; streaming is disabled in WSL so playback remains on
Windows. Use `znotes` to open the `~/Notes` Obsidian vault in Neovim.

`Alt-g` opens LazyGit as a large floating Zellij pane from the focused pane's
working directory. `zg` provides the same behavior from a shell. Neovim also
provides Gitsigns hunk navigation with `[c`/`]c`, hunk actions under
`<leader>h`, and Telescope Git pickers under `<leader>g`.

### Language tooling

C# uses EasyDotnet's built-in integration with Microsoft's Roslyn language
server. Install or update its required tools with:

```sh
dotnet tool update -g roslyn-language-server --prerelease \
  --source https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json
dotnet tool update -g EasyDotnet
```

Use `dotnet tool install` instead of `update` on a new machine. EasyDotnet
also configures `nvim-dap` with its bundled `netcoredbg`. Run, build, debug,
and test commands are grouped under `<leader>n`.

Vue, JavaScript, and TypeScript use `vue_ls` and `vtsls`. Keep TypeScript on
the stable 5.9 release because the current Vue language server is not yet
compatible with TypeScript 7:

```sh
npm install -g typescript@5.9.3 \
  @vue/language-server@3.3.11 \
  @vtsls/language-server@0.3.0 \
  vscode-langservers-extracted
```

Conform uses each project's local Prettier installation and nvim-lint uses its
local ESLint installation. Web and Lua files format on save; use
`:FormatDisable`, `:FormatDisable!` (buffer-local), and `:FormatEnable` to
control that behavior. Install StyLua, the tree-sitter CLI, and Linux file-watching support with:

```sh
brew install stylua tree-sitter-cli
sudo apt install inotify-tools
```

Treesitter installs the C#, Razor, Vue, web, SQL, XML, and Markdown parsers
listed in `lua/plugins/treesitter.lua`.


