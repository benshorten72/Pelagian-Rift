shader_type canvas_item;
render_mode blend_mix;
uniform int frames = 11;
uniform float fps = 8.0;
uniform float repeats = 8.0;

void fragment() {
    int frame = int(mod(floor(TIME * fps), float(frames)));
    vec2 uv = UV;
 	uv.x = fract(uv.x * repeats);

    uv.x = (uv.x + float(frame)) / float(frames);
    COLOR = texture(TEXTURE, uv);
}