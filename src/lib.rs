//! The Zed extension for cartan: the grammar and the queries stand in
//! `extension.toml` and `languages/cartan/`, and this crate is the one
//! thing an extension needs code for — where the language server is.
//! The server is `cartan lsp`, a verb of the shipped binary, so the
//! extension finds `cartan` on the PATH (where a pip install of
//! `counterplot` or `cartan-lang` puts it) and starts it; it downloads
//! nothing and builds nothing.

use zed_extension_api::{self as zed, LanguageServerId, Result};

struct Cartan;

impl zed::Extension for Cartan {
    fn new() -> Self {
        Cartan
    }

    fn language_server_command(
        &mut self,
        _id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let command = worktree.which("cartan").ok_or_else(|| {
            "`cartan` is not on the PATH — install it with `pip install counterplot` \
             (or `cartan-lang`, without the window), or `cargo install` it from the \
             repository"
                .to_string()
        })?;
        Ok(zed::Command { command, args: vec!["lsp".into()], env: Vec::new() })
    }
}

zed::register_extension!(Cartan);
