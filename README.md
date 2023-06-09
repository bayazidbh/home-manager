# home-manager files and quick device setup

```
git clone git@github.com:bayazidbh/home-manager.git && cd ${${_%%.git*}##*/}
```

## Nix Setup


<details><summary>determinate-installer</summary><p>

https://github.com/DeterminateSystems/nix-installer
https://raw.githubusercontent.com/DeterminateSystems/nix-installer/main/README.md
https://github.com/DeterminateSystems/nix-installer/commits/main/README.md.atom

# The Determinate Nix Installer

[![Crates.io](https://img.shields.io/crates/v/nix-installer)](https://crates.io/crates/nix-installer)
[![Docs.rs](https://img.shields.io/docsrs/nix-installer)](https://docs.rs/nix-installer/latest/nix_installer/)

`nix-installer` is an opinionated alternative to the [official Nix install scripts](https://nixos.org/download.html).


```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

The `nix-installer` tool is ready to use in a number of environments:

| Platform                     | Multi User         | `root` only | Maturity          |
|------------------------------|:------------------:|:-----------:|:-----------------:|
| Linux (x86_64 & aarch64)     | ✓ (via [systemd])  | ✓           | Stable            |
| MacOS (x86_64 & aarch64)     | ✓                  |             | Stable (See note) |
| Valve Steam Deck (SteamOS)   | ✓                  |             | Stable            |
| WSL2 (x86_64 & aarch64)      | ✓ (via [systemd])  | ✓           | Stable            |
| Podman Linux Containers      | ✓ (via [systemd])  | ✓           | Stable            |
| Docker Containers            |                    | ✓           | Stable            |
| Linux (i686)                 | ✓ (via [systemd])  | ✓           | Unstable          |

> **Note**
> On **MacOS only**, removing users and/or groups may fail if there are no users who are logged in graphically.

## Installation Differences

Differing from the current official [Nix](https://github.com/NixOS/nix) installer scripts:

* In `nix.conf`:
  + the `auto-allocate-uids`, `nix-command` and `flakes` features are enabled
  + `bash-prompt-prefix` is set
  + `auto-optimise-store` is set to `true`
  * `extra-nix-path` is set to `nixpkgs=flake:nixpkgs`
  * `auto-allocate-uids` is set to `true`.
* an installation receipt (for uninstalling) is stored at `/nix/receipt.json` as well as a copy of the install binary at `/nix/nix-installer`
* `nix-channel --update` is not run, `~/.nix-channels` is not provisioned
* `NIX_SSL_CERT_FILE` is set in the various shell profiles if the `ssl-cert-file` argument is used.

## Motivations

The current Nix install scripts do an excellent job, however they are difficult to maintain. Subtle differences in the shell implementations and certain characteristics of bash scripts make it difficult to make meaningful changes to the installer.

Our team wishes to experiment with the idea of an installer in a more structured language and see if this is a worthwhile alternative. Along the way, we are also exploring a few other ideas, such as:

* offering users a chance to review an accurate, calculated install plan
* having 'planners' which can create appropriate install plans
* keeping an installation receipt for uninstallation
* offering users with a failing install the chance to do a best-effort revert
* doing whatever tasks we can in parallel

So far, our explorations have been quite fruitful, so we wanted to share and keep exploring.

## Usage

Install Nix with the default planner and options:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Or, to download a platform specific Installer binary yourself:

```bash
$ curl -sL -o nix-installer https://install.determinate.systems/nix/nix-installer-x86_64-linux
$ chmod +x nix-installer
```

> **Note**
> `nix-installer` will elevate itself if needed using `sudo`. If you use `doas` or `please` you may need to elevate `nix-installer` yourself.

`nix-installer` installs Nix by following a *plan* made by a *planner*. Review the available planners:

```bash
$ ./nix-installer install --help
Execute an install (possibly using an existing plan)

To pass custom options, select a planner, for example `nix-installer install linux-multi --help`

Usage: nix-installer install [OPTIONS] [PLAN]
       nix-installer install <COMMAND>

Commands:
  linux
          A planner for Linux installs
  steam-deck
          A planner suitable for the Valve Steam Deck running SteamOS
  help
          Print this message or the help of the given subcommand(s)
# ...
```

Planners have their own options and defaults, sharing most of them in common:

```bash
$ ./nix-installer install linux --help
A planner for Linux installs

Usage: nix-installer install linux [OPTIONS]

Options:
# ...
      --nix-build-group-name <NIX_BUILD_GROUP_NAME>
          The Nix build group name

          [env: NIX_INSTALLER_NIX_BUILD_GROUP_NAME=]
          [default: nixbld]

      --nix-build-group-id <NIX_BUILD_GROUP_ID>
          The Nix build group GID

          [env: NIX_INSTALLER_NIX_BUILD_GROUP_ID=]
          [default: 3000]
# ...
```

Planners can be configured via environment variable or command arguments:

```bash
$ curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | NIX_BUILD_GROUP_NAME=nixbuilder sh -s -- install linux-multi --nix-build-group-id 4000
# Or...
$ NIX_BUILD_GROUP_NAME=nixbuilder ./nix-installer install linux-multi --nix-build-group-id 4000
```


## Uninstalling

You can remove a `nix-installer`-installed Nix by running

```bash
/nix/nix-installer uninstall
```


## As a Github Action

You can use the [`nix-installer-action`](https://github.com/DeterminateSystems/nix-installer-action) Github Action like so:

```yaml
on:
  pull_request:
  push:
    branches: [main]

jobs:
  lints:
    name: Build
    runs-on: ubuntu-22.04
    steps:
    - uses: actions/checkout@v3
    - name: Install Nix
      uses: DeterminateSystems/nix-installer-action@main
    - name: Run `nix build`
      run: nix build .
```

## Without systemd (Linux only)

> **Warning**
> When `--init none` is used, _only_ `root` or users who can elevate to `root` privileges can run Nix:
>
> ```bash
> sudo -i nix run nixpkgs#hello
> ```

If you don't use [systemd], you can still install Nix by explicitly specifying the `linux` plan and `--init none`:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none
```

## In a container

In Docker/Podman containers or WSL2 instances where an init (like `systemd`) is not present, pass `--init none`.

For containers (without an init):

> **Warning**
> When `--init none` is used, _only_ `root` or users who can elevate to `root` privileges can run Nix:
>
> ```bash
> sudo -i nix run nixpkgs#hello
> ```

```dockerfile
# Dockerfile
FROM ubuntu:latest
RUN apt update -y
RUN apt install curl -y
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --init none \
  --no-confirm
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
RUN nix run nixpkgs#hello
```

```bash
docker build -t ubuntu-with-nix .
docker run --rm -ti ubuntu-with-nix
docker rmi ubuntu-with-nix
# or
podman build -t ubuntu-with-nix .
podman run --rm -ti ubuntu-with-nix
podman rmi ubuntu-with-nix
```

For containers with a systemd init:

```dockerfile
# Dockerfile
FROM ubuntu:latest
RUN apt update -y
RUN apt install curl systemd -y
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --no-start-daemon \
  --no-confirm
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
RUN nix run nixpkgs#hello
CMD [ "/bin/systemd" ]
```

```bash
podman build -t ubuntu-systemd-with-nix .
IMAGE=$(podman create ubuntu-systemd-with-nix)
CONTAINER=$(podman start $IMAGE)
podman exec -ti $CONTAINER /bin/bash
podman rm -f $CONTAINER
podman rmi $IMAGE
```

On some container tools, such as `docker`, `sandbox = false` can be omitted. Omitting it will negatively impact compatibility with container tools like `podman`.

## In WSL2

If [systemd is enabled](https://ubuntu.com/blog/ubuntu-wsl-enable-systemd) it's possible to install Nix as normal using the command at the top of this document:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

If systemd is not enabled, pass `--init none` at the end of the command:

> **Warning**
> When `--init none` is used, _only_ `root` or users who can elevate to `root` privileges can run Nix:
>
> ```bash
> sudo -i nix run nixpkgs#hello
> ```


```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none
```

## Skip confirmation

If you'd like to bypass the confirmation step, you can apply the `--no-confirm` flag:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

This is especially useful when using the installer in non-interactive scripts.

## Building a binary

Since you'll be using `nix-installer` to install Nix on systems without Nix, the default build is a static binary.

Build a portable Linux binary on a system with Nix:

```bash
# to build a local copy
nix build -L ".#nix-installer-static"
# to build the remote main development branch
nix build -L "github:determinatesystems/nix-installer#nix-installer-static"
# for a specific version of the installer:
export NIX_INSTALLER_TAG="v0.6.0"
nix build -L "github:determinatesystems/nix-installer/$NIX_INSTALLER_TAG#nix-installer-static"
```

On Mac:

```bash
# to build a local copy
nix build -L ".#nix-installer"
# to build the remote main development branch
nix build -L "github:determinatesystems/nix-installer#nix-installer"
# for a specific version of the installer:
export NIX_INSTALLER_TAG="v0.6.0"
nix build -L "github:determinatesystems/nix-installer/$NIX_INSTALLER_TAG#nix-installer"
```

Then copy the `result/bin/nix-installer` to the machine you wish to run it on.

You can also add `nix-installer` to a system without Nix via `cargo`:

```bash
# to build and run a local copy
RUSTFLAGS="--cfg tokio_unstable" cargo run -- --help
# to build the remote main development branch
RUSTFLAGS="--cfg tokio_unstable" cargo install --git https://github.com/DeterminateSystems/nix-installer
nix-installer --help
# for a specific version of the installer:
export NIX_INSTALLER_TAG="v0.6.0"
RUSTFLAGS="--cfg tokio_unstable" cargo install --git https://github.com/DeterminateSystems/nix-installer --tag $NIX_INSTALLER_TAG
nix-installer --help
```

To make this build portable, pass ` --target x86_64-unknown-linux-musl`.

> **Note**
> We currently require `--cfg tokio_unstable` as we utilize [Tokio's process groups](https://docs.rs/tokio/1.24.1/tokio/process/struct.Command.html#method.process_group), which wrap stable `std` APIs, but are unstable due to it requiring an MSRV bump.


## As a library

> **Warning**
> Use as a library is still experimental, if you're using this, please let us know and we can make a path to stablization.

Add `nix-installer` to your dependencies:

```bash
cargo add nix-installer
```

If you are **building a CLI**, check out the `cli` feature flag for `clap` integration.

You'll also need to edit your `.cargo/config.toml` to use `tokio_unstable` as we utilize [Tokio's process groups](https://docs.rs/tokio/1.24.1/tokio/process/struct.Command.html#method.process_group), which wrap stable `std` APIs, but are unstable due to it requiring an MSRV bump:

```toml
# .cargo/config.toml
[build]
rustflags=["--cfg", "tokio_unstable"]
```

Then it's possible to review the [documentation](https://docs.rs/nix-installer/latest/nix_installer/):

```bash
cargo doc --open -p nix-installer
```

Documentation is also available via `nix` build:

```bash
nix build github:DeterminateSystems/nix-installer#nix-installer.doc
firefox result-doc/nix-installer/index.html
```

## Accessing other versions

For users who desire version pinning, the version of `nix-installer` to use can be specified in the `curl` command:

```bash
VERSION="v0.6.0"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix/tag/${VERSION} | sh -s -- install
```

To discover which versions are available, or download the binaries for any release, check the [Github Releases](https://github.com/DeterminateSystems/nix-installer/releases).

These releases can be downloaded and used directly:

```bash
VERSION="v0.6.0"
ARCH="aarch64-linux"
curl -sSf -L https://github.com/DeterminateSystems/nix-installer/releases/download/${VERSION}/nix-installer-${ARCH} -o nix-installer
./nix-installer install
```

## Quirks

While `nix-installer` tries to provide a comprehensive and unquirky experience, there are unfortunately some issues which may require manual intervention or operator choices.

### Using MacOS remote SSH builders, Nix binaries are not on `$PATH`

When connecting to a Mac remote SSH builder users may sometimes see this error:

```bash
$ nix store ping --store "ssh://$USER@$HOST"
Store URL: ssh://$USER@$HOST
zsh:1: command not found: nix-store
error: cannot connect to '$USER@$HOST'
```

The way MacOS populates the `PATH` environment differs from other environments. ([Some background](https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2))

There are two possible workarounds for this:

* **(Preferred)** Update the remote builder URL to include the `remote-program` parameter pointing to `nix-store`. For example:
  ```bash
  nix store ping --store "ssh://$USER@$HOST?remote-program=/nix/var/nix/profiles/default/bin/nix-store"
  ```
  If you are unsure where the `nix-store` binary is located, run `which nix-store` on the remote.
* Update `/etc/zshenv` on the remote so that `zsh` populates the Nix path for every shell, even those that are neither *interactive* or *login*:
  ```bash
  # Nix
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
  # End Nix
  ```
  <details>
    <summary>This strategy has some behavioral caveats, namely, <code>$PATH</code> may have unexpected contents</summary>

    For example, if `$PATH` gets unset then a script invoked, `$PATH` may not be as empty as expected:
    ```bash
    $ cat example.sh
    #! /bin/zsh
    echo $PATH
    $ PATH= ./example.sh
    /Users/ephemeraladmin/.nix-profile/bin:/nix/var/nix/profiles/default/bin:
    ```
    This strategy results in Nix's paths being present on `$PATH` twice and may have a minor impact on performance.

  </details>

## Diagnostics

The goal of the Determinate Nix Installer is to successfully and correctly install Nix.
The `curl | sh` pipeline and the installer collects a little bit of diagnostic information to help us make that true.

Here is a table of the [diagnostic data we collect][diagnosticdata]:

| Field                 | Use                                                                                                   |
| --------------------- | ----------------------------------------------------------------------------------------------------- |
| `version`             | The version of the Determinate Nix Installer.                                                         |
| `planner`             | The method of installing Nix (`linux`, `macos`, `steam-deck`)                                         |
| `configured_settings` | The names of planner settings which were changed from their default. Does _not_ include the values.   |
| `os_name`             | The running operating system.                                                                         |
| `os_version`          | The version of the operating system.                                                                  |
| `triple`              | The architecture/operating system/binary format of your system.                                       |
| `is_ci`               | Whether the installer is being used in CI (e.g. GitHub Actions).                                      |
| `action`              | Either `Install` or `Uninstall`.                                                                      |
| `status`              | One of `Success`, `Failure`, `Pending`, or `Cancelled`.                                               |
| `failure_chain`     | A high level description of what the failure was, if any. For example: `Command("diskutil")` if the command `diskutil list` failed. |

To disable diagnostic reporting, set the diagnostics URL to an empty string by passing `--diagnostic-endpoint=""` or setting `NIX_INSTALLER_DIAGNOSTIC_ENDPOINT=""`.

You can read the full privacy policy for [Determinate Systems][detsys], the creators of the Determinate Nix Installer, [here][privacy].

[detsys]: https://determinate.systems/
[diagnosticdata]: https://github.com/DeterminateSystems/nix-installer/blob/f9f927840d532b71f41670382a30cfcbea2d8a35/src/diagnostics.rs#L29-L43
[privacy]: https://determinate.systems/privacy
[systemd]: https://systemd.io

</p></details>


<details><summary>nix-installer-scripts</summary><p>

https://github.com/dnkmmr69420/nix-installer-scripts
https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/README.md
https://github.com/dnkmmr69420/nix-installer-scripts/commits/main/README.md.atom

## nix-installer-scripts
Various scripts to install the nix package manager

This may break if something other than bash is not the default login shell so have bash be the default shell. It will be better to make a profile on your terminal application and have a different shell instance that way. If the commands itself give some sort of error, use bash as a shell. Type `bash` into the terminal to get to bash.

[Read This](https://github.com/dnkmmr69420/nix-installer-scripts/tree/main/nix-out-of-default)

## Installers

### Regular installer for non-selinux systems

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/regular-installer.sh | bash
```

### Installer for selinux systems that aren't immutable (Fedora workstation, RHEL, centos stream, rocky alma or oracle linux)

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/regular-nix-installer-selinux.sh | bash
```

### Installer for rpm-ostree based systems like silverblue/kinoite/ublue

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/silverblue-nix-installer.sh | bash
```

### Installer for opensuse microos

first run this

```bash
sudo transactional-update run mksubvolume /nix
```

Reboot

Then run the script

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/nix-microos-installer.sh | bash
```

### Void linux installer

First check if curl is installed

```bash
sudo xbps-install -S curl
```
use the bash shell

```bash
bash
```

Install nix

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/nix-void-linux-installer.sh | bash
```

### [Nix inside distrobox installer and setup](https://github.com/dnkmmr69420/nix-installer-scripts/tree/main/nix-distrobox)


## Uninstallers

### Regular uninstaller for both non-selinux and selinux muttable systems

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/uninstaller-scripts/regular-uninstaller.sh | bash
```

### Silverblue nix uninstaller

```bash
curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/uninstaller-scripts/silverblue-nix-uninstaller.sh | bash
```

## Other useful docs

[Extra Scripts](https://github.com/dnkmmr69420/nix-installer-scripts/blob/main/docs/extra-scripts.md)

[Nix with selinux manual install guide](https://github.com/dnkmmr69420/nix-installer-scripts/blob/main/docs/selinux-nix-manual-install-guide.md)

[Old github repos that this repo has replaced list](https://github.com/dnkmmr69420/nix-installer-scripts/blob/main/docs/my-old-nix-github-repos.md)

[Compile from source](https://github.com/dnkmmr69420/nix-installer-scripts/blob/main/docs/compile-from-source.md)

[Common Issues](https://github.com/dnkmmr69420/nix-installer-scripts/blob/main/docs/common-issues.md)

## Some useful nix tools

Fleek: [Github-page](https://github.com/ublue-os/fleek) [Website](https://getfleek.dev/)

Nix Portable: [Main-Page](https://github.com/DavHau/nix-portable) [My-nix-portable-utilities](https://github.com/dnkmmr69420/nix-portable-utils)

Devbox: [Website](https://www.jetpack.io/devbox) [Github](https://github.com/jetpack-io/devbox)

## Shorten link

https://tinyurl.com/nxscrpts

</p></details>

https://julianhofer.eu/blog/01-silverblue-nix/

```
echo "trusted-users = root fenglengshun" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
echo "substituters = https://cache.nixos.org https://nix-gaming.cachix.org https://chaotic-nyx.cachix.org https://ezkea.cachix.org \ntrusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" > ~/.config/nix/nix.conf

export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

EDITOR=kwrite home-manager edit
nix-shell -p cachix --run "cachix use ezkea"
cachix use nix-gaming
home-manager switch -b bak

nix-env --delete-generations old ; nix-store --gc ; nix-collect-garbage -d
nix-du -s=500MB | dot -Tpng > ~/Downloads/nix-store.png
```

## Setup Scripts

### All

<details><summary>All</summary><p>

#### create container home folders

```
mkdir -p ~/Documents/container/conty
mkdir -p ~/Documents/container/arch
ln -sifv $HOME/Documents/Private/Apps/Linux/config/ArchiSteamFarm-config ~/Documents/container/arch/
```

#### link emulator paths to default xdg paths

```
ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/config $HOME/.config/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/data $HOME/.local/share/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/Ryujinx/config $HOME/.config/Ryujinx
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/config $HOME/.config/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/data $HOME/.local/share/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/config $HOME/.config/dolphin-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/data $HOME/.local/share/dolphin-emu
ln -sifv $HOME/Games/Emulation/Sony/emu/PCSX2/config $HOME/.config/PCSX2
ln -sifv $HOME/Games/Emulation/Sony/emu/rpcs3/config $HOME/.config/rpcs3
ln -sifv $HOME/Games/Emulation/Sony/emu/ppsspp/config $HOME/.config/ppsspp

ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/config $HOME/Documents/container/conty/.config/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/yuzu/data $HOME/Documents/container/conty/.local/share/yuzu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/Ryujinx/config $HOME/Documents/container/conty/.config/Ryujinx
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/config $HOME/Documents/container/conty/.config/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/citra-emu/data $HOME/Documents/container/conty/.local/share/citra-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/config $HOME/Documents/container/conty/.config/dolphin-emu
ln -sifv $HOME/Games/Emulation/Nintendo/emu/dolphin-emu/data $HOME/Documents/container/conty/.local/share/dolphin-emu
ln -sifv $HOME/Games/Emulation/Sony/emu/PCSX2/config $HOME/Documents/container/conty/.config/PCSX2
ln -sifv $HOME/Games/Emulation/Sony/emu/rpcs3/config $HOME/Documents/container/conty/.config/rpcs3
ln -sifv $HOME/Games/Emulation/Sony/emu/ppsspp/config $HOME/Documents/container/conty/.config/ppsspp
```

#### Import gpg

```
gpg --import ~/Storage/Data/Documents/bayazidbh-gpg.gpg
```

#### Make resilio-sync config

```
mkdir -p $HOME/.config/rslsync
cp -v ~/Documents/Private/Apps/Linux/config/rslsync.conf $HOME/.config/rslsync
sed -i 's/"device_name": "[^"]*"/"device_name": "'$(hostname)'"/g' $HOME/.config/rslsync/rslsync.conf
```

#### block MiHoYo telemetry in /etc/hosts

```
echo -e "# block mihoyo telemetry\n\n0.0.0.0 overseauspider.yuanshen.com\n0.0.0.0 log-upload-os.hoyoverse.com\n0.0.0.0 dump.gamesafe.qq.com\n0.0.0.0 public-data-api.mihoyo.com\n0.0.0.0 log-upload.mihoyo.com\n0.0.0.0 uspider.yuanshen.com\n0.0.0.0 sg-public-data-api.hoyoverse.com\n\n0.0.0.0 prd-lender.cdp.internal.unity3d.com\n0.0.0.0 thind-prd-knob.data.ie.unity3d.com\n0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com\n0.0.0.0 cdp.cloud.unity3d.com\n0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com" | sudo tee -a /etc/hosts
```

#### create horizontal mangohud bar

```
mkdir -p /home/fenglengshun/.config/MangoHud/ && echo -e "horizontal\nlegacy_layout=0\nhud_no_margin\nfont_size=25\ntable_columns=28\nbackground_alpha=0.5\ntime=1\ntime_format=%I:%M %p\ngpu_stats\ngpu_temp\ncpu_stats\ncpu_temp\nram\nvram\nfps\nframe_timing\nframetime\ntoggle_hud=F8\nresolution\nwine\nvulkan_driver" | tee ~/.config/MangoHud/MangoHud.conf
```

#### create plasma-restarter

```
mkdir -p ~/.local/bin/ && echo '#! /bin/bash\n\nkillall plasmashell & kwin --replace & kstart plasmashell & exit' | tee ~/.local/bin/restart-plasma && chmod +x ~/.local/bin/restart-plasma
```

</p></details>

### PC

<details><summary>PC</summary><p>

#### Link HDD to SSD

```
ln -sifv ~/Storage/Data/Applications ~/Applications
ln -sifv ~/Storage/Data/Media/Games ~/Games
ln -sifv ~/Storage/Data/Documents ~/Documents/Storage
ln -sifv ~/Storage/Data/Downloads ~/Downloads/Storage
ln -sifv ~/Storage/Data/Media ~/Documents/Media
ln -sifv ~/Storage/Data/Pictures/Archive ~/Pictures/Storage
ln -sifv ~/Storage/Data/Pictures/DCIM ~/Pictures/DCIM
ln -sifv ~/Storage/Data/Music/ ~/Music/Storage
ln -sifv ~/Storage/Data/Videos/ ~/Videos/Storage
```

#### Copy backed up Documents

```
cp -rfpv ~/Storage/Data/Documents/Work ~/Documents/Work
cp -rfpv ~/Storage/Data/Documents/Private ~/Documents/Private
```

#### restore input-remapper settings

```
mkdir -p ~/.config/
cp -rfpv ~/Storage/Data/Documents/Private/Linux/config/input-remapper-2 ~/.config/
```

</p></details>

### Laptop

<details><summary>Laptop</summary><p>

#### autocheck for kdeconnect devices

```
crontab -e
( crontab -l ; echo -e "# Check for kdeconnect devices\n*/2 * * * *     /usr/bin/kdeconnect-cli --refresh" ) | crontab -
```

</p></details>

## Distro specific

### Debian / Ubuntu

<details><summary>Debian / Ubuntu</summary><p>

```
libdbusmenu-qt5-2　libdbusmenu-gtk4 appmenu-gtk3-module appmenu-gtk2-module libdbusmenu-gtk3-4　locales-all

curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get && deb-get install quickemu quickgui teamviewer

sudo apt-get install python3 python3-pip python3-yaml python3-dateutil python3-pyqt5 python3-packaging python3-requests && sudo pip3 install bauh
```
</p></details>


### Fedora

<details><summary>Fedora</summary><p>

```
sudo dnf install --allowerasing --best zsh @Virtualization fish kio-admin icoutils applet-window-buttons nmap wsdd samba python3-input-remapper gtk3-classic avif-pixbuf-loader heif-pixbuf-loader qt-heif-image-plugin libheif libheif-freeworld libheif-tools

sudo dnf install dnf5 https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
```

</p></details>

### Arch

<details><summary>Arch</summary><p>

```
pacman -Syyu paru

paru -Syyu plasma5-applets-window-title applet-window-appmenu-git applet-window-buttons-git topgrade brave-bin spotify spotify-adblock-git python-spotdl freedownloadmanager teamviewer steamtinkerlaunch heroic-games-launcher-bin krename gtk3-classic virt-manager gameconqueror qtscrcpy soundux corectrl appmenu-gtk-module discover ttf-ibm-plex icoextract ttf-meslo-nerd-font-powerlevel10k icoutils unicode-emoji python-emoji noto-fonts-emoji-flag-git noto-color-emoji-fontconfig sunshine hunspell-en_us

paru -Syu --skipreview --noconfirm  applet-window-appmenu-git applet-window-buttons-git archisteamfarm-bin btrfs-compress btrfs-du discord-screenaudio plasma-hud-git libspeedhack-git nwjs-bin nwjs-ffmpeg-codecs-bin ceserver rmtrash sgdboop-bin

sudo pacman -S $(pacman -Qsq "^linux" | grep "^linux[0-9]*[-rt]*$" | awk '{print $1"-headers"}' ORS=' ')

performance tweaks: ananicy-cpp memavaild preload nohang uresourced prelockd irqbalance

gaming: noisetorch fancontrol-gui input-remapper droidcam steamtinkerlaunch mangohud gamemode goverlay replay-sorcery gamescope nyrna fastgame gameconqueror
``````
</p></details>

## Other Setups

<details><summary>Distrobox</summary><p>

### Distrobox

```
env SHELL=/bin/fish distrobox create --image quay.io/toolbx-images/archlinux-toolbox --name arch --home ~/Documents/container/arch
tide configure

pacman-key --init && pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com && pacman-key --lsign-key 3056513887B78AEB && pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' && echo '[chaotic-aur]' >> /etc/pacman.conf && echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf && echo 'en_SG.UTF-8 UTF-8' >> /etc/locale.gen && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen && echo 'id_ID.UTF-8 UTF-8' >> /etc/locale.gen && pacman -Syu --noconfirm glibc base-devel nano paru pipewire-jack pipewire-pulse pipewire-alsa

paru -Syu --skipreview --noconfirm nwjs-bin nwjs-ffmpeg-codecs-bin archisteamfarm-bin

---

env SHELL=/bin/bash distrobox create --image ubuntu:latest --name ubuntu-latest --home ~/Documents/container/ubuntu-latest

env SHELL=/home/fenglengshun/.nix-profile/bin/zsh distrobox create --image fedora:latest --name fedora --home ~/Documents/container/fedora
sudo dnf install dnf5 https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

distrobox create --root --init --image registry.opensuse.org/opensuse/tumbleweed:latest --name tumbleweed --home $XDG_DATA_HOME/distrobox/tumbleweed
https://github.com/89luca89/distrobox/blob/main/docs/posts/run_libvirt_in_distrobox.md
```

</p></details>


<details><summary>Fish-ified ZSH</summary><p>

### Fish-ified ZSH

```
sudo chsh -s /bin/zsh ; chsh -s /bin/zsh ; sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ; git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search ; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ; git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

kwrite ~/.zshrc
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)
source ~/.zshrc
```

</p></details>

<details><summary>WhiteSur</summary><p>

### WhiteSur

#### Normal Install

- https://github.com/vinceliuice/WhiteSur-gtk-theme
- https://github.com/vinceliuice/WhiteSur-icon-theme
- https://github.com/vinceliuice/WhiteSur-kde
- https://github.com/vinceliuice/WhiteSur-cursors
- https://github.com/vinceliuice/Monterey-kde

```
mkdir -p /tmp/whitesur/whitesur

git clone https://github.com/vinceliuice/WhiteSur-gtk-theme /tmp/whitesur/WhiteSur-gtk-theme
/tmp/whitesur/WhiteSur-gtk-theme/install.sh -m -i -l standard -b default
/tmp/whitesur/WhiteSur-gtk-theme/tweaks.sh -F

git clone https://github.com/vinceliuice/WhiteSur-icon-theme /tmp/whitesur/WhiteSur-icon-theme
/tmp/whitesur/WhiteSur-icon-theme/install.sh

git clone https://github.com/vinceliuice/WhiteSur-kde /tmp/whitesur/WhiteSur-kde
/tmp/whitesur/WhiteSur-kde/install.sh
/tmp/whitesur/WhiteSur-kde/sddm/install.sh

git clone https://github.com/vinceliuice/WhiteSur-cursors /tmp/whitesur/WhiteSur-cursors
/tmp/whitesur/WhiteSur-cursors/install.sh

git clone https://github.com/vinceliuice/Monterey-kde /tmp/whitesur/Monterey-kde
/tmp/whitesur/Monterey-kde/install.sh
sudo /tmp/whitesur/Monterey-kde/sddm/install.sh
```

#### Icon options

```
--icon [standard|simple|gnome|ubuntu|tux|arch|manjaro|fedora|debian|void|opensuse|popos|mxlinux|zorin]
```

#### ublue Install

```
git clone git@github.com:bayazidbh/WhiteSur-gtk-theme.git ; git clone git@github.com:bayazidbh/WhiteSur-icon-theme.git ; git clone git@github.com:bayazidbh/WhiteSur-kde.git ; git clone git@github.com:bayazidbh/Monterey-kde.git ; git clone git@github.com:bayazidbh/WhiteSur-cursors.git
```

#### GNOME Install

```
/tmp/whitesur/WhiteSur-gtk-theme/tweaks --dash-to-dock -c dark ; sudo /tmp/whitesur/WhiteSur-gtk-theme/tweaks.sh -g --gdm-no-darken --no-blur -b default ;
```

</p></details>

### libvirt

<details><summary>xml</summary><p>

```
  <clock offset="localtime">
    <timer name="hpet" present="yes"/>
    <timer name="hypervclock" present="yes"/>
  </clock>

<disk type="file" device="disk">
      <driver name="qemu" type="qcow2"/>
      <source file="/home/fenglengshun/.local/share/libvirt/win11.qcow2"/>
      <target dev="vda" bus="virtio"/>
      <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
</disk>
```
</p></details>

<details><summary>Command</summary><p>

```
$ sudo sed -i "s/#user = \"root\"/user = \"$(id -un)\"/g" /etc/libvirt/qemu.conf
$ sudo sed -i "s/#group = \"root\"/group = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf
$ sudo usermod -a -G kvm $(id -un)
$ sudo usermod -a -G libvirt $(id -un)
$ sudo systemctl restart libvirtd

$ sudo ln -s /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/

$ sudo sed -i "s/\/usr\/libexec\/libvirt_leaseshelper m,/\/usr\/libexec\/libvirt_leaseshelper mr,/g" /etc/apparmor.d/usr.sbin.dnsmasq
$ mkdir -p ~/.config/libvirt
$ echo "uri_default = \"qemu:///system\"" >> ~/.config/libvirt/libvirt.conf
```

</p></details>

<details><summary>Docker setup</summary><p>

```
docker pull portainer/portainer
docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer

# https://hub.docker.com/r/resilio/sync/
export DATA_FOLDER=/home/fenglengshun/rslsync
export WEBUI_PORT=30000
DATA_FOLDER=/home/fenglengshun/rslsync  WEBUI_PORT=30000 docker run -d --name Sync -p 30000:8888 -p 55555 -v /home/fenglengshun/rslsync:/mnt/sync -v /home/fenglengshun:/mnt/mounted_folders/fenglengshun -v /mnt/data:/mnt/mounted_folders/data --restart unless-stopped resilio/sync
```

</p></details>

### Others

<details><summary>AppImage</summary><p>

- [Bauh](https://github.com/vinifmor/bauh#installation)
- [ScreenTranslator](https://github.com/OneMoreGres/ScreenTranslator/releases)

```
aria2c https://raw.githubusercontent.com/vinifmor/bauh/master/bauh/desktop/bauh.desktop
aria2c https://raw.githubusercontent.com/vinifmor/bauh-files/master/pictures/logo.svg
```

</p></details>
