# Alchr's dotfiles

[English version](./README.md)

## 🛠️ Configuración de Neovim

- Estas son algunas de las personas que me han guiado en este camino:
  - [Josean Martinez](https://www.youtube.com/@joseanmartinez)
  - [ThePrimeagen](https://www.youtube.com/@ThePrimeagen)
  - [Adib Hanna](https://www.youtube.com/@adibhanna)
  - [Sockthedev](https://www.youtube.com/@sockthedev4904)
  - [TJDeVries](https://github.com/tjdevries), entre otros.

### Descarga e instalación de las herramientas necesarias

#### Windows 10 / 11

- Ejecutables
  - [Git](https://git-scm.com/downloads)
  - [Node.js](https://nodejs.org/en)
  - [Visual Studio 2015 C++ redistributable](https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170) `https://aka.ms/vs/17/release/vc_redist.x64.exe`
- Extraíbles (Todos estos deben ser añadidos al PATH _Variables de entorno_)
  - [Neovim](https://github.com/neovim/neovim/releases/tag/stable) `nvim-win64.zip`
  - [Ripgrep](https://github.com/BurntSushi/ripgrep/releases/tag/14.1.0) `ripgrep-14.0.3-x86_64-pc-windows-msvc.zip` (Todos estos deben ser añadidos al PATH _Variables de entorno_)
  - [Mingw](https://github.com/niXman/mingw-builds-binaries/releases/tag/13.2.0-rt_v11-rev1) `x86_64-13.2.0-release-win32-seh-msvcrt-rt_v11-rev1.7z`
  - [Treesitter](https://github.com/tree-sitter/tree-sitter/releases/tag/v0.21.0) `tree-sitter-windows-x64.gz`

#### Organización y Configuración de las Herramientas en las Variables de Entorno

Puedes elegir el nombre que quieras para tus carpetas, aquí te dejo un ejemplo de cómo lo tengo yo:

- En la unidad `C` creé una carpeta `C:\Tools` y dentro de ella las siguientes subcarpetas:
  - `C:\Tools\mingw\bin`
  - `C:\Tools\nvim\bin`
  - `C:\Tools\ripgrep`
  - `C:\Tools\tree-sitter`

> Al descomprimir `tree-sitter-windows-x64.gz`, encontrarás un archivo `.exe`. Te recomiendo que crees una carpeta llamada `tree-sitter` y que muevas el archivo `.exe` dentro de ella. Así será más fácil añadir el archivo a las variables de entorno en pasos posteriores.

#### Instalación mediante scoop

Anteriormente, solía instalar todas las herramientas de forma manual en mi sistema. Sin embargo, este método algunas veces me causaba problemas. En particular, encontré errores del tipo `Failed to load parser for language 'yaml': uv_dlopen: The specified procedure could not be found.` al intentar instalar ciertos paquetes.

```shell
scoop install main/neovim
scoop install main/ripgrep
scoop install main/mingw
scoop install main/tree-sitter
```

> 💡 Realicé las instalaciones en Windows 10 y 11. En ambos casos, los errores que había encontrado anteriormente se solucionaron al utilizar Scoop en lugar de la instalación manual. Ahora, todo funciona sin problemas en mi sistema.

#### ¿Cómo compruebo que se instalaron correctamente?

- Para ello puedes ejecutar los siguientes comandos:
  - neovim: `nvim --version`
  - ripgrep: `rg --version`
  - mingw: `gcc --version`
  - tree-sitter: `tree-sitter --version`

Una vez que hayas hecho esto, puedes ejecutar `nvim` en la terminal. Se creará automáticamente una carpeta llamada `nvim-data` en `C:\Users\tuUsuario\AppData\Local\nvim-data`. En la misma ubicación, tendrás que crear otra llamada `nvim` y poner tu configuración dentro. Puedes crearlas manualmente o clonar una de alguien que te guste o admires con un `git clone https://github.com/nombredeusuario/nvim.lua.git nvim`.

### Linux (Ubuntu)

#### Para descargar el AppImage de Neovim desde el repositorio oficial de GitHub, sigue estos pasos:

- Visita [este enlace](https://github.com/neovim/neovim/releases) y busca el archivo `nvim.appimage`.
- Descarga el archivo y muévelo a la carpeta `~/.local/bin`.
- Hazlo ejecutable con el comando `chmod +x nvim.appimage` y crea un enlace simbólico con `ln -s nvim.appimage nvim`.
- Para añadirlo al `PATH`, edita el archivo `.bashrc` con el comando `nano ~/.bashrc` y añade la línea `export PATH=~/.local/bin:$PATH` al final.
- Guarda los cambios y cierra el editor.
- Finalmente, ejecuta el comando `source ~/.bashrc` para aplicar los cambios.

#### Para evitar posibles errores con `appimage` en Ubuntu, puedes instalar `libfuse2` con el siguiente comando:

```bash
sudo apt install libfuse2
```

- También puedes instalar algunas herramientas adicionales como `ripgrep`, `git`, `nodejs`, `xclip`, `build-essential` y `tree-sitter-cli` con los siguientes comandos:

```bash
# Instalar ripgrep
sudo apt install ripgrep

# Instalar git
sudo apt-get install git
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git

# Instalar nodejs
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Habilitar portapapeles
sudo apt install xclip

# Instalar compilador C
sudo apt-get install build-essential

# Instalar tree-sitter-cli
sudo npm install -g tree-sitter-cli
```
