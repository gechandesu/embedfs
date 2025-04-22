module main

fn main() {
	$if bare_map ? {
		json_file := embedfs['assets/example.json'] or { EmbedFile{} }
		println(json_file.data.to_string().trim_space())
	} $else {
		json_file := embedfs.files['assets/example.json'] or { EmbedFile{} }
		println(json_file.data.to_string().trim_space())
	}
}
