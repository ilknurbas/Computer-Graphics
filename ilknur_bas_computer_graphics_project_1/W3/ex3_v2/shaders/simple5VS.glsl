#version 460

// YOU CAN USE THIS SHADER FOR BONUS 1&2

layout (location = 0) in vec3 pos;  
layout(location = 2) in vec2 texcoord;

uniform mat4 viewproj;
uniform float uTime;

out vec2 fragTexCoord;  

mat4 translate(float tx, float ty, float tz) {
    mat4 translatematrix;
    translatematrix[0] = vec4(1.0, 0.0, 0.0, 0.0) ; 
    translatematrix[1] = vec4(0.0, 1.0, 0.0, 0.0) ; 
    translatematrix[2] = vec4(0.0, 0.0, 1.0, 0.0) ; 
    translatematrix[3] = vec4(tx, ty, tz, 1.0) ; 
    
    return translatematrix;
}

void main() {
 
   fragTexCoord = texcoord;
   
   // BONUS 1 
   float y_offset = 0.2 * cos(6.0 * pos.x + uTime); 
   vec3 displacement = pos + vec3( 0.0, 0.0, y_offset);
	
   mat4 transformation_matrix = translate(0.8, 0.6, 0.0);
   gl_Position = viewproj * transformation_matrix * vec4(displacement, 1.0);

}
