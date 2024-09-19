#version 460
// YOU CAN USE THIS SHADER FOR QUESTIONS 4-5-6

out vec4 outColor;
in vec3 out_normal;

void main()
{
	// Q4-5
	outColor = vec4(0.0, 1.0, 1.0 ,1.0);
	
	// Q6
	vec3 normalized = normalize(out_normal);
	vec3 scaled = 0.5 * (normalized + vec3(1.0));
	outColor = vec4(scaled, 1.0);
	
}