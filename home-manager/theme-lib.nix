# ==============================================================================
# Theme colour helpers (not a module)
# ==============================================================================
#
# Writes the colours of each terminal program from theme.nix (colors, roles,
# alerts), imported in vars.nix as `theme`.
#
# Each function takes a colour set `c`: hex colours without "#" (background,
# foreground, color0-15, rgbs = "r,g,b" of each) and lb / rb for literal
# braces, normally `palette` below.
#
# Usage: themeLib = import ./theme-lib.nix { inherit lib vars; };

{ lib, vars }:

let
  theme = vars.theme;
in
rec {
  # Colour of a role, e.g. role c "accent"
  role = c: name: c.${theme.roles.${name}};

  # "r,g,b" from a hex colour
  rgb = hex:
    lib.concatMapStringsSep "," (i: toString (lib.fromHexString (builtins.substring i 2 hex))) [ 0 2 4 ];

  # A hex colour mixed with white, `percent` 0-100
  lightenHex = hex: percent:
    lib.concatMapStrings (i:
      let value = lib.fromHexString (builtins.substring i 2 hex);
      in lib.fixedWidthString 2 "0" (lib.toLower (lib.toHexString (value + (255 - value) * percent / 100)))
    ) [ 0 2 4 ];

  # Nearest of the 256 terminal colours (6x6x6 cube), for terminals without
  # true colour
  cube = hex:
    let
      levels = [ 0 95 135 175 215 255 ];
      distance = a: b: if a > b then a - b else b - a;
      nearest = value: lib.foldl' (best: i:
        if distance (builtins.elemAt levels i) value < distance (builtins.elemAt levels best) value then i else best
      ) 0 (lib.range 0 5);
      channel = i: nearest (lib.fromHexString (builtins.substring i 2 hex));
    in 16 + 36 * channel 0 + 6 * channel 2 + channel 4;

  # theme.colors as a colour set
  palette = theme.colors // {
    # Every colour as "r,g,b"
    rgbs = lib.mapAttrs (name: rgb) theme.colors;
    # A colour lightened by `percent`, e.g. lighten "background" 25
    lighten = name: percent: lightenHex theme.colors.${name} percent;
    lb = "{";
    rb = "}";
  };

  # "r,g,b" of a role
  roleRgb = c: name: c.rgbs.${theme.roles.${name}};

  # Error / warning colours of the true-colour programs (theme.nix: alerts)
  error = theme.alerts.error;
  warning = theme.alerts.warning;

  # The 16 palette colours with their terminal palette number
  paletteColors = c: map (n: { index = n; hex = c."color${toString n}"; }) (lib.range 0 15);

  # kitty colours, included by ~/.config/kitty/kitty.conf
  kitty = c: ''
    foreground         #${c.foreground}
    background         #${c.background}
    background_opacity 1.0
    cursor             #${c.foreground}

    active_tab_foreground     #${c.background}
    active_tab_background     #${c.foreground}
    inactive_tab_foreground   #${c.foreground}
    inactive_tab_background   #${c.background}

    active_border_color   #${c.foreground}
    inactive_border_color #${c.background}
    bell_border_color     #${c.color1}

    ${lib.concatMapStrings (p: "color${toString p.index} #${p.hex}\n") (paletteColors c)}'';

  # Escape sequences that set the palette, text, background and cursor colours
  # of the terminal (OSC 4, 10-19, 708), printed when bash starts
  sequences = c:
    let
      osc = code: value: "\\033]${code};${value}\\033\\\\";
      fg = "#${c.foreground}";
      bg = "#${c.background}";
    in lib.concatStrings (
      map (p: osc "4;${toString p.index}" "#${p.hex}") (paletteColors c)
      ++ [
        (osc "10" fg) (osc "11" bg) (osc "12" fg) (osc "13" fg)
        (osc "17" fg) (osc "19" bg)
        (osc "4;232" bg) (osc "4;256" fg) (osc "4;257" bg)
        (osc "708" bg)
      ]);

  # btop theme (~/.config/btop/btop.conf: color_theme points to it)
  btop = c:
    let
      accent = "#${role c "accent"}";
      secondary = "#${role c "secondary"}";
      surface = "#${role c "surface"}";
      gradient = name: start: mid: end: ''
        theme[${name}_start]="${start}"
        theme[${name}_mid]="${mid}"
        theme[${name}_end]="${end}"
      '';
      load = name: gradient name accent "#${warning}" "#${error}";
    in ''
      theme[main_bg]="#${c.background}"
      theme[main_fg]="#${c.foreground}"
      theme[title]="#${c.foreground}"
      theme[hi_fg]="${accent}"
      theme[selected_bg]="${surface}"
      theme[selected_fg]="#${c.foreground}"
      theme[inactive_fg]="${surface}"
      theme[graph_text]="#${role c "dimmed"}"
      theme[meter_bg]="${surface}"
      theme[proc_misc]="${accent}"
      theme[cpu_box]="${surface}"
      theme[mem_box]="${surface}"
      theme[net_box]="${surface}"
      theme[proc_box]="${surface}"
      theme[div_line]="${surface}"
      ${load "temp"}${load "cpu"}${load "used"}${load "process"}${gradient "free" surface secondary secondary}${gradient "cached" surface accent accent}${gradient "available" surface secondary secondary}${gradient "download" surface accent accent}${gradient "upload" surface secondary secondary}'';

  # Light highlight and raised background (theme.nix: highlight, raisedLighten),
  # hex without "#"
  highlightName = theme.roles.${theme.highlight or "color15"} or (theme.highlight or "color15");
  highlight = c: c.${highlightName};
  raised = c: c.lighten "background" (theme.raisedLighten or 25);

  # tmux status bar, panes and selection, sourced by ~/.config/tmux/tmux.conf
  tmux = c:
    let
      dark = "#${c.background}";
      text = "#${c.foreground}";
      light = "#${highlight c}";
      bar = "#${raised c}";
    in ''
      set -g status-style "fg=${text},bg=${bar}"
      set -g status-left-style "fg=${dark},bg=${light},bold"
      set -g status-right-style "fg=${text},bg=${bar}"
      set -g window-status-style "fg=#${role c "dimmed"},bg=${bar}"
      set -g window-status-current-style "fg=${dark},bg=${light},bold"
      set -g window-status-activity-style "fg=${bar},bg=#${warning}"
      set -g window-status-bell-style "fg=${bar},bg=#${error}"
      set -g pane-border-style "fg=#${role c "surface"}"
      set -g pane-active-border-style "fg=${light}"
      set -g message-style "fg=${dark},bg=${light}"
      set -g message-command-style "fg=${text},bg=${bar}"
      set -g mode-style "fg=${dark},bg=${light}"
      set -g display-panes-colour "${bar}"
      set -g display-panes-active-colour "${light}"
      set -g clock-mode-colour "${light}"
    '';

  # superfile theme, ~/.config/superfile/theme/theme.toml (all keys needed)
  superfile = c:
    let
      dark = "#${c.background}";
      text = "#${c.foreground}";
      light = "#${highlight c}";
      bar = "#${raised c}";
      accent = "#${role c "accent"}";
      surface = "#${role c "surface"}";
    in ''
      code_syntax_highlight = "catppuccin-mocha"
      full_screen_fg = "${text}"
      full_screen_bg = "${dark}"
      gradient_color = ["${accent}", "#${role c "secondary"}"]
      directory_icon_color = "${accent}"
      file_panel_fg = "${text}"
      file_panel_bg = "${dark}"
      file_panel_border = "${surface}"
      file_panel_border_active = "${light}"
      file_panel_top_directory_icon = "${accent}"
      file_panel_top_path = "${text}"
      file_panel_item_selected_fg = "${dark}"
      file_panel_item_selected_bg = "${light}"
      footer_fg = "${text}"
      footer_bg = "${dark}"
      footer_border = "${surface}"
      footer_border_active = "${light}"
      sidebar_fg = "${text}"
      sidebar_bg = "${dark}"
      sidebar_title = "${accent}"
      sidebar_border = "${dark}"
      sidebar_border_active = "${light}"
      sidebar_item_selected_fg = "${dark}"
      sidebar_item_selected_bg = "${light}"
      sidebar_divider = "${surface}"
      modal_fg = "${text}"
      modal_bg = "${bar}"
      modal_border_active = "${light}"
      modal_cancel_fg = "${dark}"
      modal_cancel_bg = "#${error}"
      modal_confirm_fg = "${dark}"
      modal_confirm_bg = "${light}"
      help_menu_hotkey = "${light}"
      help_menu_title = "${accent}"
      cursor = "${light}"
      correct = "#${role c "secondary"}"
      error = "#${error}"
      hint = "${accent}"
      cancel = "#${error}"
    '';

  # ripgrep options (RIPGREP_CONFIG_PATH): matches dark on the light highlight,
  # paths in the accent colour, line numbers dimmed. Colours as "r,g,b".
  ripgrep = c: ''
    --colors=match:none
    --colors=match:fg:${c.rgbs.background}
    --colors=match:bg:${c.rgbs.${highlightName}}
    --colors=match:style:bold
    --colors=path:none
    --colors=path:fg:${roleRgb c "accent"}
    --colors=path:style:bold
    --colors=line:none
    --colors=line:fg:${roleRgb c "dimmed"}
    --colors=column:none
    --colors=column:fg:${roleRgb c "dimmed"}
  '';

  # micro colour scheme "theme", ~/.config/micro/colorschemes/theme.micro.
  # Without a background the terminal's shows through.
  micro = c:
    let
      dark = "#${c.background}";
      text = "#${c.foreground}";
      light = "#${highlight c}";
      bar = "#${raised c}";
      link = group: value: "color-link ${group} \"${value}\"\n";
    in lib.concatStrings [
      (link "default" text)
      (link "comment" "#${role c "dimmed"}")
      (link "identifier" text)
      (link "constant" "#${c.color3}")
      (link "constant.string" "#${role c "secondary"}")
      (link "constant.number" "#${c.color3}")
      (link "statement" "#${c.color5}")
      (link "symbol" "#${role c "dimmed"}")
      (link "preproc" "#${c.color6}")
      (link "type" "#${c.color6}")
      (link "special" "#${c.color6}")
      (link "underlined" "#${role c "accent"}")
      (link "error" "bold #${error}")
      (link "todo" "bold ${dark},#${warning}")
      (link "selection" "${dark},${light}")
      (link "cursor-line" bar)
      (link "color-column" bar)
      (link "line-number" "#${role c "surface"}")
      (link "current-line-number" "bold ${light}")
      (link "gutter-error" "#${error}")
      (link "gutter-warning" "#${warning}")
      (link "diff-added" "#${role c "secondary"}")
      (link "diff-modified" "#${warning}")
      (link "diff-deleted" "#${error}")
      (link "statusline" "${text},${bar}")
      (link "statusline.inactive" "#${role c "dimmed"},${bar}")
      (link "tabbar" "${text},${bar}")
      (link "tabbar.active" "bold ${dark},${light}")
      (link "indent-char" "#${role c "surface"}")
      (link "divider" bar)
      (link "message" text)
      (link "error-message" "bold #${error}")
      (link "hlsearch" "${dark},#${warning}")
      (link "match-brace" "bold ${dark},${light}")
      (link "scrollbar" light)
    ];

  # yazi theme, ~/.config/yazi/theme.toml (merged over yazi's own)
  yazi = c:
    let
      dark = "#${c.background}";
      text = "#${c.foreground}";
      light = "#${highlight c}";
      bar = "#${raised c}";
      accent = "#${role c "accent"}";
      surface = "#${role c "surface"}";
      style = attrs: "${c.lb} ${lib.concatStringsSep ", " (lib.mapAttrsToList (k: v:
        "${k} = ${if builtins.isBool v then lib.boolToString v else "\"${v}\""}") attrs)} ${c.rb}";
      border = style { fg = surface; };
      main = style { fg = dark; bg = light; bold = true; };
      alt = style { fg = text; bg = bar; };
    in ''
      [mgr]
      cwd = ${style { fg = accent; bold = true; }}
      border_style = ${border}
      find_keyword = ${style { fg = dark; bg = "#${warning}"; bold = true; }}
      find_position = ${style { fg = light; bold = true; }}

      [tabs]
      active = ${main}
      inactive = ${alt}

      [mode]
      normal_main = ${main}
      normal_alt = ${alt}
      select_main = ${style { fg = dark; bg = "#${warning}"; bold = true; }}
      select_alt = ${alt}
      unset_main = ${style { fg = dark; bg = "#${error}"; bold = true; }}
      unset_alt = ${alt}

      [indicator]
      current = ${style { fg = dark; bg = light; }}
      parent = ${style { fg = text; bg = bar; }}

      [status]
      overall = ${style { fg = text; bg = bar; }}
      progress_normal = ${style { fg = light; bg = bar; }}
      progress_error = ${style { fg = "#${error}"; bg = bar; }}

      [which]
      border = ${border}
      cand = ${style { fg = light; bold = true; }}
      desc = ${style { fg = text; }}

      [confirm]
      border = ${border}
      title = ${style { fg = accent; }}
      btn_yes = ${main}

      [spot]
      border = ${border}
      title = ${style { fg = accent; }}

      [pick]
      border = ${border}
      active = ${main}

      [input]
      border = ${border}
      selected = ${main}

      [cmp]
      border = ${border}
      active = ${main}

      [tasks]
      border = ${border}
      hovered = ${main}

      [help]
      border = ${border}
      chord = ${style { fg = light; bold = true; }}
      hovered = ${main}
    '';

  # oxker colours, the [colors] part of ~/.config/oxker/config.toml (missing
  # keys keep oxker's defaults)
  oxker = c:
    let
      dark = "#${c.background}";
      text = "#${c.foreground}";
      light = "#${highlight c}";
      bar = "#${raised c}";
      accent = "#${role c "accent"}";
      secondary = "#${role c "secondary"}";
      dimmed = "#${role c "dimmed"}";
    in ''
      [colors.headers_bar]
      background = "${bar}"
      loading_spinner = "${light}"
      text = "${text}"
      text_selected = "${light}"

      [colors.borders]
      selected = "${light}"
      unselected = "#${role c "surface"}"

      [colors.containers]
      icon = "${light}"
      background = "reset"
      text = "${text}"
      text_rx = "${accent}"
      text_tx = "${secondary}"

      [colors.container_state]
      dead = "#${error}"
      exited = "#${error}"
      paused = "#${warning}"
      removing = "#${error}"
      restarting = "#${warning}"
      running_healthy = "${secondary}"
      running_unhealthy = "#${warning}"
      unknown = "#${error}"

      [colors.filter]
      background = "reset"
      text = "${text}"
      selected_filter_background = "${light}"
      selected_filter_text = "${dark}"
      highlight = "${light}"

      [colors.log_search]
      background = "reset"
      text = "${text}"
      button_text = "${dark}"
      highlight = "${light}"

      [colors.chart_cpu]
      border = "#${role c "surface"}"
      title = "${light}"
      max = "#${warning}"
      points = "${accent}"
      y_axis = "${dimmed}"

      [colors.chart_memory]
      border = "#${role c "surface"}"
      title = "${light}"
      max = "#${warning}"
      points = "${secondary}"
      y_axis = "${dimmed}"

      [colors.chart_bandwidth]
      border = "#${role c "surface"}"
      max_rx = "${accent}"
      max_tx = "${secondary}"
      points_rx = "${accent}"
      points_tx = "${secondary}"
      title_rx = "${accent}"
      title_tx = "${secondary}"
      y_axis = "${dimmed}"

      [colors.chart_ports]
      border = "#${role c "surface"}"
      title = "${light}"
      headings = "${accent}"
      text = "${text}"

      [colors.popup_help]
      background = "${bar}"
      text = "${text}"
      text_highlight = "${light}"
    '';

  # Prompt colours (theme.nix: prompt), hex without "#", for powerline and
  # oh-my-posh (applications/terminal/powerline.nix, oh-my-posh.nix)
  promptColors = c:
    let
      prompt = theme.prompt or { };
      user = prompt.user or "color15";
    in {
      text = c.foreground;
      dark = c.background;
      # A role or a palette colour, e.g. "dimmed" or "color15"
      user = c.${theme.roles.${user} or user};
      path = c.lighten "background" (prompt.pathLighten or 25);
      accent = role c "accent";
      dimmed = role c "dimmed";
      inherit warning error;
    };

  # Powerline prompt colours, ~/.config/powerline/colors.json (true colour,
  # see applications/terminal/powerline.nix). Each: [ 256-colour fallback, hex ].
  powerline = c: ''
      ${c.lb}"colors": ${c.lb}
      ${lib.concatStringsSep ",\n" (lib.mapAttrsToList (name: hex:
        "  \"theme_${name}\": [${toString (cube hex)}, \"${hex}\"]") (promptColors c))}
      ${c.rb}${c.rb}
    '';

  # Neovim palette, read by the "theme" colour scheme (~/.config/nvim/colors)
  nvim = c: ''
    return ${c.lb}
    ${lib.concatStrings (lib.mapAttrsToList (name: value: "  ${name} = \"#${value}\",\n") ({
      background = c.background;
      foreground = c.foreground;
      accent = role c "accent";
      secondary = role c "secondary";
      surface = role c "surface";
      dimmed = role c "dimmed";
      inherit error warning;
    } // lib.genAttrs (map (n: "color${toString n}") (lib.range 0 15)) (name: c.${name})))}${c.rb}
  '';
}
