shader_type canvas_item;
render_mode blend_mix;
uniform int frames = 11;
uniform float fps = 12.0;
uniform float repeats = 8.0;
uniform float start_time = 0.0;
void fragment() {
	float t = TIME - start_time;
    int frame = int(mod(floor(t * fps), float(frames)));
    vec2 uv = UV;
 	uv.x = fract(uv.x * repeats);

    uv.x = (uv.x + float(frame)) / float(frames);
    COLOR = texture(TEXTURE, uv);
}