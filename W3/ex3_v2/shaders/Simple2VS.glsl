#version 460
// YOU CAN USE THIS SHADER FOR QUESTIONS 4-5-6

uniform mat4 viewproj;
layout (location = 0) in vec3 in_pos;
layout (location = 1) in vec3 in_normal; 

out vec3 out_normal;

void main()
{
	// Q4-5
	gl_Position = viewproj * vec4(in_pos, 1.0);
	
	// Q6
	out_normal = in_normal;
	
}