module main

fn main() {
	println(embedfs)
	json_file := embedfs.files['assets/example.json'] or { EmbedFile{} }
	println(json_file.data.to_string().trim_space())
}
