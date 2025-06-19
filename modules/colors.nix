{lib, ...}:
with lib; {
  options.colorScheme = mkOption {
    type = types.attrs;
    default = {
      # Base colors
      base00 = "#f2e9e1"; # Default Background
      base01 = "#faf4ed"; # Lighter Background (status bars, etc)
      base02 = "#dfdad9"; # Selection Background
      base03 = "#9893a5"; # Comments, Invisibles, Line Highlighting
      base04 = "#cecacd"; # Dark Foreground (status bars)
      base05 = "#575279"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "#575279"; # Light Foreground (not often used)
      base07 = "#575279"; # Light Background (not often used)

      # Colors
      base08 = "#b4637a"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "#ea9d34"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "#ea9d34"; # Classes, Markup Bold, Search Text Background
      base0B = "#286983"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "#d7827e"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "#56949f"; # Functions, Methods, Attribute IDs, Headings
      base0E = "#907aa9"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "#907aa9"; # Deprecated, Opening/Closing Embedded Language Tags

      # Terminal colors
      color0 = "#f2e9e1";
      color1 = "#b4637a";
      color2 = "#286983";
      color3 = "#ea9d34";
      color4 = "#56949f";
      color8 = "#9893a5";
      color9 = "#b4637a";
      color10 = "#286983";
      color11 = "#ea9d34";
      color12 = "#56949f";
      color13 = "#907aa9";
      color14 = "#d7827e";
      color15 = "#575279";

      # UI colors
      foreground = "#575279";
      background = "#faf4ed";
      cursor = "#cecacd";
      selection_foreground = "#575279";
      selection_background = "#dfdad9";
      url_color = "#907aa9";
    };
    description = "Color scheme for terminal and applications";
  };
}
