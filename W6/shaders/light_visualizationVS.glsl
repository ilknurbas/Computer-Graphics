#version 460

uniform mat4 viewproj;
uniform mat4 geo;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec3 color;

out vec3 fragNormal;
out vec3 fragPos;
out vec3 fragColor;


void main() {
   
   fragNormal =  normal;
   gl_Position = geo * vec4(pos, 1);
   fragPos = gl_Position.xyz;
   gl_Position = viewproj * gl_Position;   
   
   fragColor = color;
  
}
