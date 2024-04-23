shader_type canvas_item;

uniform vec2 uvscale;

void vertex() {
	UV = UV * uvscale;
	// Place fragment code here.
}
