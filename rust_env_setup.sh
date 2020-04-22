#!/usr/bin/env sh

# This script should work on both docker and a local development environment

# shellcheck disable=SC1090

SUCCESS=0
FAILURE=1
RUSTUP_INSTALL_FAIL=2
TOOLCHAIN_TO_NIGHTLY_FAIL=3
ADD_TARGET_FOR_WASM_FAIL=4
ADD_COMPONENT_RUST_SRC_FAIL=5
ADD_COMPONENT_CLIPPY_FAIL=6
ADD_COMPONENT_RUST_FMT_FAIL=7
CARGO_PATH_CONFIGURE_FAIL=8
WASMPACK_INSTALL_FAIL=9
# To check support of tools by toolchain see here: https://rust-lang.github.io/rustup-components-history/index.html
RUST_TOOLCHAIN='nightly-2020-01-31'

main() {
  if ! is_rustup_installed; then
    install_rustup
  fi

  configure_toolchain
  configure_path

  if ! is_wasmpack_installed; then
    install_wasmpack
  fi
}

is_rustup_installed() {
  if [ -x "$(command -v rustup)" ]; then
    info_msg "rustup is already installed"
    return $SUCCESS
  fi

  info_msg "rustup is not installed"
  return $FAILURE
}

# Install rustup the defacto Rust toolchain installer
install_rustup() {
  info_msg "installing rustup..."

  # https://github.com/rust-lang/rustup.rs#other-installation-methods
  info_msg "installing rustup manually via curl"

  if ! curl -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y --profile minimal; then
    error_msg "rustup install failed"
    exit $RUSTUP_INSTALL_FAIL
  fi

  success_msg "rustup installed"
  return $SUCCESS
}

configure_toolchain() {
  info_msg "configuring rust toolchain with rustup.."

  info_msg "setting default toolchain to nightly "
  # TODO: When possible look into excluding docs: https://github.com/rust-lang/rustup.rs/issues/998
  if ! rustup default $RUST_TOOLCHAIN; then
    error_msg "failed to set toochain to nightly"
    exit $TOOLCHAIN_TO_NIGHTLY_FAIL
  fi

  info_msg "adding rust target for web assembly"
  if ! rustup target add wasm32-unknown-unknown; then
    error_msg "failed to add wasm target"
    exit $ADD_TARGET_FOR_WASM_FAIL
  fi

  # TODO: Look into parameterizing this step, since it is only needed for dev env. Rather small impact though I think?
  # https://doc.rust-lang.org/edition-guide/rust-2018/rustup-for-managing-rust-versions.html#rust-src-for-a-copy-of-rusts-source-code
  info_msg "getting rust-src for development tooling"
  if ! rustup component add rust-src; then
    error_msg "failed to add rust component src"
    exit $ADD_COMPONENT_RUST_SRC_FAIL
  fi

  info_msg "getting clippy for development tooling"
  if ! rustup component add clippy; then
    error_msg "failed to add rust component clippy"
    exit $ADD_COMPONENT_CLIPPY_FAIL
  fi

  info_msg "getting rustfmt for development tooling"
  if ! rustup component add rustfmt; then
    error_msg "failed to add rust component rustfmt"
    exit $ADD_COMPONENT_RUST_FMT_FAIL
  fi

  success_msg "rust toolchain configured"
  return $SUCCESS
}

configure_path() {
  info_msg "configuring path for cargo.."

  if echo "$PATH" | grep '.cargo/bin' >/dev/null; then
    info_msg "cargo path seems to already be configured"
    success_msg "cargo path configured"
    return $SUCCESS
  fi

  # NOTE: .profile is read by every shell contrary to .bashrc and others which are shell specific
  info_msg "setting .cargo/bin path into .profile"
  echo "export PATH=$PATH:$HOME/.cargo/bin" >>"$HOME"/.profile

  info_msg "sourcing new .profile for this session"
  . "$HOME"/.profile
  if ! echo "$PATH" | grep '.cargo/bin' >/dev/null; then
    error_msg "cargo path configuration failed"
    return $CARGO_PATH_CONFIGURE_FAIL
  fi

  success_msg "cargo path configured"
  return $SUCCESS
}

is_wasmpack_installed() {
  if [ -x "$(command -v wasm-pack)" ]; then
    info_msg "wasmpack is already installed"
    return $SUCCESS
  fi

  info_msg "wasmpack is not installed"
  return $FAILURE
}

install_wasmpack() {
  info_msg "installing wasm-pack.."

  if ! curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh; then
    error_msg "wasm-pack install failed"
    exit $WASMPACK_INSTALL_FAIL
  fi

  success_msg "wasm-pack installed"
  return $SUCCESS
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
CLEAR='\033[0m'

info_msg() {
  printf "${WHITE}INFO:${CLEAR} %s\n" "$1"
}

error_msg() {
  printf "${RED}ERROR:${CLEAR} %s\n" "$1"
}

success_msg() {
  printf "${GREEN}SUCCESS:${CLEAR} %s\n" "$1"
}

warning_msg() {
  printf "${YELLOW}WARNING:${CLEAR} %s\n" "$1"
}

main
