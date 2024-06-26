{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      bashls.enable = true;
      clangd.enable = true;
      elixirls.enable = true;
      fsautocomplete.enable = true;
      gopls.enable = true;
      kotlin-language-server.enable = true;
      nixd.enable = true;
      ruff-lsp.enable = true;
    };
    keymaps.lspBuf = {
      "gd" = "definition";
      "gD" = "references";
      "gt" = "type_definition";
      "gi" = "implementation";
      "K" = "hover";
    };
  };
  programs.nixvim.plugins.rust-tools.enable = true;
}
