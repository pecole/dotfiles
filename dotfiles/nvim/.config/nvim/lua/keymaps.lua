local opts = { noremap = true, silent = true }
--local term_opts = { silent = true }

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Normal --
-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- New tab
--keymap('n', 'te', ':tabedit', opts)
-- 新しいタブを一番右に作る
--keymap('n', 'gn', ':tabnew<Return>', opts)
-- move tab
--keymap('n', 'gh', 'gT', opts)
--keymap('n', 'gl', 'gt', opts)

-- Split window
keymap('n', 'ss', ':split<Return><C-w>w', opts)
keymap('n', 'sv', ':vsplit<Return><C-w>w', opts)

-- ;でコマンド入力( ;と:を入れ替)
--keymap('n', ';', ':', opts)

-- 行末までのヤンクにする
keymap('n', 'Y', 'y$', opts)

-- ESC*2 でハイライトやめる
keymap('n', '<Esc><Esc>', ':<C-u>set nohlsearch<Return>', opts)

-- Insert --
-- コンマの後に自動的にスペースを挿入
--keymap('i', ',', ',<Space>', opts)

-- Emacs風
keymap('i', '<C-f>', '<Right>', opts)
keymap('i', '<C-b>', '<Left>', opts)

-- Visual --
-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- ビジュアルモード時vで行末まで選択
keymap('v', 'v', '$h', opts)

-- Terminal --
-- <Esc>でnormalモードに移行する
keymap('t', '<Esc>', '<C-\\><C-n>', opts)
