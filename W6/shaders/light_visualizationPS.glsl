#version 460
 
in vec3 fragNormal;
in vec3 fragPos;
in vec3 fragColor;
out vec4 outColor;




void main() {
	 
	vec3 normal = normalize(fragNormal);
	outColor = vec4(vec3(1.0), 1.0);
	
	
}