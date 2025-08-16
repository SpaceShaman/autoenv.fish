# autoenv.fish

A [Fish Shell](https://fishshell.com/) plugin that automatically loads environment variables from a `.env` file in the current project.

## Features

- 🔁 Automatically loads environment variables from a `.env` file in the current project.
- 🐟 Lightweight and runs on every directory change
- 🔻 Automatically erases environment variables when leaving the project directory.
- 🐙 Supports Git repositories (uses repo root as project dir)

## Installation

### With [fisher](https://github.com/jorgebucaran/fisher)

```fish
fisher install SpaceShaman/autoenv.fish
```

### With [reef](https://github.com/danielb2/reef)

```fish
reef install SpaceShaman/autoenv.fish
```

### Manual

Copy the `conf.d/autoenv.fish` file to your `~/.config/fish/conf.d` directory.

## Usage tip

If you want to load environment variables automatically every time you start a new shell (even in terminals spawned from within other tools like Vim), add the following line to your `config.fish`:

```fish
autoenv
```

This ensures that the environment variables are loaded right after shell startup, not just when changing directories.
