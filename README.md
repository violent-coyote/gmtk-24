# gmtk24 - theme "built to scale"

### trait tycoon

a game designer, searching for units for their upcoming hex based strategy game, discovers an island behind the pyramid. interact with the creatures to make the perfect units for playtesting!

### Exporting a build
to export for web, in the export config window, set the paths for custom packages to: 
```
web-tooling\export-templates\web_debug.zip
web-tooling\export-templates\web_release.zip
```

make sure to name the build output `index.html`,

and nest it inside a build output folder named something like `web` or `build`.

after successful export, the build output folder should have a number of files prefixed with `index`, and no others.

zip the build output folder and upload the archive to the itch page. 

### Running the web build locally (without the Godot editor open)
open a terminal window to your build output folder. from within the folder, run: 
`$ python ../web-tooling/server.py`

and then visit `localhost:8000` in either safari or a chromium-based browser (firefox currently broken)