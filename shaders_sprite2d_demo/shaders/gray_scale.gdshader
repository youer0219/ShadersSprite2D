shader_type canvas_item;

uniform float gray_scale: hint_range(0.0, 1.0) = 1.0;
uniform float texture_alpha: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	float color_average = (input_color.r + input_color.g + input_color.b) / 3.0;

	float percentage = 1.0 - gray_scale;
	COLOR.r = color_average * gray_scale + COLOR.r * percentage;
	COLOR.g = color_average * gray_scale + COLOR.g * percentage;
	COLOR.b = color_average * gray_scale + COLOR.b * percentage;
	COLOR.a = input_color.a * texture_alpha;
}
