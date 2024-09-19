#version 460

// YOU CAN USE THIS SHADER FOR BONUS 1 

layout (location = 0) in vec3 in_pos;
uniform mat4 viewproj; 

uniform float uTime;

mat4 translate(float tx, float ty, float tz) {
    mat4 translatematrix;
    translatematrix[0] = vec4(1.0, 0.0, 0.0, 0.0) ; 
    translatematrix[1] = vec4(0.0, 1.0, 0.0, 0.0) ; 
    translatematrix[2] = vec4(0.0, 0.0, 1.0, 0.0) ; 
    translatematrix[3] = vec4(tx, ty, tz, 1.0) ; 
    
    return translatematrix;
}

void main() {
	
	// BONUS 1
    float offset1 = 0.3 * cos( radians(107.0) * in_pos.x  + uTime); 
    float offset2 = 0.5 * sin( radians(107.0) * in_pos.y  + uTime); 
    vec3 displacement = in_pos + vec3(0.0,  0.0, offset2 + offset1);
   
   	mat4 transformation_matrix = translate(0.4, 0.0, 2.0);
    gl_Position = viewproj * transformation_matrix * vec4(displacement, 1.0);
	
}
