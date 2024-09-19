#version 460

// This is metalic object, only 1st question implemented according to it.

uniform mat4 viewproj;
uniform mat4 matGeo;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texture_coord;

out vec4 fragPosition;
out vec3 fragNormal;
out vec2 fragTexture;
 


void main() {

   fragNormal = normal;
   fragTexture = texture_coord;
 
   gl_Position = matGeo * vec4(pos, 1);
   fragPosition = gl_Position;
   gl_Position = viewproj * gl_Position;
}
