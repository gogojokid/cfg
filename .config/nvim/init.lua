-- Format

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.formatoptions:append("w")

-- Visual

-- vim.opt.cursorline = true
vim.opt.foldmethod = "marker"

-- Search

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Interacte

vim.opt.swapfile = false 
vim.opt.scrolloff = 40
vim.opt.wildmode = "list:longest,full"
vim.opt.wildoptions = "fuzzy,tagfile"
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.exr,*.tif,*.gif,*.hrd,*.svg,*.fbx,*.gitf,*.glb,*.blender,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"

if vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
  vim.opt.clipboard:append("unnamedplus")
end

-- Color

local dif = false

if not vim.o.diff then
  dif = true
end

-- Key Map

vim.g.mapleader = "Space"
vim.g.maplocalleader = "\\"


-- Auto close{{{

local function autoclose(char, close_char)
    local close = close_char or char -- Use the same char if close_char is not provided
    vim.keymap.set("i", char, char .. close .. "<left>", { silent = true })
    vim.keymap.set("i", char .. ";", char .. close .. ";<left><left>", { silent = true })
    vim.keymap.set("i", char .. ",", char .. close .. ",<left><left>", { silent = true })
    vim.keymap.set("i", char .. "<tab>", char .. close, { silent = true })
    vim.keymap.set("i", char .. "<CR>", char .. "<CR>" .. close .. "<ESC>O", { silent = true })
    vim.keymap.set("i", char .. ";<CR>", char .. "<CR>" .. close .. ";<ESC>O", { silent = true })
    vim.keymap.set("i", char .. ",<CR>", char .. "<CR>" .. close .. ",<ESC>O", { silent = true })
end

autoclose("'", "'")
autoclose("`", "`")
autoclose("\"", "\"")
autoclose("(", ")")
autoclose("[", "]")
autoclose("{", "}")
-- }}}

-- Netrw{{{

vim.g.netrw_banner = 0
vim.g.netrw_altv = 1
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 14
vim.g.netrw_clipboard = 0
vim.g.netrw_fastbrowse = 2
vim.g.netrw_keepdir = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_localmkdir = "mkdir -p"
vim.g.netrw_localrmdir = "rm -r"

-- lexplore plus
local function clear_buf()
	for _, buf in pairs(vim.api.nvim_list_bufs()) do
		-- remove all empty "No Name" buffers that are unmodified
        if
            vim.api.nvim_buf_get_name(buf) == ""
            and not vim.api.nvim_buf_get_option(buf, "modified")
            and vim.api.nvim_buf_is_loaded(buf)
        then
            vim.api.nvim_buf_delete(buf, {})
		-- clean up Netrw's empty buffer artifacts and let that logic toggle it
		else
        	local e, v = pcall(function() return vim.api.nvim_buf_get_var(buf, "current_syntax") end)
        	if
            	(e and v == "netrwlist")
            	and not vim.api.nvim_buf_get_option(buf, "modified")
            	and vim.api.nvim_buf_is_loaded(buf)
        	then
            	vim.api.nvim_buf_delete(buf, {})
        	end
		end
	end
end

-- netrw global map
vim.keymap.set({"i", "n", "v"}, "<C-s>", "<cmd>Lexplore<CR>", { silent = true})
vim.keymap.set({"i", "n", "v"}, "<A-s>", "<cmd>Lexplore %:p:h<CR>", {silent = true})
vim.keymap.set({"i", "n", "v"}, "<C-A-s>", function() clear_buf() vim.cmd("Lexplore<CR>") end, { silent = true })

local function cur_new()
	if vim.bo.filetype == "netrw" then
		local cur_dir = vim.b.netrw_curdir
		vim.cmd("normal Ccd%")
		vim.cmd("w")
		vim.cmd("bw")
		if cur_dir then
			vim.cmd("Lexplore".. vim.fn.fnameescape(cur_dir))
		else
			vim.cmd("Lexplore")
		end
		vim.cmd("normal".. vim.api.nvim_replace_termcodes('<c-l>', true, true, true))
	end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
   		local buf_opts = { buffer = true, remap = true, silent = true }
   		vim.keymap.set("n", "h", "-", buf_opts)
   		vim.keymap.set("n", "l", "<CR>", buf_opts)
   		vim.keymap.set("n", ".", "gh", buf_opts)
   		vim.keymap.set("n", "<TAB>", "mf", buf_opts)
	   	vim.keymap.set("n", "<S-TAB>", "mF", buf_opts)
	   	vim.keymap.set("n", "n", cur_new, buf_opts)
   		vim.keymap.set("n", "fl", ":echo join(netrw#Expose(\"netrwmarkfilelist\"), \"\\n\")<CR>", buf_opts)
	   	vim.keymap.set("n", "ft", "mt:echo 'Target:' .. netrw#Expose(\"netrwmftgt\")<CR>", buf_opts)
	end
})
-- }}}

-- Bootstrap lazy.nvim{{{

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.runtimepath:prepend(lazypath)
-- }}}

-- Plugins

require("lazy").setup({
  -- colorscheme
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").setup({
		transparent = dif,
	  })
	  local style0 = { fg = "#d08770", bg = "NONE", bold = true }
      vim.cmd.colorscheme("nord")
	  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#d8dee9" })
	  vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
	  vim.api.nvim_set_hl(0, "WildMenu", style0)
	  vim.api.nvim_set_hl(0, "TabLineSel", style0)
	end
  },
})
