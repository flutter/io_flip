#version 300 es
#extension GL_EXT_shader_non_constant_global_initializers:enable

precision highp float;

const float PI = 3.1415926535897932384626433832795;
const float STRENGTH = 0.3; // 0.0 = no effect, 1.0 = full effect
const float SATURATION = 0.95; // Color saturation (0.0 = grayscale, 1.0 = full color)
const float LIGHTNESS = 0.8; // Color lightness (0.0 = black, 1.0 = white)
 
// Float uniforms
uniform float width;  // Width of the canvas
uniform float height; // Height of the canvas
uniform float dx;     // Additional X offset of the effect
uniform float dy;     // Additional Y offset of the effect

// Sampler uniforms
uniform sampler2D tSource; // Input texture (the application canvas)

out vec4 fragColor;

vec2 resolution = vec2(width, height);

vec4 rainbowEffect(vec2 uv) {
    vec4 srcColor = texture(tSource, uv);
    float hue = uv.x + dx / 4.0 + dy / 6.0 + sin((uv.x - 3.0) * (uv.y + 2.0) * 1.8);
    hue = fract(hue);

    float c = (1.0 - abs(2.0 * LIGHTNESS - 1.0)) * SATURATION;
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
    float shift = 3.0 / 1000.0 * dx;
    float verticalShift = 5.0 / 1000.0 * dy; 

    float shiftLeft = clamp(uv.x - shift, 0.0, 1.0);
    float shiftRight = clamp(uv.x + shift, 0.0, 1.0);
    float shiftUp = clamp(uv.y - verticalShift, 0.0, 1.0);
    float shiftDown = clamp(uv.y + verticalShift, 0.0, 1.0);
    vec4 lc = rainbowEffect(vec2(shiftLeft, shiftUp));
    vec4 rc = rainbowEffect(vec2(shiftRight, shiftDown));

    return vec4(rc.r, srcColor.g, lc.b, srcColor.a);
}

void main() {
    vec2 pos = gl_FragCoord.xy;
    vec2 uv = pos / vec2(width, height);
    fragColor = chromaticAberration(uv);
}

