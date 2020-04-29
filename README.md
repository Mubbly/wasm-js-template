<div align="center">

  <h1><code>wasm-js-template</code></h1>

  <strong>An opinionated and feature-packed project template for frontend projects utilizing JavaScript and WebAssembly.</strong>

  <p>
    <img src="https://github.com/Mubbly/wasm-js-template/workflows/template_ci/badge.svg" alt="Build Status" /></a>
  </p>
</div>

## 📚 About

This template is designed to set up a Javascript / Webassembly hybrid project with all the bells and whistles:
* Compilation to Webassembly from Rust
* Typescript / React set up for Javascript
* Npm / Cargo for package management needs of Javascript / Rust
* Linting Javascript / Rust code via ESLint / Clippy (Includes Typescript and React linting)
* Formatting Javascript / Rust code via prettier / rustfmt (Includes Typescript and React formatting)
* Webpack with the wasm-pack plugin for
  * Bundling Javascript and Webassembly
  * Code reloading on both Javascript and Rust code changes
* Continuous Integration through Github Workflows
* A simple to use project CLI via Make
* Docker for containerization
* Development environment through VSCode, rust-analyzer and the Remote Container extension

:page_with_curl: NOTE: See the "Customizing your project" section about not using some of these tools.

## 🚴 Usage

:page_with_curl: NOTE: While this template doesn't support Windows specifically, it mostly just depends on some simple UNIX commands. If you can get WSL / MinGW or a similar setup working then this setup can work on Windows too! You'll need to install Docker, Make, curl and VSCode yourself.

### :rocket: Single command setup

#### :penguin: Linux (with apt and snap)

```bash
# Install docker if it isn't already installed
curl -fsSL https://get.docker.com -o get-docker.sh \
    && sudo sh get-docker.sh \
    && rm get-docker.sh
    #
    # Install some utils and VSCode
    && sudo apt-get install make curl \
    && sudo snap install --classic code \
    #
    # Install rustup and cargo-generate
    && curl -sSf https://sh.rustup.rs | sh \
    && cargo install cargo-generate \
    #
    # Create a new project
    && cargo generate –git https://github.com/Mubbly/wasm-js-template --name new_project_name \
    #
    # Open the project and setup VSCode
    && cd new_project_name \
    && make dbuild-image \
    && code --install-extension ms-vscode-remote.remote-containers \
    && code .
```

#### :apple: MacOS (with brew)

```bash
# Install docker if it isn't already installed (https://docs.docker.com/docker-for-mac/install/)
if [ ! "$(command -v docker)" ]; then
  sudo curl https://download.docker.com/mac/stable/Docker.dmg >> Docker.dmg \
    && hdiutil attach Docker.dmg \
    && cp -r /Volumes/Docker/Docker.app ~/Applications/Docker.app \
    && rm Docker.dmg \
    && open -a Docker;
fi \
    #
    # Install some utils and VSCode
    && brew install make curl \
    && brew cask install visual-studio-code \
    #
    # Install rustup and cargo-generate
    && curl -sSf https://sh.rustup.rs | sh \
    && cargo install cargo-generate \
    #
    # Create a new project
    && cargo generate –git https://github.com/Mubbly/wasm-js-template --name new_project_name \
    #
    # Open the project and setup VSCode
    && cd new_project_name \
    && make dbuild-image \
    && code --install-extension ms-vscode-remote.remote-containers \
    && code .
```

#### :checkered_flag: End result

Both processes will end with VSCode asking to open the current project in a container – press yes.

When the process completes run `make help` in the VSCode integrated terminal to see how to get started!
```bash
$ make help
install                        Install project dependancies (rust will install dependancies on build)
format                         Format rust and javascript source code
format-check                   Check formatting of rust and javascript source code
lint                           Lint rust and javascript source code
build                          Build rust and javascript and have webpack bundle everything
test                           Run rust and javascript tests in firefox and chrome
start                          Start webpack dev server for running the application with hot reloading on rust or javascript code changes
clean                          Clean up all the installed dependancies and build artifacts
dshell                         Open a shell session inside the projects docker container
dclean                         Remove projects docker container and image
dbuild-image                   Build projects docker image
dcreate-container              Create projects docker container
dstart-container               Start projects docker container
dsetup                         Setup project inside docker from scratch
indock                         Run a make command inside docker, example usage: make indock cmd=build
help                           Show this help message
$ make install && make start # Start a reloading server on localhost:8080
```

:page_with_curl: NOTE: To enable GitHub Workflows for CI, enable it in .github/workflows/ci.yml. It is disabled by default to not accidentally waste your GitHub Workflow minutes.

## :wrench: Customizing your project

Various parts of the project are modular, allowing for easy removal of some features and re-use of some common logic.

### Removing VSCode (Editorless configuration)

The VSCode configuration is limited only to the .devcontainer folder. Removing this folder will remove any VSCode specific logic from the project so you can use your favourite Editor / IDE! Also don't forget to skip installing VSCode in the install command.

### Removing Docker (Minimal configuration)

Docker is used in these cases:
* For local development
* For continuous integration
* For VSCode 

If you don't intend to use any of these features, feel free to simply delete the Dockerfile. Also don't forget to skip installing Docker in the install command.

:page_with_curl: NOTE: If you intend to set up the Rust toolchain locally (as opposed to in Docker) then you can use the included rust_env_setup.sh script. This script is used in Docker for the same purpose and is package manager agnostic.
