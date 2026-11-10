# Contributing

This guide covers safe workflows for proposing changes to the Project Proteus `Dev` branch.

## Index

- [Before you start](#before-you-start)
- [GitHub Issues](#github-issues)
- [Tools](#tools)
- [One time setup](#one-time-setup)
- [Development workflow](#development-workflow)
- [Maintenance workflow](#maintenance-workflow)
- [Command-line workflow](#command-line-workflow) (advanced)

## Before you start

- Join the [Project Discord](https://discord.gg/HrDPn9vcuN) to discuss your idea and get help.
- Check [GitHub Issues](https://github.com/TaxEvader6686/Project-Proteus/issues) for existing reports or plans.
- Before editing a warlord group, check the
  [group ownership document](https://docs.google.com/document/d/1kTn2ChBXyPefAGgiAWkms-F-psZa9NI5PI5U2Ns8ftU)
  and coordinate changes with the group owner on Discord.
- Vacant warlord groups that you can claim can be found in
  [Suggestions](https://docs.google.com/document/d/1kTn2ChBXyPefAGgiAWkms-F-psZa9NI5PI5U2Ns8ftU/edit?tab=t.nok4xvbwulrm)
  (please try to use the groups on the upper lists first).

## GitHub Issues

Issues track bugs, ideas, and tasks in the original project.

1. Sign in to GitHub and open [Project Proteus Issues](https://github.com/TaxEvader6686/Project-Proteus/issues).
2. Search for an existing issue first.
   If one already covers your report or idea, comment on it and add any new details there.
3. Otherwise, choose **New issue** with a template if available, or a blank issue.
4. Give it a clear title, describe the report or plan, then submit.

> GitHub allows you to edit issues after submission, so you can add more details later.

### Write good issues

- For bugs: include mod info (version, faction, group, era, map), how to reproduce the issue, what you expected, and what happened instead.
  Screenshots and logs can help.
- For enhancements: explain the problem, your proposed change, and its benefit.
- Reference related issues or pull requests with `#` followed by their number, such as `#123`.
- For task/todo lists, put each item on its own line, starting with `- [ ]` for an open task or `- [x]` for a completed task.

> **Tip:** Keep progress in the GitHub issue and link any relevant Discord discussions.

## Tools

### GitHub Desktop

GitHub Desktop is the recommended way to follow this guide if you are new to Git.
Install [GitHub Desktop](https://desktop.github.com/) and sign in with your [GitHub account](https://github.com/signup).
Also see the official guide for
[Getting Started with GitHub Desktop](https://docs.github.com/en/desktop/overview/getting-started-with-github-desktop).

On Windows, you can install it from PowerShell instead of manually downloading it:
```powershell
winget install --id GitHub.GitHubDesktop
```

> Native Git, GitHub CLI, or VS Code's Git tools can replace GitHub Desktop if you already use them.
> However, the rest of this guide is tailored for GitHub Desktop and VS Code.

Prefer CLI commands? See the [Command-line workflow](#command-line-workflow) section.

### Text Editors

Use a text editor to edit `xml`, `lua`, and other text-based files.

- [Visual Studio Code](https://code.visualstudio.com/) is highly recommended because of the extensions available.
- [Notepad++](https://notepad-plus-plus.org/) is a lightweight alternative for simple edits.

On Windows, install either editor from PowerShell if you prefer:
```powershell
winget install --id Microsoft.VisualStudioCode
```
```powershell
winget install --id Notepad++.Notepad++
```

When using VS Code, installing **extensions** can help with XML and Lua 5.0 editing.
They provide quality-of-life features like syntax highlighting, code completion, and error checking.

**VS Code Extensions:**
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) is popular for VS Code.
- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) by sumneko is a universal Lua Language Server.
- [pg-starwarsgame-lsp](https://github.com/AlamoEngine-Tools/pg-starwarsgame-lsp) is a custom language server made specifically for EaW.

> Having multiple language servers active at the same time may conflict in some cases.

### References

- [Lua 5.0 Reference Manual](https://www.lua.org/manual/5.0) for language syntax and standard functions.
- [EaWX Lua Coding Guidelines](https://github.com/SvenMarcus/eawx-lua-coding-guidelines) for recommended coding conventions.

### Additional Tools

- [Petroglyph Mod Tool](https://www.petroglyphgames.com/eawmodtool/index.html) page has the **Debug build**, terrain editor, and shader source files.
- [AlamoEngine-Tools](https://github.com/AlamoEngine-Tools) hosts unofficial modding tools for Petroglyph's Alamo and GlyphX Engines.
- [GlyphXTools](https://github.com/GlyphXTools) is another collection of [mod tools](https://modtools.petrolution.net/) for Petroglyph's GlyphX engine.
- [TilotnyStudio](https://github.com/Vardamir117/TilotnyStudio/releases) is an experimental graphical editor for common EaWX modding tasks.
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

## Development workflow

### Make a change

Before starting, [Keep your fork current](#keep-your-fork-current) so your `Dev` branch is up to date.

1. With `Dev` selected, choose `Branch -> New branch` to create a working branch, a separate place for your change.
   Give it a short name that describes the change, such as `fix-ship-description`.
2. Make a focused change and follow the same patterns used in the files.
   Ask on Discord if you are unsure about the correct approach or [where to edit files](#where-to-edit-files).
3. Stage and commit your change in GitHub Desktop with a short descriptive message, such as `Fix missing ship description`.
   A commit is a saved change set in your local Git history.
   Choose **Commit to** your working branch.
4. Test the change in game before marking it ready for review.
   Make a note of the scenario you tested and the result.

See the official GitHub guide for more details on
[Committing and reviewing changes](https://docs.github.com/en/desktop/making-changes-in-a-branch/committing-and-reviewing-changes-to-your-project-in-github-desktop).

### Where to edit files

Submod files live in the `Data/` folder:
- `Art` for models, textures, and icons
- `Audio` and `XML/SFX/SFXEvents_TR.xml` for sound events
- `Scripts` for Lua
- `XML` for game definitions
- `Text` or `ShipNames` for game text, especially `Submod_text.txt`

**WARNING: Do not include changed/compiled binary archives (.mtd, .dat) in your commits!**

For text changes to appear in the game, run `Text/alphabetize-and-build.bat` to update the `MasterTextFile_ENGLISH.dat` file.

For icons to appear in the game, run `Art/MTDEditor.exe` to import new icons into the `Textures/MT_commandbar.MTD` file.

### Open a pull request

Pushing uploads your branch to your fork, and a **pull request** asks the maintainers to merge it.

1. In GitHub Desktop, review the commits and changed files.
2. Choose **Push origin** or **Publish branch** to upload your working branch to your fork.
3. Choose **Create Pull Request** and check that the pull request targets `TaxEvader6686/Project-Proteus` and its `Dev` branch, **not** `main`.
4. Explain what changed, why, and how you tested/validated it.
   Link any related issue with `#` followed by the issue number.
   For visible changes, add a screenshot when useful.

See the official GitHub guide for more details on
[Creating an issue or pull request](https://docs.github.com/en/desktop/working-with-your-remote-repository-on-github-or-github-enterprise/creating-an-issue-or-pull-request-from-github-desktop).

## Maintenance workflow

### Keep your fork current

Over time your fork may fall behind the original repository.
Bring your `Dev` branch up to date before starting a new change.

1. On GitHub, open your fork, select its `Dev` branch, choose **Sync fork**, then **Update branch**.
2. In GitHub Desktop, switch to the `Dev` branch, select **Fetch origin**, then **Pull origin**.

See the official GitHub guide for more details on
[Syncing your branch](https://docs.github.com/en/desktop/working-with-your-remote-repository-on-github-or-github-enterprise/syncing-your-branch-in-github-desktop).

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

## Command-line workflow

Experienced contributors can use [Git](https://git-scm.com/) and [GitHub CLI](https://cli.github.com/).

On Windows, install Git and GitHub CLI from PowerShell:
```powershell
winget install --id Git.Git
winget install --id GitHub.cli
```

> Reopen the terminal before using `gh` and `git`.
> If a command says "your-something", replace it with the actual value.

### One-time setup

Authenticate with GitHub, fork the repository, and clone your fork:
```bash
gh auth login
gh auth status
gh repo fork TaxEvader6686/Project-Proteus --clone
cd Project-Proteus
git remote -v
```

Ensure the repository has two remotes:
- `origin`: Your fork.
- `upstream`: The original Project Proteus repository.

If `upstream` is missing, add it:
```bash
git remote add upstream https://github.com/TaxEvader6686/Project-Proteus.git
```

### GitHub Issues

To look for existing issues before opening a new one:
```bash
gh issue list --repo TaxEvader6686/Project-Proteus
```

To create an issue interactively:
```bash
gh issue create --repo TaxEvader6686/Project-Proteus
```

### Syncing your fork

From your cloned fork's folder, synchronize its `Dev` branch with the original repository:
```bash
gh repo sync --branch Dev
git fetch upstream
git switch Dev
git pull --ff-only origin Dev
```

See [Resetting your branch](#resetting-your-branch) if it diverges from `upstream/Dev`.

### Development workflow

Create a new working branch based on `origin/Dev`:
```bash
git fetch origin
git switch -c your-branch-name origin/Dev
```

Commit and push changes:
```bash
git status
git diff
git add your-changed-files
git commit -m "Commit message describing the change"
git push -u origin HEAD
```

Open a pull request targeting the upstream `Dev` branch:
```bash
gh pr create --repo TaxEvader6686/Project-Proteus --base Dev --fill
```

> Include the reason for the change and your in-game test results in the pull request description.

### Merging updates

First follow [Syncing your fork](#syncing-your-fork) to update your local `Dev` branch.
Then bring those changes into your working branch:
```bash
git switch your-branch-name
git merge Dev
git push
```

If a merge reports conflicts, inspect the affected files:
```bash
git status
git diff
```

Resolve the conflicting sections manually or using your editor's merge tools.
Then complete the merge:
```bash
git add your-changed-files
git merge --continue
```

To cancel an unresolved merge instead:
```bash
git merge --abort
```

### Rebasing updates

**WARNING: This rewrites the branch git history!**
Do not use it on a branch others are also using.

To reapply your commits on top of the latest `origin/Dev`:
```bash
git switch Dev
git pull --ff-only origin Dev
git switch your-branch-name
git rebase Dev
```

> If you already pushed this branch, update your fork with `git push --force-with-lease`.
> Never use `--force` unless you understand the consequences (it can discard remote commits).

To cancel an unresolved rebase instead:
```bash
git rebase --abort
```

### Resetting your branch

**WARNING: This can delete your own git history!**
Save any work you want to keep in a separate branch first:
```bash
git switch -c your-new-branch-name
```

To reset your `origin/Dev` branch to exactly match the `upstream/Dev` branch:
```bash
git fetch upstream
git fetch origin
git switch Dev
git reset --hard upstream/Dev
git push --force-with-lease origin Dev
```
