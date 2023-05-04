#version 300 es
#extension GL_EXT_shader_non_constant_global_initializers:enable

precision highp float;

const float STRENGTH = 0.4; // 0.0 = no effect, 1.0 = full effect
const float SATURATION = 0.9; // Color saturation (0.0 = grayscale, 1.0 = full color)
const float LIGHTNESS = 0.65; // Color lightness (0.0 = black, 1.0 = white)
 
uniform vec2 resolution;  // Size of the canvas
uniform vec2 offset;     // Additional offset of the effect
uniform sampler2D tSource; // Input texture (the application canvas)

out vec4 fragColor;

vec4 rainbowEffect(vec2 uv) {
    vec4 srcColor = texture(tSource, uv);
    float hue = uv.x / (1.75 + abs(offset.x)) + offset.x / 3.0;
    float lightness = LIGHTNESS + 0.25 * (0.5 + offset.y * (0.5 - uv.y));
    hue = fract(hue);

    float c = (1.0 - abs(2.0 * lightness - 1.0)) * SATURATION;
    float x = c * (1.0 - abs(mod(hue / (1.0 / 6.0), 2.0) - 1.0));
    float m = LIGHTNESS - c / 2.0;

    vec3 rainbowPrime;

    if (hue < 1.0 / 6.0) {
        rainbowPrime = vec3(c, x, 0.0);
    } else if (hue < 1.0 / 3.0) {
        rainbowPrime = vec3(x, c, 0.0);
    } else if (hue < 0.5) {
        rainbowPrime = vec3(0.0, c, x);
    } else if (hue < 2.0 / 3.0) {
        rainbowPrime = vec3(0.0, x, c);
    } else if (hue < 5.0 / 6.0) {
        rainbowPrime = vec3(x, 0.0, c);
    } else {
        rainbowPrime = vec3(c, 0.0, x);
    }

    vec3 rainbow = rainbowPrime + m;
    return mix(srcColor, vec4(rainbow, srcColor.a), STRENGTH);
}

vec4 chromaticAberration(vec2 uv) {
    vec4 srcColor = rainbowEffect(uv);
    vec2 shift = offset * vec2(3.0, 5.0) / 1000.0;

    vec4 leftColor = rainbowEffect(uv - shift);
    vec4 rightColor = rainbowEffect(uv + shift);

    return vec4(rightColor.r, srcColor.g, leftColor.b, srcColor.a);
}

void main() {
    vec2 pos = gl_FragCoord.xy;
    vec2 uv = pos / resolution;
    fragColor = chromaticAberration(uv);
}

