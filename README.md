# Embedding Directories into Executables

The `$embed_file()` call in V embeds only a single file. This module makes it
easy to embed entire directories into the final executable.

File embedding in V is done at compile time, and there is no way to dynamically
embed arbitrary files into an application. The `embedfs` module is a simple
code generator that creates a separate `.v` file with the code for embedding
files.

## Installation

```
v install https://github.com/gechandesu/embedfs
```

## Usage

For example you have following file structure:

```
./
├── src/
│   ├── assets/
│   │   ├── css/
│   │   │   └── style.css
│   │   └── js/
│   │       └── app.js
│   └── main.v
└── v.mod
```

Lets embed the `assets` directory.

Create `embed_assets.vsh` next to v.mod:

```v
#!/usr/bin/env v

import os
import embedfs

os.chdir('src')!
assets := embedfs.generate('assets')!
os.write_file('assets_generated.v', assets)!
```

Run it:

```
v run embed_assets.vsh
```

Now you have `src/assets_generated.v`. Take a look inside it:

```v
module main

const embed_files = {
        'assets/css/style.css': $embed_file('assets/css/style.css')
        'assets/js/app.js': $embed_file('assets/js/app.js')
}
```

You can use it in `src/main.v` in this way:

```v
module main

fn main() {
    style := unsafe { embed_files['assets/css/style.css'].to_string() }
    println(style)
}
```

The map type is `map[string]embed_file.EmbedFileData`, see the
[v.embed_file](https://modules.vlang.io/v.embed_file.html#EmbedFileData)
module docs for details.

## `bin2v` tool

Also there is `v bin2v` utility that generates the V modules with embedded
files. See:

```
v help bin2v
```

In contrast with embedfs, bin2v generates constants into which it writes
files as fixed-length byte arrays.
