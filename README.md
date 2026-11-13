# dotfiles

A Macem teljes fejlesztői setupja: milyen appokat és CLI toolokat használok, hogyan van beállítva a shell, a terminál és a git. Egy paranccsal visszaállítható egy új gépen.

```bash
git clone https://github.com/futozs/dotfiles.git ~/Developer/personal/dotfiles
cd ~/Developer/personal/dotfiles && ./install.sh --all
./macos.sh
```

Az `install.sh` feltelepíti a `Brewfile` tartalmát, symlinkeli a konfigokat a helyükre, és beimportálja a shell-előzményeket az atuinba. A `--all` kapcsolóval a [claude-setup](https://github.com/futozs/claude-setup) és a [vscode-setup](https://github.com/futozs/vscode-setup) repót is leklónozza és telepíti. Amit felülír, azt előtte a `~/dotfiles-backups/<időbélyeg>/` mappába menti. A már telepített csomagokat nem frissíti. Bármikor újrafuttatható.

A `macos.sh` külön fájl, és szándékosan nem fut automatikusan: rendszerbeállításokat ír, ezért érdemes átolvasni, mielőtt elindítod.

## Appok

| App | Mire | Miért ez |
|---|---|---|
| [Ghostty](https://ghostty.org) | Terminál | GPU-gyorsított, natív macOS app. Az `Alt+Space` bárhonnan lehúz egy terminált a képernyő tetejéről. |
| [Helium](https://helium.computer) | Böngésző | Chromium, tehát ugyanaz a DevTools, mint a Chrome-ban, de Google-szolgáltatások nélkül és beépített uBlock Originnel. WebKit-teszthez marad a Safari. |
| [Raycast](https://raycast.com) | Indító | A Spotlight helyett: appok, fájlok, vágólap-előzmények, ablakkezelés, snippetek. |
| [OrbStack](https://orbstack.dev) | Docker, Linux VM | Gyorsabban indul és kevesebb memóriát eszik, mint a Docker Desktop vagy a colima. |
| [VS Code](https://code.visualstudio.com) | Editor | Beállítva: [vscode-setup](https://github.com/futozs/vscode-setup). |
| [Claude Code](https://claude.com/claude-code) | AI | Beállítva: [claude-setup](https://github.com/futozs/claude-setup). |
| Bitwarden | Jelszókezelő | |

## Shell

zsh + [oh-my-zsh](https://ohmyz.sh) + [powerlevel10k](https://github.com/romkatv/powerlevel10k). Új terminál kb. 0,15 s alatt indul.

| Tool | Mit ad |
|---|---|
| zsh-autosuggestions | Gépelés közben szürkén mutatja a korábbi parancsot, a `→` elfogadja. |
| zsh-syntax-highlighting | Pirosan jelzi, ha elgépeltél egy parancsot, mielőtt Entert nyomnál. |
| [atuin](https://atuin.sh) | `Ctrl+R`: fuzzy keresés a teljes shell-előzményben. Git repóban először az adott repó parancsait mutatja. Csak helyben tárol, nem szinkronizál. |
| fzf | `Ctrl+T` fájl, `Alt+C` mappa keresése. |
| zoxide | `z racehub`: ugrás egy gyakran használt mappába. |
| `p` / `pc` | Fuzzy projektválasztó a `~/Developer` repóira (a vscode-setupból). |
| [mise](https://mise.jdx.dev) | Projektenként a megfelelő Node/Bun/Python verzió. Olvassa a `.nvmrc`, `.node-version` és `.tool-versions` fájlokat. |
| direnv | Projektenkénti env változók egy `.envrc` fájlból. |
| eza, bat | `ls` git státusszal és ikonokkal; `cat` szintaxiskiemeléssel. |

Aliasok: `ll`, `lt` (fa nézet), `lg` (lazygit), `dev`, `reload`, `brewup`, `mkcd`. Gépspecifikus vagy titkos beállítások a `~/.zshrc.local` fájlba kerülnek, az nincs a repóban.

## Git

A `~/.gitconfig` helyi fájl marad (név, e-mail, gépspecifikus beállítások), és behúzza a közös `git/config`-ot.

- **delta:** szintaxiskiemelt diffek sorszámokkal. A fájlnévre kattintva a fájl megnyílik VS Code-ban.
- **lazygit** (`lg`) a terminálban.
- **Alapértelmezések:** `push.autoSetupRemote`, `pull.rebase`, `rebase.autoStash`, `fetch.prune`, `rerere`, `merge.conflictStyle = zdiff3`, `diff.algorithm = histogram`. A branchek a legutóbbi commit szerint rendezve listázódnak.
- **Aliasok:** `git s`, `git lg`, `git last`, `git undo`, `git amend`, `git branches`, `git cleanup`.

## macOS (`macos.sh`)

- Gyors billentyűismétlés. Kikapcsolva az automatikus javítás, az okos idézőjelek és gondolatjelek, mert ezek elrontják a kódot a böngészős mezőkben.
- Finder: látszanak a kiterjesztések, a rejtett fájlok, az útvonalsáv. Lista nézet, mappák elöl, új ablak a `~/Developer`-ben nyílik. Hálózati meghajtón és USB-n nem jön létre `.DS_Store`.
- Dock: késleltetés nélküli auto-hide, nincsenek „legutóbbi” appok, a Spaces sorrendje nem változik magától.
- Képernyőfotók: a `~/Pictures/Screenshots` mappába, PNG-ben, ablakárnyék nélkül.

## Mappaszerkezet

```
~/Developer/
├── clients/    ügyfélprojektek
├── personal/   saját projektek, köztük ez a három setup repó
├── school/     iskola, versenyek
├── archive/    régi verziók
└── sandbox/    kísérletek
```

## Licenc

MIT
