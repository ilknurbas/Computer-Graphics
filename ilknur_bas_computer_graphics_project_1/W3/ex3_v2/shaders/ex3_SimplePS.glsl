#version 460
// YOU CAN USE THIS SHADER FOR QUESTIONS 1-2-3

uniform vec2 uResolution;
uniform float uTime;
out vec4 outColor;
layout(location=0) in vec3 in_color;

void main()
{
	// Q1 - Q2
    vec2 uv = gl_FragCoord.xy/uResolution;
    outColor = vec4(0.5 + 0.5*cos(uTime+uv.yxy),1.0);
    
    // Q3
    outColor = vec4(in_color ,1.0);
    
}