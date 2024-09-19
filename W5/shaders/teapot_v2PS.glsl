#version 460

in vec3 fragNormal;
in vec4 fragPosition; 

out vec4 fragColor;

const vec3 objectColor  = vec3(1.0, 1.0, 0.0); // yellow

// Ambient
const vec3 ambient_light = vec3(0.2, 0.2, 0.0);   
const vec3 ambient_reflectivity = vec3(0.1);

// Diffuse
const float diffuse_reflectivity = 0.8;
const vec3 light_color = vec3(1.0, 1.0, 1.0);  
vec3 light_source_dir = vec3(3.0, 0.0, 0.0);  
 
// Specular 
// white for non metalic, metal color for metalic
const vec3 specular_reflectivity = vec3(1.0, 1.0, 0.0); 
const float shininess = 35;
uniform vec3 camera_pos;


void main() {

	// Q3 phong
	// Ambient
	vec3 ambient = ambient_reflectivity * ambient_light; 
 	vec3 lighting = ambient;

    fragColor  = vec4(lighting, 1.0);
    
    // Diffuse
    vec3 normal = normalize(fragNormal); 
    float temp = max(0.0, dot(normal, normalize(light_source_dir)));
    vec3 diffuse = diffuse_reflectivity * temp * light_color ;
    
 	lighting = ambient + diffuse;
    // lighting = lighting * objectColor; // can be uncommented, gives color to the object 
    fragColor  = vec4(lighting, 1.0);
    
    // Specular 
    vec3 reflection = reflect(-normalize(light_source_dir), normal);
    vec3 view = normalize(camera_pos - fragPosition.xyz);
    temp = pow(max(0.0, dot(view, reflection)), shininess);
    vec3 specular = specular_reflectivity * temp * light_color; 
  
	lighting = ambient + diffuse + specular;
    lighting = lighting * objectColor; // can be uncommented, gives color to the object
    fragColor  = vec4(lighting, 1.0);
    
   
}


