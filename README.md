# Auto Patcher Template
🚀 Simple auto patcher which fetches remote version to check the needing of downloading new content.

**At the moment, it works only with windows, as it executes an `.exe` file.**

## How to use
Using [Godot](https://godotengine.org/) >= 3.X, one may change in [Autopatcher.gd](https://github.com/coelhucas/auto-patcher-template/blob/main/Scenes/AutoPatcher/AutoPatcher.gd) the following values:

`VERSION_FILE_URL` - an url to a text file containing the current remote version of your project, it'll compare against your local `version` file. [This](https://github.com/coelhucas/mp-game-pck/blob/master/version) is an example of how I use it.

`DOWNLOAD_URL` - an url to the file to be download and written on the system. Since I made this for my online Godot projects, I just place a link to the raw `.pck` file. [Here](https://github.com/coelhucas/mp-game-pck/blob/master/ORPG.pck?raw=true) an example.

`PROJECT_FILE_NAME` - name of the `.exe` file on the same folder to be opened after the update is complete. This string shouldn't contain the `.exe` extension.
