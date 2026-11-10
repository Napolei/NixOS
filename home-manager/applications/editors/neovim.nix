# Neovim colour scheme "theme", from the theme like nano: the palette of
# theme.colors. The terminal background shows through.
# https://neovim.io/doc/user/syntax.html#_13.-highlight-command

{ config, lib, vars, ... }:

let
  themeLib = import ../../theme-lib.nix { inherit lib vars; };
in
{
  xdg.configFile."nvim/init.lua".text = ''
    vim.o.termguicolors = true
    pcall(vim.cmd.colorscheme, "theme")
  '';

  xdg.configFile."nvim/colors/theme.lua".text = ''
    -- Palette from theme.colors
    local p = (function()
    ${themeLib.nvim themeLib.palette}
    end)()

    vim.cmd("highlight clear")
    vim.o.background = "dark"
    vim.g.colors_name = "theme"

    local function hl(group, spec) vim.api.nvim_set_hl(0, group, spec) end

    -- Editor
    hl("Normal",       { fg = p.foreground })
    hl("NormalNC",     { link = "Normal" })
    hl("NormalFloat",  { fg = p.foreground, bg = p.color0 })
    hl("FloatBorder",  { fg = p.surface, bg = p.color0 })
    hl("FloatTitle",   { fg = p.accent, bg = p.color0, bold = true })
    hl("Cursor",       { fg = p.background, bg = p.foreground })
    hl("CursorLine",   { bg = p.color0 })
    hl("CursorColumn", { link = "CursorLine" })
    hl("ColorColumn",  { bg = p.color0 })
    hl("LineNr",       { fg = p.surface })
    hl("CursorLineNr", { fg = p.accent, bold = true })
    hl("SignColumn",   {})
    hl("FoldColumn",   { fg = p.surface })
    hl("Folded",       { fg = p.dimmed, bg = p.color0 })
    hl("NonText",      { fg = p.surface })
    hl("Whitespace",   { fg = p.surface })
    hl("EndOfBuffer",  { fg = p.surface })
    hl("WinSeparator", { fg = p.surface })
    hl("VertSplit",    { link = "WinSeparator" })
    hl("Visual",       { fg = p.background, bg = p.accent })
    hl("Search",       { fg = p.background, bg = p.warning })
    hl("CurSearch",    { fg = p.background, bg = p.accent, bold = true })
    hl("IncSearch",    { link = "CurSearch" })
    hl("Substitute",   { link = "Search" })
    hl("MatchParen",   { fg = p.accent, bold = true, underline = true })
    hl("StatusLine",   { fg = p.foreground, bg = p.color0 })
    hl("StatusLineNC", { fg = p.dimmed, bg = p.color0 })
    hl("TabLine",      { fg = p.dimmed, bg = p.color0 })
    hl("TabLineSel",   { fg = p.background, bg = p.accent, bold = true })
    hl("TabLineFill",  { bg = p.color0 })
    hl("WinBar",       { fg = p.foreground, bold = true })
    hl("WinBarNC",     { fg = p.dimmed })
    hl("Pmenu",        { fg = p.foreground, bg = p.color0 })
    hl("PmenuSel",     { fg = p.background, bg = p.accent })
    hl("PmenuSbar",    { bg = p.color0 })
    hl("PmenuThumb",   { bg = p.surface })
    hl("WildMenu",     { link = "PmenuSel" })
    hl("Title",        { fg = p.accent, bold = true })
    hl("Directory",    { fg = p.accent })
    hl("Question",     { fg = p.accent })
    hl("MoreMsg",      { fg = p.accent })
    hl("ModeMsg",      { fg = p.accent, bold = true })
    hl("ErrorMsg",     { fg = p.error, bold = true })
    hl("WarningMsg",   { fg = p.warning })
    hl("SpecialKey",   { fg = p.surface })
    hl("Conceal",      { fg = p.dimmed })
    hl("QuickFixLine", { bg = p.color0, bold = true })

    -- Syntax (tree-sitter groups link to these by default)
    hl("Comment",    { fg = p.dimmed, italic = true })
    hl("Constant",   { fg = p.color3 })
    hl("String",     { fg = p.secondary })
    hl("Character",  { link = "String" })
    hl("Number",     { fg = p.color3 })
    hl("Boolean",    { fg = p.color3 })
    hl("Identifier", { fg = p.foreground })
    hl("Function",   { fg = p.accent })
    hl("Statement",  { fg = p.color5 })
    hl("Keyword",    { fg = p.color5 })
    hl("Operator",   { fg = p.dimmed })
    hl("PreProc",    { fg = p.color6 })
    hl("Type",       { fg = p.color6 })
    hl("Special",    { fg = p.color6 })
    hl("Delimiter",  { fg = p.dimmed })
    hl("Underlined", { underline = true })
    hl("Error",      { fg = p.error })
    hl("Todo",       { fg = p.background, bg = p.warning, bold = true })

    -- Diagnostics and diffs
    hl("DiagnosticError", { fg = p.error })
    hl("DiagnosticWarn",  { fg = p.warning })
    hl("DiagnosticInfo",  { fg = p.accent })
    hl("DiagnosticHint",  { fg = p.dimmed })
    hl("DiagnosticOk",    { fg = p.secondary })
    hl("DiagnosticUnderlineError", { undercurl = true, sp = p.error })
    hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = p.warning })
    hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = p.accent })
    hl("DiagnosticUnderlineHint",  { undercurl = true, sp = p.dimmed })
    hl("DiffAdd",    { fg = p.secondary })
    hl("DiffDelete", { fg = p.error })
    hl("DiffChange", { fg = p.warning })
    hl("DiffText",   { fg = p.background, bg = p.warning })
    hl("Added",      { link = "DiffAdd" })
    hl("Removed",    { link = "DiffDelete" })
    hl("Changed",    { link = "DiffChange" })
    hl("SpellBad",   { undercurl = true, sp = p.error })
    hl("SpellCap",   { undercurl = true, sp = p.warning })
  '';
}
