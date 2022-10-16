# .emacs.d

My personal Emacs configuration. Mostly intended for use developing Rust.

## Prerequisites

You must install [rust-analyzer] from source prior to using this configuration:

```bash
$ git clone https://github.com/rust-lang/rust-analyzer
$ cd rust-analyzer/
$ cargo xtask install --server
```

You will also need to install [racket-langserver]:

```bash
$ raco pkg install racket-langserver
```

[rust-analyzer]: https://github.com/rust-lang/rust-analyzer
[racket-langserver]: https://github.com/jeapostrophe/racket-langserver

## Setup

- Clone this repository to `$HOME/.emacs.d/`.
- Start Emacs and let all packages download.
- Install the icon font with `M-x all-the-icons-install-fonts`
- Restart Emacs to allow all visual changes to be applied

## License

The contents of this repository are licensed under the [MIT License](LICENSE).
