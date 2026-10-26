# Contributing

This guide covers safe workflows for proposing changes to the Project Proteus `Dev` branch.

## Index

- [Before you start](#before-you-start)
- [Tools](#tools)
- [One time setup](#one-time-setup)
- [Development workflow](#development-workflow)
- [Maintenance workflow](#maintenance-workflow)

## Before you start

- Join the [Project Discord](https://discord.gg/HrDPn9vcuN) to discuss your idea and get help.
- Check [GitHub Issues](https://github.com/TaxEvader6686/Project-Proteus/issues) for existing reports or plans.
- Before editing a warlord group, check the
[group ownership document](https://docs.google.com/document/d/1kTn2ChBXyPefAGgiAWkms-F-psZa9NI5PI5U2Ns8ftU)
and coordinate changes with the group owner on Discord.
- Vacant warlord groups that you can claim can be found [here](https://docs.google.com/document/d/1kTn2ChBXyPefAGgiAWkms-F-psZa9NI5PI5U2Ns8ftU/edit?tab=t.nok4xvbwulrm#heading=h.c3b5ztpu2p4) (please try to use the groups on the upper lists first)
- Reference the separate [player roster document](https://docs.google.com/document/d/1kTn2ChBXyPefAGgiAWkms-F-psZa9NI5PI5U2Ns8ftU).

## Tools

### Git and GitHub Desktop

Install [GitHub Desktop](https://desktop.github.com/) and sign in with your [GitHub account](https://github.com/signup).
GitHub desktop is the recommended way to follow this guide if you are new to Git.
Also see the official [Getting Started with GitHub Desktop](https://docs.github.com/en/desktop/overview/getting-started-with-github-desktop)

> Native Git, GitHub CLI, or VS Code's Git tools can replace GitHub Desktop if you already use them.
> However, the rest of this guide is tailored for GitHub Desktop and VS Code.

### Text Editors

Use a text editor to edit `xml`, `lua`, and other text-based files.

- [Visual Studio Code](https://code.visualstudio.com/) is highly recommended because of the extensions available.
- [Notepad++](https://notepad-plus-plus.org/) is a lightweight alternative for simple edits.

When using VS Code, installing **extensions** can help with XML and Lua editing.
They provide quality-of-life features like syntax highlighting, code completion, and error checking.

**VS Code Extensions:**
- [pg-starwarsgame-lsp](https://github.com/AlamoEngine-Tools/pg-starwarsgame-lsp) is a custom language server made specifically for EaW.
- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) by sumneko is a universal Lua Language Server

> Don't enable both extensions at the same time because the language servers may conflict.

### Additional Tools

- [TilotnyStudio](https://github.com/Vardamir117/TilotnyStudio/releases) is an experimental graphical editor for common modding tasks.
- [Shared modding tools](https://drive.google.com/drive/folders/1jtvFesp7LfNVAnxubT3lde0dpA51au3e) are available for various purposes.

## One time setup

### Set up your development copy

1. Open the [Project Proteus repository](https://github.com/TaxEvader6686/Project-Proteus) and choose **Fork**.
   A fork is your own GitHub copy of the project where you can publish changes without overwriting the original.
2. In the fork options, make sure "**Copy the `main` branch only**" is unchecked so the `Dev` branch is included.
3. In GitHub Desktop, choose `File -> Clone repository` and select your fork.
   A clone is the copy stored on your computer.
4. Choose a local folder for the clone, ideally the Steam Mods folder.
   A typical Steam path for the game is
   ```
   C:\Program Files (x86)\Steam\steamapps\common\Star Wars Empire at War\corruption\Mods\Project-Proteus
   ```
   > Your Steam library may be in a different location.
5. In GitHub Desktop, switch to the `Dev` branch before editing.

### Test a local copy in game

For a local clone, replace the published Proteus Workshop ID with the local mod:
```
ModPath=Mods/Project-Proteus STEAMMOD=1125571106
```
The cloned folder must be named `Project-Proteus` and placed under the game's `Mods` directory for this path to work.

Edit files in the `Data` folder: `XML` for game definitions, `Scripts` for Lua, `Text` for game text, and `Art` or `Audio` for assets.

## Development workflow

### Make a change

Before starting, [Keep your fork current](#keep-your-fork-current) so your `Dev` branch is up to date.

1. With `Dev` selected, choose `Branch -> New branch` to create a working branch, a separate place for your change.
   Give it a short name that describes the change, such as `fix-ship-description`.
2. Make a focused change and follow the same patterns used in the files.
   Ask on Discord if you are unsure about the correct approach.
3. Commit your change in GitHub Desktop with a short descriptive message, such as `Fix missing ship description`.
   A commit is a saved change set in your local Git history.
   Choose **Commit to** your working branch.
4. Test the change in game before marking it ready for review.
   Make a note of the scenario you tested and the result.

### Open a pull request

Pushing uploads your branch to your fork, and a **pull request** asks the maintainers to merge it.

1. In GitHub Desktop, review the commits and changed files.
2. Choose **Push origin** or **Publish branch** to upload your working branch to your fork.
3. Choose **Create Pull Request** and check that the pull request targets `TaxEvader6686/Project-Proteus` and its `Dev` branch, not `main`.
4. Explain what changed and why.
   Link any related issue with `#` followed by the issue number.
   For visible changes, add a screenshot when useful.

**WARNING : Do not include changed/compiled binary archives commits in your PR (e.g .mtd file, .dat file).**

## Maintenance workflow

### Keep your fork current

Over time your fork may fall behind the original repository.
Bring your `Dev` branch up to date before starting a new change.

1. On GitHub, open your fork, select its `Dev` branch, choose **Sync fork**, then **Update branch**.
2. In GitHub Desktop, switch to the `Dev` branch, select **Fetch origin**, then **Pull origin** if offered.

### Merging updates

While you work, other contributors may update `Dev`.
**Merging** allows you to combine those changes into your working branch.

1. [Keep your fork current](#keep-your-fork-current) to update your local `Dev` branch.
2. In GitHub Desktop, switch to your working branch.
3. Choose `Branch -> Merge into current branch`, then select `Dev`.
4. If the merge succeeds, test your changes and push your branch.

### Resolving merge conflicts

A **merge conflict** occurs when Git cannot automatically combine changes, usually because two contributors edited the same part of a file.

> **Do not blindly overwrite changes.**
> Accepting one version may discard the work of another contributor.
> If an update reports a conflict you do not understand, stop and ask for help on Discord.

1. In GitHub Desktop, open the conflicted files in VS Code.
2. Review the highlighted differences and choose which changes to keep, or combine both.
3. Save the files and complete the merge in GitHub Desktop.
4. Test your changes in game, then push your branch.

> Even if Git merges successfully, XML or Lua changes may still conflict logically.
> Always test affected features in game.
