{
  programs.nixvim.plugins = {
    treesitter.settings = {
      enable = true;
      nixGrammars = true;
      indent = true;
    };
    treesitter-context.enable = true;
    rainbow-delimiters.enable = true;
  };
}
