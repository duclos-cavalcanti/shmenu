<h1 align="center">shmenu</h1>
<p align="center">
  simple bash-based menu tui
</p>

## Installation
```sh
  git clone git@github.com:duclos-cavalcanti/shmenu.git
  sudo make install
```

For de-installation, simply go back into the cloned folder and run `sudo make uninstall`.

## Usage
![video](.github/assets/demo.gif?)

## TODO

- [ ] learn more and properly about stty
- [ ] read from stdin if used in piped commands, how not break stty error throw?
- [ ] ready raw input through stty, instead of blocking read
- [ ] properly trap SIGWINCH, SIGINT and EXIT

## License
This project is released under the GNU General Public License 3.0. See [LICENSE](LICENSE).

## Contributions
Please follow the instructions in the contributions guide at [CONTRIBUTING.md](CONTRIBUTING.md).

## Documentation
- [vt100](https://vt100.net/docs/vt100-ug/contents.html)
- [northwestern-vt100](https://www2.ccs.neu.edu/research/gpc/VonaUtils/vona/terminal/vtansi.htm)
- [vt510](https://vt100.net/docs/vt510-rm/contents.html)
- [xterm](https://www.xfree86.org/current/ctlseqs.html)

## Thanks
- [writing-a-tui-in-bash](https://github.com/dylanaraps/writing-a-tui-in-bash)
- [pure-bash-bible](https://github.com/dylanaraps/pure-bash-bible)
- [fff](https://github.com/dylanaraps/fff)
- [vhs](https://github.com/charmbracelet/vhs)

## Donations
I have a ko-fi and a buy-me-a-coffee account, so if you found this repo useful and would like to show your appreciation, feel free to do so!

<p align="center">
<a href="https://ko-fi.com/duclos">
<img src="https://img.shields.io/badge/donation-ko--fi-red.svg">
</a>

<a href="https://www.buymeacoffee.com/danielduclos">
<img src="https://img.shields.io/badge/donation-buy--me--coffee-green.svg">
</a>

</p>

---
<p align="center">
<a href="https://github.com/duclos-cavalcanti/templates/LICENSE">
  <img src="https://img.shields.io/badge/license-GPL3-green.svg" />
</a>
<a>
  <img src="https://img.shields.io/github/languages/code-size/duclos-cavalcanti/shmenu.svg" />
</a>
<a>
  <img src="https://img.shields.io/github/commit-activity/m/duclos-cavalcanti/shmenu.svg" />
</a>
