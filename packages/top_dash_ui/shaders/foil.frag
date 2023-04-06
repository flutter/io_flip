#version 300 es
#extension GL_EXT_shader_non_constant_global_initializers:enable

precision highp float;

float PI=3.1415926535897932384626433832795;

const float strength=.3;// 0. = no effect, 1. = full effect

// Float uniforms
uniform float width;// Width of the canvas
uniform float height;// Height of the canvas
uniform float dx;// Additional X offset of the effect
uniform float dy;// Additional Y offset of the effect

// Sampler uniforms
uniform sampler2D tSource;// Input texture (the application canvas)

out vec4 fragColor;

vec2 resolution=vec2(width,height);

vec4 fragment(vec2 uv,vec2 fragCoord){
	vec4 srcColor=texture(tSource,uv);
	float hue=uv.x+dx/2.+dy/3.+sin(uv.x*uv.y*PI*1.8);
	hue=fract(hue);
	float sat=.95;// Color saturation (0. = grayscale, 1. = full color)
	float light=.8;// Color lightness (0. = black, 1. = white)
	
	float c=(1.-abs(2.*light-1.))*sat;
	float x=c*(1.-abs(mod(hue/(1./6.),2.)-1.));
	float m=light-c/2.;
	
	vec3 rainbowPrime;
	if(hue<1./6.){
		rainbowPrime=vec3(c,x,0.);
	}else if(hue<1./3.){
		rainbowPrime=vec3(x,c,0);
	}else if(hue<.5){
		rainbowPrime=vec3(0,c,x);
	}else if(hue<2./3.){
		rainbowPrime=vec3(0.,x,c);
	}else if(hue<5./6.){
		rainbowPrime=vec3(x,0.,c);
	}else{
		rainbowPrime=vec3(c,0.,x);
	}
	vec3 rainbow=rainbowPrime+m;
	return mix(srcColor,vec4(rainbow,srcColor.a),strength);
}

void main(){
	vec2 pos=gl_FragCoord.xy;
	vec2 uv=pos/vec2(width,height);
	fragColor=fragment(uv,pos);
}

