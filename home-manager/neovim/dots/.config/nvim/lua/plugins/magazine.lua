local lz = require("utils.lazy").new("magazine", function()
	local cmp = require("cmp")
	local function has_words_before()
		local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	-- Setup nvim-snippets/friendly-snippets
	local friendly_path = nil
	for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
		if string.match(path, "friendly.snippets") then
			friendly_path = vim.fs.joinpath(path, "snippets")
			break
		end
	end
	require("snippets").setup({
		create_autocmd = true,
		search_paths = {
			vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "snippets"),
			friendly_path,
		},
		extended_filetypes = {
			bash = { "shell" },
			cpp = { "c" },
			sh = { "shell" },
			zsh = { "shell" },
		},
	})

	local WIDE_HEIGHT = 40
	local compare = require("cmp.config.compare")
	local types = require("cmp.types")
	local opts = {
		enabled = function()
			local disabled = false
			disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
			disabled = disabled or (vim.fn.reg_recording() ~= "")
			disabled = disabled or (vim.fn.reg_executing() ~= "")
			disabled = disabled or vim.b["bigfile"]
			return not disabled
		end,

		performance = {
			debounce = 60,
			throttle = 30,
			fetching_timeout = 500,
			filtering_context_budget = 3,
			confirm_resolve_timeout = 80,
			async_budget = 1,
			max_view_entries = 200,
		},

		preselect = types.cmp.PreselectMode.Item,

		mapping = {
			["<PageUp>"] = cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Select,
				count = 8,
			}),
			["<PageDown>"] = cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Select,
				count = 8,
			}),
			["<Up>"] = cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			["<Down>"] = cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = false }),
			["<C-y>"] = cmp.mapping.confirm({ select = false }),
			["<C-n>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<C-p>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if vim.snippet.active({ direction = 1 }) then
					vim.snippet.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if vim.snippet.active({ direction = -1 }) then
					vim.snippet.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		},

		snippet = {
			expand = vim.fn.has("nvim-0.10") == 1 and function(args)
				vim.snippet.expand(args.body)
			end or function(_)
				error("snippet engine is not configured.")
			end,
		},

		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = require("lspkind").cmp_format({
				mode = "symbol",
				menu = {
					nvim_lsp = "Lsp",
					path = "Path",
					snippets = "Snippets",
					buffer = "Buffer",
					spell = "Spell",
					rg = "Rg",
					git = "Git",
				},
			}),
			expandable_indicator = true,
		},

		matching = {
			disallow_fuzzy_matching = false,
			disallow_fullfuzzy_matching = false,
			disallow_partial_fuzzy_matching = true,
			disallow_partial_matching = false,
			disallow_prefix_unmatching = false,
			disallow_symbol_nonprefix_matching = true,
		},

		sorting = {
			priority_weight = 2,
			comparators = {
				compare.offset,
				compare.exact,
				-- compare.scopes,
				compare.score,
				compare.recently_used,
				compare.locality,
				compare.kind,
				-- compare.sort_text,
				compare.length,
				compare.order,
			},
		},

		sources = cmp.config.sources({
			-- { name = "codeium" },
			{ name = "snippets", max_item_count = 3 },
			{
				name = "nvim_lsp",
				max_item_count = 20,
			},
			{ name = "buffer", max_item_count = 8 },
		}),

		confirmation = {
			default_behavior = types.cmp.ConfirmBehavior.Insert,
			get_commit_characters = function(commit_characters)
				return commit_characters
			end,
		},

		event = {},

		experimental = {
			ghost_text = false,
		},

		view = {
			entries = {
				name = "custom",
				selection_order = "top_down",
				vertical_positioning = "below",
				follow_cursor = false,
			},
			docs = {
				auto_open = true,
			},
		},

		window = {
			completion = {
				border = { "", "", "", "", "", "", "", "" },
				winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
				scrollbar_winhighlight = "EndOfBuffer:PmenuSbar,NormalFloat:PmenuSbar",
				scrollbar_thumb_winhighlight = "EndOfBuffer:PmenuThumb,NormalFloat:PmenuThumb",
				winblend = vim.o.pumblend,
				scrolloff = 0,
				col_offset = 0,
				side_padding = 1,
				scrollbar = true,
			},
			documentation = {
				max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
				max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
				border = { "", "", "", " ", "", "", "", " " },
				winhighlight = "FloatBorder:NormalFloat",
				scrollbar_winhighlight = "EndOfBuffer:PmenuSbar,NormalFloat:PmenuSbar",
				scrollbar_thumb_winhighlight = "EndOfBuffer:PmenuThumb,NormalFloat:PmenuThumb",
				winblend = vim.o.pumblend,
				col_offset = 0,
			},
		},
	}

	local lazydev_ok, _ = pcall(require, "lazydev")
	if lazydev_ok then
		table.insert(opts.sources, {
			name = "lazydev",
			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		})
	end

  cmp.setup(opts)

	return true
end)
lz:events({ "InsertEnter", "CmdlineEnter" })
