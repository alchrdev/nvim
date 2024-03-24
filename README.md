# Alchr's dotfiles

[Spanish version](./README_es.md)

## 🛠️ Neovim Configuration

- These are some of the people who have guided me on this path:
  - [Josean Martinez](https://www.youtube.com/@joseanmartinez)
  - [ThePrimeagen](https://www.youtube.com/@ThePrimeagen)
  - [Adib Hanna](https://www.youtube.com/@adibhanna)
  - [Sockthedev](https://www.youtube.com/@sockthedev4904)
  - [TJDeVries](https://github.com/tjdevries), among others.

### Download and installation of the necessary tools

#### Windows 10 / 11

- Executables
  - [Git](https://git-scm.com/downloads)
  - [Node.js](https://nodejs.org/en)
  - [Visual Studio 2015 C++ redistributable](https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170) `https://aka.ms/vs/17/release/vc_redist.x64.exe`
- Extractables (All of these must be added to the PATH _Environment variables_)
  - [Neovim](https://github.com/neovim/neovim/releases/tag/stable) `nvim-win64.zip`
  - [Ripgrep](https://github.com/BurntSushi/ripgrep/releases/tag/14.1.0) `ripgrep-14.0.3-x86_64-pc-windows-msvc.zip` (All of these must be added to the PATH _Environment Variables_)
  - [Mingw](https://github.com/niXman/mingw-builds-binaries/releases/tag/13.2.0-rt_v11-rev1) `x86_64-13.2.0-release-win32-seh-msvcrt-rt_v11-rev1.7z`
  - [Treesitter](https://github.com/tree-sitter/tree-sitter/releases/tag/v0.21.0) `tree-sitter-windows-x64.gz`

#### Organization and Configuration of Tools in the Environment Variables

You can choose the name you want for your folders, here is an example of how I have it:

- In the drive `C` I created a folder `C:\Tools` and inside it the following subfolders:
  - `C:\Tools\mingw\bin`
  - `C:\Tools\nvim\bin`
  - `C:\Tools\ripgrep`
  - `C:\Tools\tree-sitter`

> When you unzip `tree-sitter-windows-x64.gz`, you will find an `.exe` file. I recommend that you create a folder called `tree-sitter` and move the `.exe` file into it. This will make it easier to add the file to the environment variables in later steps.

#### Installation using scoop

Previously, I used to install all the tools manually on my system. However, this method sometimes caused me problems. In particular, I encountered errors like `Failed to load parser for language 'yaml': uv_dlopen: The specified procedure could not be found.` when trying to install certain packages.

```shell
scoop install main/neovim
scoop install main/ripgrep
scoop install main/mingw
scoop install main/tree-sitter
```

> 💡 I performed the installations on Windows 10 and 11. In both cases, the errors I had previously encountered were resolved by using Scoop instead of manual installation. Now, everything works smoothly on my system.

#### How do I check that they are installed correctly?

- To do this, you can run the following commands:
  - neovim: `nvim --version`
  - ripgrep: `rg --version`
  - mingw: `gcc --version`
  - tree-sitter: `tree-sitter --version`

Once you have done this, you can run `nvim` in the terminal. It will automatically create a folder called `nvim-data` in `C:\Usersuario`. In the same location, you will have to create another one called `nvim` and put your configuration inside. You can create them manually or clone one from someone you like or admire with a `git clone https://github.com/nombredeusuario/nvim.lua.git nvim`.

### Linux (Ubuntu)

#### To download the Neovim AppImage from the official GitHub repository, follow these steps:

- Visit [this link](https://github.com/neovim/neovim/releases) and browse for the `nvim.appimage` file.
- Download the file and move it to the `~/.local/bin` folder.
- Make it executable with the command `chmod +x nvim.appimage` and create a symbolic link with `ln -s nvim.appimage nvim`.
- To add it to the `PATH`, edit the `.bashrc` file with the command `nano ~/.bashrc` and add the line `export PATH=~/.local/bin:$PATH` at the end.
- Save the changes and close the editor.
- Finally, run the `source ~/.bashrc` command to apply the changes.

#### To avoid possible errors with `appimage` in Ubuntu, you can install `libfuse2` with the following command:

```bash
sudo apt install libfuse2
```

- You can also install some additional tools like `ripgrep`, `git`, `nodejs`, `xclip`, `build-essential` and `tree-sitter-cli` with the following commands:

```bash
# Install ripgrep
sudo apt install ripgrep

# Install git
sudo apt-get install git
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git

# Install nodejs
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Enable clipboard
sudo apt install xclip

# Install C compiler
sudo apt-get install build-essential

# Install tree-sitter-cli
sudo npm install -g tree-sitter-cli
```
