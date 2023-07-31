-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},         -- Required
			{'hrsh7th/cmp-nvim-lsp'},     -- Required
			{'hrsh7th/cmp-buffer'},       -- Optional
			{'hrsh7th/cmp-path'},         -- Optional
			{'saadparwaiz1/cmp_luasnip'}, -- Optional
			{'hrsh7th/cmp-nvim-lua'},     -- Optional

			-- Snippets
			{'L3MON4D3/LuaSnip'},             -- Required
			{'rafamadriz/friendly-snippets'}, -- Optional
		}
	}

    use('github/copilot.vim')
    use('ThePrimeagen/vim-be-good')

    use({
        "jackMort/ChatGPT.nvim",
        config = function()
            require("chatgpt").setup({
                api_key_cmd = "op read op://Private/55bi7szbphqgjobr7lfh2yni6a/credential --no-newline",
            })
        end,
        requires = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    })

    use('Bekaboo/deadcolumn.nvim')

    use({
        "epwalsh/obsidian.nvim",
        config = function()
            require("obsidian").setup({
                dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Personal",
                daily_notes = {
                    folder = "dailies",
                },
                completion = {
                    nvim_cmp = true,
                },
                --note_id_func = function(title)
                --    local sane_name = ""
                --    if title ~= nil then
                --        -- If title is given, transform it into valid file name.
                --        sane_name = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
                --    else
                --        -- If title is nil, just add 4 random uppercase letters to the suffix.
                --        for _ in 1, 4 do
                --            sane_name = sane_name .. string.char(math.random(65, 90))
                --        end
                --    end
                --    return sane_name
                --end,
            })
        end,
    })

    use {
        "someone-stole-my-name/yaml-companion.nvim",
        requires = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("telescope").load_extension("yaml_schema")
        end,
    }

    use 'mfussenegger/nvim-dap'
    use 'windwp/nvim-projectconfig'
end)
