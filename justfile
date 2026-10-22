name := 'cosmic-sys-monitor'
appid := 'io.github.marcos.SysMonitor'
rootdir := ''
prefix := '/usr'
destdir := ''

base-dir := destdir / prefix
cargo-target-dir := env('CARGO_TARGET_DIR', 'target')
metainfo-dst := base-dir / 'share' / 'metainfo' / appid + '.metainfo.xml'
bin-dst := base-dir / 'bin' / name
desktop-dst := base-dir / 'share' / 'applications' / appid + '.desktop'
icon-dst := base-dir / 'share' / 'icons' / 'hicolor' / 'symbolic' / 'apps' / appid + '-symbolic.svg'

# User-local install locations (no sudo required)
user-base := env('HOME') / '.local'
user-bin := user-base / 'bin'
user-data := user-base / 'share'
user-bin-dst := user-bin / name
user-desktop-dst := user-data / 'applications' / appid + '.desktop'
user-icon-dst := user-data / 'icons' / 'hicolor' / 'symbolic' / 'apps' / appid + '-symbolic.svg'
user-metainfo-dst := user-data / 'metainfo' / appid + '.metainfo.xml'

default: build-release

clean:
    cargo clean

build-debug *args:
    cargo build {{args}}

build-release *args: (build-debug '--release' args)

check *args:
    cargo clippy --all-features {{args}} -- -W clippy::pedantic

run *args:
    env RUST_BACKTRACE=full cargo run --release {{args}}

install: build-release
    sudo install -Dm0755 {{ cargo-target-dir / 'release' / name }} {{bin-dst}}
    sudo install -Dm0644 resources/app.desktop {{desktop-dst}}
    sudo install -Dm0644 resources/app.metainfo.xml {{metainfo-dst}}
    sudo install -Dm0644 resources/icon-symbolic.svg {{icon-dst}}
    -killall -9 cosmic-panel

# Install into ~/.local without sudo (Exec uses an absolute path, no PATH changes)
install-user: build-release
    install -Dm0755 {{ cargo-target-dir / 'release' / name }} {{ user-bin-dst }}
    mkdir -p {{ user-data / 'applications' }}
    sed 's|^Exec=.*|Exec={{ user-bin-dst }}|' resources/app.desktop > {{ user-desktop-dst }}
    install -Dm0644 resources/app.metainfo.xml {{ user-metainfo-dst }}
    install -Dm0644 resources/icon-symbolic.svg {{ user-icon-dst }}
    -killall -9 cosmic-panel

uninstall:
    sudo rm -f {{bin-dst}} {{desktop-dst}} {{icon-dst}} {{metainfo-dst}}
    -killall -9 cosmic-panel

uninstall-user:
    rm -f {{ user-bin-dst }} {{ user-desktop-dst }} {{ user-icon-dst }} {{ user-metainfo-dst }}
    -killall -9 cosmic-panel
