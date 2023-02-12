# .emacs.d

My personal Emacs configuration. Mostly intended for use developing Rust.

## Prerequisites

### Rust

Make sure that you have installed [rust-analyzer] first:

```bash
$ rustup component add rust-analyzer
```

Additionally, it's recommended you install [cargo-expand]:

```bash
$ cargo install cargo-expand
```

[cargo-expand]: https://github.com/dtolnay/cargo-expand
[rust-analyzer]: https://github.com/rust-lang/rust-analyzer

### Racket

You will need to install [racket-langserver]:

```bash
$ raco pkg install racket-langserver
```

[racket-langserver]: https://github.com/jeapostrophe/racket-langserver

## Setup

- Clone this repository to `$HOME/.emacs.d/`.
- Start Emacs and let all packages download.
- Install the icon font with `M-x all-the-icons-install-fonts`
- Restart Emacs to allow all visual changes to be applied

## License

The contents of this repository are licensed under the [MIT License](LICENSE).
