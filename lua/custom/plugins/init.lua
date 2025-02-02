-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local sound_dir = '/Users/user/.config/nvim/lua/custom/plugins/sounds/'

return {
  {
    'wakatime/vim-wakatime',
    lazy = false,
  },
  {
    'andweeb/presence.nvim',
    lazy = false,
    opts = {
      -- General options
      auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
      neovim_image_text = 'Neovim', -- Text displayed when hovered over the Neovim image
      main_image = 'neovim', -- Main image display (either "neovim" or "file")
      client_id = '793271441293967371', -- Use your own Discord application client id (not recommended)
      log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
      -- log_level = 'debug',
      debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
      enable_line_number = false, -- Displays the current line number instead of the current project
      blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
      buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
      file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
      show_time = true, -- Show the timer

      -- Rich Presence text options
      editing_text = 'Editing %s', -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
      file_explorer_text = 'Browsing %s', -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
      git_commit_text = 'Committing changes', -- Format string rendered when committing changes in git (either string or function(filename: string): string)
      plugin_manager_text = 'Managing plugins', -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
      reading_text = 'Reading %s', -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
      workspace_text = 'Working on %s', -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
      line_number_text = 'Line %s out of %s', -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
    },
    config = function(_, opts)
      -- dofile(vim.g.base46_cache .. "presence")
      require('presence').setup(opts)
    end,
  },
  {
    'ThePrimeagen/vim-be-good',
    cmd = { 'VimBeGood' },
  },

  {
    'alec-gibson/nvim-tetris',
    cmd = { 'Tetris' },
  },

  {
    'seandewar/killersheep.nvim',
    cmd = { 'KillKillKill' },
  },

  {
    'jbyuki/instant.nvim',
    cmd = {
      'InstantStartServer',
      'InstantStopServer',
      'InstantStartSingle',
      'InstantJoinSingle',
      'InstantStop',
      'InstantStartSession',
      'InstantJoinSession',
      'InstantStop',
      'InstantStatus',
      'InstantFollow',
      'InstantStopFollow',
      'InstantOpenAll',
      'InstantSaveAll',
      'InstantMark',
      'InstantMarkClear',
    },
    config = function()
      vim.g.instant_username = 'balls'
    end,
  },
  {
    'adelarsq/image_preview.nvim',
    event = 'VeryLazy',
    config = function()
      require('image_preview').setup()
    end,
  },
  {
    'lervag/vimtex',
    init = function()
      vim.g['vimtex_view_method'] = 'skim' -- for variant without xdotool to avoid errors in wayland
      -- only need to pass in the file name
      -- vim.g['vimtex_view_general_viewer'] = 'watch_resume'
      -- vim.g['vimtex_compiler_latexmk'] = {
      --   continuous = 0,
      -- }
      vim.g['vimtex_quickfix_mode'] = 0 -- suppress error reporting on save and build
      vim.g['vimtex_mappings_enabled'] = 0 -- Ignore mappings
      vim.g['vimtex_indent_enabled'] = 0 -- Auto Indent
      vim.g['tex_flavor'] = 'latex' -- how to read tex files
      vim.g['tex_indent_items'] = 0 -- turn off enumerate indent
      vim.g['tex_indent_brace'] = 0 -- turn off brace indent
      vim.g['vimtex_context_pdf_viewer'] = 'skim' -- external PDF viewer run from vimtex menu command
      vim.g['vimtex_log_ignore'] = { -- Error suppression:
        'Underfull',
        'Overfull',
        'specifier changed to',
        'Token not allowed in a PDF string',
      }
    end,
  },
  {
    'tamton-aquib/duck.nvim',
    config = function()
      vim.keymap.set('n', '<leader>dd', function()
        require('duck').hatch()
      end, { desc = 'Hatch a duck' })
      vim.keymap.set('n', '<leader>dk', function()
        require('duck').cook()
      end, { desc = 'Cook a duck' })
      vim.keymap.set('n', '<leader>da', function()
        require('duck').cook_all()
      end, { desc = 'Cook all ducks' })
    end,
  },
  {
    'AndrewRadev/discotheque.vim',
  },
  {
    'willzeng274/reverb.nvim',
    -- event = 'BufReadPre',
    lazy = true, -- Plugin is not loaded on start
    cmd = 'ReverbEnable', -- Plugin is loaded only when :Start is called
    opts = {
      player = 'mpv',
      max_sounds = 20,
      sounds = {
        InsertEnter = { path = sound_dir .. 'carriage1.wav', volume = 50 },
        InsertLeave = { path = sound_dir .. 'ding1.wav', volume = 50 },
        -- TextChangedI = { path = sound_dir .. 'click1.wav', volume = 50 },
        -- TextChangedP = { path = sound_dir .. 'click2.wav', volume = 50 },
        TextChangedI = { path = { sound_dir .. 'click1.wav', sound_dir .. 'click2.wav', sound_dir .. 'click3.wav' }, volume = 50 },
        TextChangedP = { path = { sound_dir .. 'click1.wav', sound_dir .. 'click2.wav', sound_dir .. 'click3.wav' }, volume = 50 },
      },
    },
  },
  {
    'goolord/alpha-nvim',
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require 'alpha.themes.startify'
      -- available: devicons, mini, default is mini
      -- if provider not loaded and enabled is true, it will try to use another provider
      startify.file_icons.provider = 'devicons'
      require('alpha').setup(startify.config)
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'github/copilot.vim',
  },
  {
    'vidocqh/data-viewer.nvim',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kkharji/sqlite.lua', -- Optional, sqlite support
    },
  },
  {
    'toppair/peek.nvim',
    event = { 'VeryLazy' },
    build = 'deno task --quiet build:fast',
    config = function()
      require('peek').setup()
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
  },
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',

      -- optional dependencies:

      -- 'andymass/vim-matchup',          -- for enhanced % motion behavior
      -- 'andrewradev/switch.vim',        -- for switch support
      -- 'tomtom/tcomment_vim',           -- for commenting
      -- 'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers

      -- a completion engine
      --    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices
    },

    ---@type lean.Config
    opts = { -- see below for full configuration options
      mappings = true,
    },
  },
}
