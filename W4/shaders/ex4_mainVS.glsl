#version 460

uniform mat4 viewproj;
uniform mat4 geo;
layout(location = 0) in vec3 in_pos;  
layout(location = 1) in vec3 in_normal; 

out vec3 fragNormal;
out vec3 fragPosition;
 

void main() {
 
	// gl_Position = viewproj * vec4(in_pos, 1.0);  
	// fragPosition = gl_Position.xyz;
	
	fragNormal = in_normal;
	
	gl_Position = geo * vec4(in_pos, 1);
    fragPosition = gl_Position.xyz;
    gl_Position = viewproj * gl_Position;

}