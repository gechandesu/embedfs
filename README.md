## Code generator for embedding directories with files into executables

The `$embed_file` statement in V embeds only a single file. This module makes
it easy to embed entire directories into the final executable.

File embedding in V is done at compile time, and unfortunately there is no way
to dynamically embed arbitrary files into an application. The `embedfs` module
is a simple code generator that creates a separate `.v` file with the code for
embedding files. That is, the embedfs call must be made before the code is
compiled. So embedfs is a build dependency.

```
v install --git https://github.com/gechandesu/embedfs
```

## Usage

For example you have following file structure:

```
v.mod
src/
    main.v
    assets/
        css/style.css
        js/app.js
```

Lets embed the `assets` directory.

Create `embed_assets.vsh` next to your v.mod:

```v
#!/usr/bin/env -S v

import embedfs

chdir('src')!
assets := embedfs.CodeGenerator{
    path: 'assets'
}
write_file('assets_generated.v', assets.generate())!
```

Run it:

```
v run embed_assets.vsh
```

Now you have `src/assets_generated.v`. Take a look inside it. So you can use
`embedfs` const in `src/main.v` in this way:

```v
module main

fn main() {
    style := embedfs.files['assets/css/style.css']!
    // If `bare_map` parameter is set to `true` use:
    // style := embedfs['assets/css/style.css']!
    println(style.data.to_string())
}
```

The generated `embedfs` const value example (from `tests/`):

```v okfmt
EmbedFileSystem{
    files: {'assets/example.json': EmbedFile{
        data: embed_file.EmbedFileData{ len: 22, path: "assets/example.json", apath: "", uncompressed: 846284 }
        meta: EmbedFileMetadata{
            key: 'assets/example.json'
            name: 'example.json'
            ext: 'json'
            mimetype: 'application/json'
        }
    }}
}
```

The generated const value if `bare_map` parameter is `true`:

```v okfmt
{'assets/example.json': EmbedFile{
    data: embed_file.EmbedFileData{ len: 22, path: "assets/example.json", apath: "", uncompressed: 845da4 }
    meta: EmbedFileMetadata{
        key: 'assets/example.json'
        name: 'example.json'
        ext: 'json'
        mimetype: 'application/json'
    }
}}
```
