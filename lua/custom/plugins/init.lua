-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local sound_dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/sounds/'

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

      function AddBold()
        local mode = vim.fn.visualmode() -- More reliable check for visual mode
        local line = vim.api.nvim_get_current_line()

        -- If in visual mode, get selection
        if mode ~= '' then
          vim.cmd 'normal! gv"zy' -- Copy selection to register z
          local selection = vim.fn.getreg 'z'
          local new_line = line:gsub(selection, '\\textbf{' .. selection .. '}', 1)
          vim.api.nvim_set_current_line(new_line)
          return
        end

        -- Otherwise, wrap the current word
        local word = vim.fn.expand '<cword>'
        if word ~= '' then
          local new_line = line:gsub(word, '\\textbf{' .. word .. '}', 1)
          vim.api.nvim_set_current_line(new_line)
        end
      end

      function RemoveBold()
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col '.'

        -- Find the bold text pattern that contains the cursor
        local start_idx = 1
        while true do
          local s, e, inner = line:find('\\textbf{(.-)}', start_idx)
          if not s then
            break
          end

          -- Check if cursor is within this bold text (including \textbf{})
          if col >= s and col <= e then
            -- Replace the bold text with just the inner content
            local new_line = line:sub(1, s - 1) .. inner .. line:sub(e + 1)
            vim.api.nvim_set_current_line(new_line)
            -- Adjust cursor position if needed
            if col > s + 7 then -- 7 is length of "\textbf{"
              local new_col = col - 8 -- 8 is length of "\textbf{" + "}"
              vim.fn.cursor(vim.fn.line '.', new_col)
            end
            return
          end
          start_idx = e + 1
        end
      end

      -- Key mappings
      vim.api.nvim_set_keymap('n', '<leader>b', ':lua AddBold()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', '<leader>b', ':lua AddBold()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>sb', ':lua RemoveBold()<CR>', { noremap = true, silent = true })
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
  -- {
  --   'github/copilot.vim',
  -- },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {}
    end,
  },
  -- {
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     provider = 'copilot',
  --     auto_suggestions_provider = 'copilot',
  --     copilot = {
  --       endpoint = 'https://api.githubcopilot.com',
  --       model = 'claude-3.7-sonnet',
  --       proxy = nil, -- [protocol://]host[:port] Use this proxy
  --       allow_insecure = false, -- Allow insecure server connections
  --       timeout = 30000, -- Timeout in milliseconds
  --       temperature = 0,
  --       max_tokens = 20480,
  --     },
  --     behaviour = {
  --       auto_suggestions = true,
  --       auto_set_highlight_group = true,
  --       auto_set_keymaps = true,
  --       auto_apply_diff_after_generation = false,
  --       support_paste_from_clipboard = true,
  --       minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
  --       enable_token_counting = true, -- Whether to enable token counting. Default to true.
  --       enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
  --       enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
  --     },
  --     suggestion = {
  --       debounce = 600,
  --       throttle = 600,
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = 'make',
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'stevearc/dressing.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     --- The below dependencies are optional,
  --     'echasnovski/mini.pick', -- for file_selector provider mini.pick
  --     'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
  --     'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
  --     'ibhagwan/fzf-lua', -- for file_selector provider fzf
  --     'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
  --     'zbirenbaum/copilot.lua', -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       'HakonHarnes/img-clip.nvim',
  --       event = 'VeryLazy',
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { 'markdown', 'Avante' },
  --       },
  --       ft = { 'markdown', 'Avante' },
  --     },
  --   },
  -- },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.diff',
    },
    config = function()
      require('codecompanion').setup {
        adapters = {
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                model = {
                  default = 'claude-3.7-sonnet',
                },
              },
            })
          end,
        },
        display = {
          action_palette = {
            provider = 'telescope',
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
          chat = {
            show_references = true,
            show_header_separator = true,
            -- show_settings = true, -- this doesn't allow me to select a model
          },
          diff = {
            provider = 'mini_diff',
          },
        },
      }

      vim.keymap.set({ 'n', 'v' }, '<leader>cc', ':CodeCompanionChat Toggle<CR>', {
        noremap = true,
        silent = true,
        desc = 'Toggle CodeCompanion Chat',
      })

      vim.keymap.set({ 'n', 'v' }, '<C-a>', ':CodeCompanionActions<CR>', {
        noremap = true,
        silent = true,
        desc = 'Open CodeCompanion Actions',
      })

      vim.keymap.set({ 'n', 'v' }, 'ga', ':CodeCompanionChat Add<CR>', {
        noremap = true,
        silent = true,
        desc = 'Add selection to CodeCompanion Chat',
      })

      require('custom.plugins.companion.spinner'):init()
    end,
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
