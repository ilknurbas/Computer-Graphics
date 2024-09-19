#version 460

// Note that each fragColor = ... ; line outputs differently according
// to what it is asked in the assignment. Hence, un/comment when needed.

in vec3 fragNormal;
in vec3 fragPosition;
out vec4 fragColor;

const vec3 objectColor  = vec3(1.0, 1.0, 0.0); // yellow

// Q1 Ambient
const vec3 ambient_light = vec3(0.2, 0.2, 0.0);   
const vec3 ambient_reflectivity = vec3(0.1);

// Q2 Diffuse
const float diffuse_reflectivity = 0.8;
const vec3 light_color = vec3(1.0, 1.0, 1.0);
vec3 light_source_dir = vec3(3.0, 0.0, 0.0); 

// Q3 Specular 
// white for non metalic, metal color for metalic
const vec3 specular_reflectivity = vec3(1.0, 1.0, 0.0); 
const float shininess = 35;
uniform vec3 camera_pos;

// BONUS 2
//const vec3 point_light_pos = vec3(-40.0,40.0,0.0);
const vec3 point_light_pos = vec3(-40.0, 0.0,0.0);
vec3 point_light_color = vec3(1440.0,0.0,0.0); 
 
void main()
{
    // Q1 Ambient
	vec3 ambient = ambient_reflectivity * ambient_light; 
 	vec3 lighting = ambient;
 	
    fragColor  = vec4(lighting, 1.0);
     
    // Q2 Diffuse
    vec3 normal = normalize(fragNormal); 
    float temp = max(0.0, dot(normal, normalize(light_source_dir)));
    vec3 diffuse = diffuse_reflectivity * temp * light_color ;
    
    lighting = ambient + diffuse;
    // lighting = lighting * objectColor; // can be uncommented, gives color to the object 
    fragColor  = vec4(lighting, 1.0);
    
    // Q3 Specular 
    vec3 reflection = reflect(-normalize(light_source_dir), normal);
    vec3 view = normalize(camera_pos - fragPosition);
    temp = pow(max(0.0, dot(view, reflection)), shininess); 
    vec3 specular = specular_reflectivity * temp * light_color; 
    
    lighting = ambient + diffuse + specular;
    lighting = lighting * objectColor; // can be uncommented, gives color to the object
    fragColor  = vec4(lighting, 1.0);
    
    // BONUS 1
    vec3 temp_h = normalize(normalize(light_source_dir) + view);
    vec3 temp_n = normal;
    temp = pow(max(0.0, dot(temp_h, temp_n)), shininess);
    vec3 specular_bonus = specular_reflectivity * temp * light_color;
    
	lighting = ambient + diffuse + specular_bonus;
    lighting = lighting * objectColor; // can be uncommented, gives color to the object
    fragColor  = vec4(lighting, 1.0);
          
    // BONUS 2
    float distance_to_light = distance(point_light_pos, fragPosition);
    vec3 point_light_dir = normalize(point_light_pos - fragPosition);
    float scale = 1 / (distance_to_light *  distance_to_light);
    point_light_color = point_light_color * scale;
    
    // Diffuse   
    temp = max(0.0, dot(normal, point_light_dir));
    vec3 diffuse_bonus2 = diffuse_reflectivity * temp * point_light_color;
    
    lighting = ambient + diffuse + diffuse_bonus2 + specular;
    lighting = lighting * objectColor;
    fragColor  = vec4(lighting, 1.0);
    
    // Specular, according to the Blinn Phong
    temp_h = normalize(point_light_dir + view);
    temp_n = normal;
    temp = pow(max(0.0, dot(temp_h, temp_n)), shininess);
    vec3 specular_bonus_2 = specular_reflectivity * temp * point_light_color;
	
  	// only point light's contribution
    lighting = ambient + diffuse_bonus2 + specular_bonus_2;
    lighting = lighting * objectColor;
    fragColor  = vec4(lighting, 1.0);
    
    // both point light's and directional light's contribution
    lighting = ambient + diffuse + diffuse_bonus2 + specular + specular_bonus_2;
    lighting = lighting * objectColor;
    fragColor  = vec4(lighting, 1.0);
 
}
  
  
  
 