#version 460

uniform mat4 viewproj;
uniform mat4 view;
uniform mat4 proj;
uniform mat4 geo;

layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 nor;

out vec3 fragNormal;
out vec4 fragPosition;

const int numInstances = 12;

uniform vec2 view_port_size; 
uniform vec3 camera_pos;

// Q1
mat4 rotateX(float angle_deg) {
    float angle_radians = radians(angle_deg);
    mat4 rotateXmatrix; // column by column
    rotateXmatrix[0] = vec4(1.0, 0.0, 0.0, 0.0);
    rotateXmatrix[1] = vec4(0.0, cos(angle_radians), sin(angle_radians), 0.0);
    rotateXmatrix[2] = vec4(0.0, -sin(angle_radians), cos(angle_radians), 0.0);
    rotateXmatrix[3] = vec4(0.0, 0.0, 0.0, 1.0);
    
    return rotateXmatrix;
}

mat4 rotateY(float angle_deg) {
    float angle_radians = radians(angle_deg);
    mat4 rotateYmatrix; // column by column
    rotateYmatrix[0] = vec4(cos(angle_radians), 0.0, -sin(angle_radians), 0.0);
    rotateYmatrix[1] = vec4(0.0, 1.0, 0.0, 0.0);
    rotateYmatrix[2] = vec4(sin(angle_radians), 0.0, cos(angle_radians), 0.0);
    rotateYmatrix[3] = vec4(0.0, 0.0, 0.0, 1.0);
    
    return rotateYmatrix;
}

mat4 rotateZ(float angle_deg) {
    float angle_radians = radians(angle_deg);
    mat4 rotateZmatrix; // column by column
    rotateZmatrix[0] = vec4(cos(angle_radians),sin(angle_radians), 0.0, 0.0);
    rotateZmatrix[1] = vec4(-sin(angle_radians), cos(angle_radians), 0.0, 0.0);
    rotateZmatrix[2] = vec4(0.0, 0.0, 1.0, 0.0);
    rotateZmatrix[3] = vec4(0.0, 0.0, 0.0, 1.0);
    
    return rotateZmatrix;
}

mat4 translate(float tx, float ty, float tz) {
    mat4 translatematrix;
    translatematrix[0] = vec4(1.0, 0.0, 0.0, 0.0) ; 
    translatematrix[1] = vec4(0.0, 1.0, 0.0, 0.0) ; 
    translatematrix[2] = vec4(0.0, 0.0, 1.0, 0.0) ; 
    translatematrix[3] = vec4(tx, ty, tz, 1.0) ; 
    
    return translatematrix;
}

mat4 scale(float sx, float sy, float sz) {
	mat4 scalematrix;
    scalematrix[0] = vec4(sx, 0.0, 0.0, 0.0) ; 
    scalematrix[1] = vec4(0.0, sy, 0.0, 0.0) ; 
    scalematrix[2] = vec4(0.0, 0.0, sz, 0.0) ; 
    scalematrix[3] = vec4(0.0, 0.0, 0.0, 1.0) ; 
    
    return scalematrix;
     
}

void main() {
   	
   	// BONUS 1
	float aspect_ratio = view_port_size.x / view_port_size.y;
	float nearPlane = 0.1;
    float farPlane = 1000.0;
    float field_of_view = radians(50.0);
 	
    mat4 bonus1_proj_matrix ;
    bonus1_proj_matrix[0] = vec4(1.0 / (aspect_ratio * tan(field_of_view / 2.0)), 0.0, 0.0, 0.0) ; 
    bonus1_proj_matrix[1] = vec4(0.0, (1.0 / tan(field_of_view / 2.0)), 0.0, 0.0) ; 
    bonus1_proj_matrix[2] = vec4(0.0, 0.0, -(farPlane + nearPlane) / (farPlane - nearPlane), -1.0) ; 
    bonus1_proj_matrix[3] = vec4(0.0, 0.0,  -(2.0 * farPlane * nearPlane) / (farPlane - nearPlane), 0.0) ; 
  
    
    // BONUS 2
    mat4 bonus2_view_matrix = mat4(1.0);
    vec3 forward = camera_pos; 
    vec3 Z = normalize(forward);
    vec3 up = vec3(0.0, 1.0, .0);
    vec3 X = normalize(cross(up, Z));
    vec3 Y = cross(Z, X); 
    
    bonus2_view_matrix[0] = vec4(X, 0.0) ; 
    bonus2_view_matrix[1] = vec4(Y, 0.0) ; 
    bonus2_view_matrix[2] = vec4(Z, 0.0) ; 
    bonus2_view_matrix[3] = vec4(0.0, 0.0, 0.0, 1.0);
    bonus2_view_matrix = inverse(bonus2_view_matrix);
   	
    bonus2_view_matrix[3][0] = -dot(X, camera_pos);
	bonus2_view_matrix[3][1] = -dot(Y, camera_pos);
	bonus2_view_matrix[3][2] = -dot(Z, camera_pos);
    
   
   	// Q2
   	int instance_id = gl_InstanceID;
   
   	// circle pattern 
   	// rotation
   	// decide the angle of each house as they are in circular
   	float angle_deg = 360.0 * float(instance_id)/float(numInstances);
   	mat4 rotation_matrix = rotateY(180.0 - angle_deg);
   
   	// translation
   	// y coord is constant as replace houses on ground in a sense
   	float radius = 15.0;
   	float tx = radius * cos(radians(angle_deg));
   	float tz = radius * sin(radians(angle_deg));
   	mat4 translation_matrix = translate(tx, 0.0, tz);
   
    // scale, uniform scaling
   	float sx = 2.0;
   	float sy = 2.0;
   	float sz = 2.0;
   	mat4 scale_matrix = scale(sx, sy, sz);
   
   	mat4 transformation_matrix = translation_matrix * rotation_matrix * scale_matrix ; 
   	
 	// uncomment if wanna use pre-built matrices and comment below initializations
   	//fragPosition =  transformation_matrix * vec4(pos, 1) ;
   	//gl_Position =  viewproj * transformation_matrix * vec4(pos, 1);
   	
   	// BONUS 1
   	// uncomment if wanna use self-made proj matrix and comment below initializations
   	//fragPosition =  transformation_matrix * vec4(pos, 1) ;
   	//gl_Position =  bonus1_proj_matrix  * view * transformation_matrix * vec4(pos, 1);
   	
   	// BONUS 2
   	// uncomment if wanna use self-made view matrix and comment below initializations
   	//fragPosition = transformation_matrix * vec4(pos, 1) ;
    //gl_Position =  proj  * bonus2_view_matrix * transformation_matrix * vec4(pos, 1);
   	  
    
   	// BONUS 1 + BONUS 2
    fragPosition =  transformation_matrix * vec4(pos, 1) ;
    gl_Position =  bonus1_proj_matrix  * bonus2_view_matrix * transformation_matrix * vec4(pos, 1);

   
   	// Q3
   	// uniform scaling
   	vec4 temp_normal_uni = transformation_matrix * vec4(nor, 0.0);
   	fragNormal = temp_normal_uni.xyz;
   
   	// non uniform scaling
   	vec4 temp_normal_non_uni = mat4(transpose(inverse(transformation_matrix))) * vec4(nor, 0.0) ;
   	fragNormal = temp_normal_non_uni.xyz ;
    
    fragNormal = normalize(temp_normal_non_uni).xyz;

}





