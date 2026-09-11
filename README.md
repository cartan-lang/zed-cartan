# Cartan for Zed

Language support for cartan documents (`.cart`): tree-sitter
highlighting through
[tree-sitter-cartan](https://github.com/cartan-lang/tree-sitter-cartan),
and diagnostics, hover, completion, definition, symbols and semantic
coloring through `cartan lsp`, a verb of the shipped binary. The
extension finds `cartan` on the PATH — `pip install counterplot` (or
`cartan-lang`, without the window) puts it there — and starts it; it
downloads nothing and builds nothing.

## Reading the analysis

Hover over a binding and the first lines state what the analysis
assigned it: the kind in the annotation grammar, the floor an update
states where one does, and the targets that admit its cone, grouped by
the widths they admit. The full reading is the command line's —
`cartan check FILE SYMBOL` — and the editor stays short so that it
does not distract.

The whole report is offered at the cursor as three code actions,
"Explain realization" at the stated floor, at `f32` and at `f64`. Open
them with `editor: toggle code actions` (`cmd-.` on the default
keymap) and pick one.

**Where the report appears.** Zed runs a code action's command but
shows nothing a language server returns from it, and its
`window/showDocument` handler opens external URLs alone, so the server
writes the report to its log instead: run `dev: open language server
logs` from the command palette, pick `cartan`, and the report stands
at the end of the server messages. In an editor that shows what a
command returns — VS Code, through the client in `editors/vscode` —
the same command opens the report in a scratch document.

The extension's version moves in lockstep with the language's
releases: version X.Y.Z starts `cartan` X.Y.Z.

Licensed under `MIT OR Apache-2.0` (`LICENSE-MIT`, `LICENSE-APACHE`).
