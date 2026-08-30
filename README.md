# Cartan for Zed

Language support for cartan documents (`.cart`): tree-sitter
highlighting through
[tree-sitter-cartan](https://github.com/cartan-lang/tree-sitter-cartan),
and diagnostics, hover, completion, definition, symbols and semantic
coloring through `cartan lsp`, a verb of the shipped binary. The
extension finds `cartan` on the PATH — `pip install counterplot` (or
`cartan-lang`, without the window) puts it there — and starts it; it
downloads nothing and builds nothing.

The extension's version moves in lockstep with the language's
releases: version X.Y.Z starts `cartan` X.Y.Z.

Licensed under `MIT OR Apache-2.0` (`LICENSE-MIT`, `LICENSE-APACHE`).
