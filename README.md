# SMLinux

SMLinux is a Linux operating system project under active development. The project is organized into multiple distribution variants, each with its own release-track structure.

## Project status

- Ubuntu edition: 0.1 prototype (custom Qt/QML shell; ISO build script is experimental)
- Arch Linux edition: **0.1.1 "Dawn" available**: Hyprland + KDE Plasma, login screen, one-button desktop switching, live wallpaper, installer, updates through pacman ([details](SMLinux-Arch/0.1-current-release/README.md), [download](https://github.com/salihmalayil/SMLinux/releases))
- Debian edition: not started
- Release lifecycle: 0.1 current, 1.0 next major release, 2.0 future prototype

## Distribution variants

- [SMLinux-Ubuntu](SMLinux-Ubuntu/README.md)
- [SMLinux-Arch](SMLinux-Arch/README.md)
- [SMLinux-Debian](SMLinux-Debian/README.md)

## Release roadmap

- [ROADMAP.md](ROADMAP.md)
- [RELEASE-STATUS.md](RELEASE-STATUS.md)

## Repository structure

```text
SMLinux/
├── README.md
├── ROADMAP.md
├── RELEASE-STATUS.md
├── SMLinux-Ubuntu/
│   ├── README.md
│   ├── 0.1-current-release/
│   │   └── README.md
│   ├── 1.0-next-big-release/
│   │   └── README.md
│   └── 2.0-future-prototype/
│       └── README.md
├── SMLinux-Arch/
│   ├── README.md
│   ├── 0.1-current-release/
│   │   └── README.md
│   ├── 1.0-next-big-release/
│   │   └── README.md
│   └── 2.0-future-prototype/
│       └── README.md
├── SMLinux-Debian/
│   ├── README.md
│   ├── 0.1-current-release/
│   │   └── README.md
│   ├── 1.0-next-big-release/
│   │   └── README.md
│   └── 2.0-future-prototype/
│       └── README.md
└── docs/
    └── project-overview.md
```

## License

Original SMLinux code in this repository is MIT licensed: see [LICENSE](LICENSE). The software each edition installs keeps its own licenses.
