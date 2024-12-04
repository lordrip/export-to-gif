# export-to-gif
A simple script using `ffmpeg` to export an MP4 file to a GIF

### Usage
```sh
$ export-to-gif.sh -i input.mp4 -o output.gif [--fps N] [--verbose]
```

### Usage batch mode
```sh
$ for file in *.mp4; do ./export-to-gif.sh -i "$file" -o "${file%.mp4}.gif"; done
```

### Options:
| flag        | description           | default       |
| ---         | ---                   | ---           |
| `-i`        | Input video file      |               |
| `-o`        | Output GIF file       |               |
| `--fps`     | Set the frame rate    | `10`          |
| `--verbose` | Print FFmpeg commands | `false`       |
