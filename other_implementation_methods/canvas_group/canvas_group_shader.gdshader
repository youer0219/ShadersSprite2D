shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// 震动参数
uniform float hit_effect : hint_range(0, 1) = 0.0;
uniform float shake_intensity = 10.0;

// 闪烁参数
uniform vec4 blink_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float blink_intensity : hint_range(0.0, 1.0) = 0.0;

// 颜色混合参数
uniform vec4 base_modulate : source_color = vec4(1.0);

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // 计算屏幕震动偏移
    vec2 uv_offset = vec2(0.0);
    if (hit_effect > 0.0) {
        float time = TIME * 30.0;
        vec2 random_offset = vec2(
            rand(vec2(time, 0.0)) * 2.0 - 1.0,
            rand(vec2(time, 10.0)) * 2.0 - 1.0
        );
        // 将像素偏移转换为UV空间
        vec2 tex_size = vec2(textureSize(screen_texture, 0));
        uv_offset = (random_offset * shake_intensity * hit_effect) / tex_size;
    }

    // 应用偏移后的UV采样
    vec4 c = textureLod(screen_texture, SCREEN_UV + uv_offset, 0.0);

    // 预乘Alpha处理
    if (c.a > 0.0001) {
        c.rgb /= c.a;
    }

    // 应用颜色混合
    c.rgba *= base_modulate.rgba;

    // 应用闪烁效果
    c = mix(c, blink_color, blink_intensity * c.a);

    // 重新预乘RGB
    c.rgb *= c.a;

    COLOR = c;
}
