shader_type canvas_item;
render_mode blend_add;

uniform float Frequency1 = 20.0;
uniform float Speed1 = 5.0;
uniform float Frequency2 = 12.0;
uniform float Speed2 = 2.0;
uniform float FallOff = 5.0;
uniform float Strength = 0.5;
uniform float Distortion = 0.02;

void fragment() {

    vec2 center = vec2(0.5,0.5);
    vec2 uv_centered = UV - center;

    float d = length(uv_centered);

    float distortion = sin(6.0 + TIME) * Distortion;

    float d2 = d + distortion;

    float wave1 = sin(d2 * Frequency1 - TIME * Speed1) * 1.4;
    float wave2 = sin(d2 * Frequency2 - TIME * Speed2) * 0.5;

    float ripple = (wave1 + wave2) * Strength;

    ripple *= 1.0 / (1.0 + d * FallOff);

    ripple = ripple * 0.5 + 0.5;

    // soften the sprite edge
    float edge = smoothstep(0.5, 0.35, d);
    ripple *= edge;
	float levels = 12.0;
	ripple = floor(ripple * levels) / levels;
    COLOR.a = ripple;
}