#version 460
// YOU CAN USE THIS SHADER FOR QUESTIONS 1-2-3

layout (location = 0) in vec2 pos;
uniform float uTime; 
layout(location=0) out vec3 out_color;

void main() {
	// Q1
	gl_Position = vec4(pos, 0.0f, 1);
	
	// Q2 
	float shift = 0.5 + 0.7 * cos(uTime);
	vec2 shifted_pos = vec2(pos.x + shift, pos.y);
	gl_Position = vec4(shifted_pos, 0.0f, 1);
	 	 
	// Q3
	vec3 vertex_colors[3]; // triangle has 3 vertices
	vertex_colors[0] = vec3(1.0, 0.0, 0.0);  
    vertex_colors[1] = vec3(0.0, 1.0, 0.0); 
    vertex_colors[2] = vec3(0.0, 0.0, 1.0); 
    out_color = vertex_colors[gl_VertexID];

}
