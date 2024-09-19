#version 460

// This is non-metalic object, all parts are implemented.

uniform mat4 viewproj;
uniform mat4 matGeo;
uniform mat4 geo;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 texture_coord;
layout (location = 3) in vec3 tangent;

out vec4 fragPosition;
out vec3 fragNormal;
out vec2 fragTexture;
out vec3 fragTangent;


void main() {

  
   fragNormal = normal;
   fragTexture = texture_coord;
   fragTangent = tangent;
    
   gl_Position = geo * vec4(pos, 1);
   fragPosition = gl_Position;
   gl_Position = viewproj * gl_Position;
   
   
   
}
