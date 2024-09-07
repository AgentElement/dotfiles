{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "lsp-ai";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "SilasMarvin";
    repo = pname;
    rev = "5b422b13414065f10d369c58496f2d12d2ca2b30";
    hash = "sha256-mvxyLFJyG6sA+AId8u2YreE8qTzoYACUZKtibfq6QgA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hf-hub-0.3.2" = "sha256-1AcishEVkTzO3bU0/cVBI2hiCFoQrrPduQ1diMHuEwo=";
    };
  };

  # This package depends on openssl
  OPENSSL_NO_VENDOR = 1;
  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # `cargo test` requires API keys for each type of transformer backend
  # (openai, mistral, ollama, etc), which are not present during buildPhase,
  # and make testing impure. Therefore, testing must be disabled.
  doCheck = false;

  meta = {
    description = "LSP-AI is an open-source language server that serves as a backend for AI-powered functionality.";
    homepage = "https://github.com/SilasMarvin/lsp-ai";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
