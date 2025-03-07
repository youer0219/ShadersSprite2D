// from：   https://godotshaders.com/shader/doom-like-melting-screen/
// author： https://godotshaders.com/author/shader_kitten/
/*
DOOM Melting Screen-like shader!
*/
shader_type canvas_item;

uniform uint subdivisions = 2; // How many subdivisions
uniform float movement: hint_range(0.0, 1.0, 0.01); // Control for animation

// Random and noise code from godotshaders.com
vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), uv_fract.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), uv_fract.x), uv_fract.y) + 0.5;
}


void fragment() {
	// Get how much to offset based on noise
	float offset = max(noise(vec2(UV.x / (TEXTURE_PIXEL_SIZE.x * float(uint(textureSize(TEXTURE, 0).x) / subdivisions)), 1.0)), 0.0);
	// Offset column
	float col = UV.y - (movement + offset) * movement;
	 COLOR = vec4(texture(TEXTURE, vec2(UV.x, col)).rgb, step(0.0, col));
}
