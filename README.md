# .emacs.d

My personal Emacs configuration. Mostly intended for use developing Rust.

## Prerequisites

### Fonts

This configuration assumes that the [Source Code Pro] font is installed.

[Source Code Pro]: https://adobe-fonts.github.io/source-code-pro/

### Rust

Ensure that [Rust] is installed on your system; this can be accomplished with
[rustup], e.g. on Unix-like systems:

```shell
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Additionally, [rust-analyzer] and [cargo-expand] are required:

```shell
$ rustup component add rust-analyzer
$ cargo install cargo-expand
```

[Rust]: https://rust-lang.org/
[rustup]: https://rustup.rs/
[rust-analyzer]: https://github.com/rust-lang/rust-analyzer
[cargo-expand]: https://github.com/dtolnay/cargo-expand

## Setup

- Clone this repository to `$HOME/.emacs.d/`.
- Start Emacs and let all packages download.
- Install the icon fonts with:
  - `M-x all-the-icons-install-fonts`
  - `M-x nerd-icons-install-fonts`
- Restart Emacs to allow all visual changes to be applied

## License

The contents of this repository are licensed under the [BSD 3-Clause License](LICENSE).
