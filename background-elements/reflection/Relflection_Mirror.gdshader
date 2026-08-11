shader_type canvas_item;
uniform vec4 CAST_COlOR : source_color;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform sampler2D fast_noise : repeat_enable;

uniform float wave_stength = 2.0;
uniform vec2 speed = vec2(0.03, 0.07);
uniform float scale_y;
uniform float y_zoom=5.0;




void fragment() { 
	vec2 uv = UV + speed + TIME;
	vec2 noise = texture(fast_noise, uv).rg;
	
	float uv_height = (SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y);
	vec2 reflected_uv = vec2(SCREEN_UV.x, SCREEN_UV.y - (uv_height * UV.y * scale_y * y_zoom));
	vec4 reflection = texture(SCREEN_TEXTURE, reflected_uv);
	
	vec4 waves = texture(SCREEN_TEXTURE, reflected_uv + noise * y_zoom * (wave_stength / 1500.0));
	
	COLOR = waves + CAST_COlOR;	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
