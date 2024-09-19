#version 460
 
in vec3 fragNormal;
in vec3 fragPos;
in vec3 fragColor;
out vec4 outColor;

const vec3 objectColor  = vec3(0.5, 0.5, 0); // yellow

 // Ambient
const vec3 ambient_light = vec3(0.2, 0.2, 0.0);   
const vec3 ambient_reflectivity = vec3(0.2);

// Diffuse
const float diffuse_reflectivity = 0.8;
const vec3 light_color = vec3(1.0, 1.0, 1.0);
vec3 light_source_dir = vec3(1.0, 1.0, 1.0); 
 
// Specular 
// white for non metalic, metal color for metalic
const vec3 specular_reflectivity = vec3(1.0, 1.0, 1.0); 
const float shininess = 25;
uniform vec3 cameraPos;

// Q1
float fogDensity = 0.01; // 0 --> no attenuation, extinction coefficient 
vec3 c_fog =  vec3(0.5,0.6,0.7); // color and intensity of the fog

// Q2
const float gamma = 2.2;

vec3 lightning() {
   
	// Ambient
	vec3 ambient = ambient_reflectivity * ambient_light; 
    
    // Diffuse
    vec3 normal = normalize(fragNormal); 
    float temp = max(0.0, dot(normalize(light_source_dir), normal));
    vec3 diffuse = diffuse_reflectivity * temp * light_color;
    
    // Specular 
    vec3 reflection = reflect(-normalize(light_source_dir), normal);
    vec3 view = normalize(cameraPos - fragPos);
    temp = pow(max(0.0, dot(view, reflection)), shininess);
    vec3 specular = specular_reflectivity * temp * light_color; 

    vec3 lighting = ambient + 0.4 *  diffuse + 0.1 * specular;
    // vec3 lighting = ambient + diffuse +  specular;
    lighting = lighting * objectColor;
    return lighting.xyz;  

}

// Q3
vec3 non_uniform_density( in vec3  rgb,      // original color of the pixel
               in float distance, // camera to point distance
               in vec3  rayOri,   // camera position
               in vec3  rayDir )  // camera to point vector
{
	float b = 0.01;//
	float a = 0.02;
	
    float fogAmount = (a/b) * exp(-rayOri.y*b) * (1.0-exp( -distance*rayDir.y*b ))/rayDir.y;
    vec3  fogColor = vec3(0.5,0.6,0.7);
    return mix( rgb, fogColor, fogAmount);
}

void main() {
	 
	vec3 normal = normalize(fragNormal);

    // Q1
   	// fog factor f = exp(-ext*d)
   	float dist = length(fragPos - cameraPos);
   	float fogFactor = exp2(-fogDensity * dist);
	vec3 c_shaded = lightning();
	vec3 c_camera_q1 = (c_shaded * fogFactor) + (c_fog * (1.0 - fogFactor));
	outColor = vec4(c_camera_q1, 1.0);
	  
	// Q2
	c_camera_q1 = pow(c_camera_q1, vec3(1.0 / gamma)); 
	outColor = vec4(c_camera_q1, 1.0);
	 
	// Q3
	vec3 dist_vec = normalize(vec3(cameraPos-fragPos)); 
	vec3 c_camera_q3 = non_uniform_density(c_shaded, dist, cameraPos, dist_vec);
	outColor = vec4(c_camera_q3, 1.0);

   
    // BONUS 1
    vec3 spotlight_pos = vec3(0.0, 2.5, 1.0);
    vec3 spotlight_direction = normalize(vec3(0, -1, -2));
    vec3 spotlight_color = vec3(40.0, 40.0, 40.0); 
    float outerangle =  45;
    float innerangle = 5;
    vec3 light_vec_direction = normalize(spotlight_pos - fragPos);  
       
    float cos_angle = dot(spotlight_direction, -light_vec_direction);
    float falloff1 = cos_angle - cos(radians(outerangle)); 
	float falloff2 = cos(radians(innerangle)) - cos(radians(outerangle));
	float falloff = clamp(falloff1/falloff2, 0.0, 1.0);

    spotlight_color = spotlight_color * falloff * falloff;
    float distance_to_light = distance(spotlight_pos, fragPos); 
    float scale = 1 / (distance_to_light *  distance_to_light);
    spotlight_color = spotlight_color * scale;
 
    
    // Diffuse and Specular
    float temp = max(0.0, dot(light_vec_direction, normal));
    vec3 diffuse = temp * spotlight_color * diffuse_reflectivity;
    vec3 reflection = reflect(-(light_vec_direction), normal);
    vec3 view = normalize(cameraPos - fragPos);  
    temp = pow(max(0.0, dot(view, reflection)), shininess);
    vec3 specular = specular_reflectivity * temp * spotlight_color; 
    vec3 ambient = ambient_light * ambient_reflectivity; 
    vec3 lighting_bonus1 =   falloff * falloff * (diffuse + specular);
    

	fogDensity = 0.2;
   	fogFactor = exp(-fogDensity * distance_to_light);
    // c_camera = (lighting_bonus1 * fogFactor) + (c_fog * (1.0 - fogFactor)); 
    vec3 c_camera_bonus1 = mix((lighting_bonus1 + ambient) , c_fog, fogFactor);
	outColor = vec4(c_camera_bonus1, 1.0);
	  
	// Observe the outputs
	// outColor = vec4(c_camera_q1, 1.0); // uncomment for Q1-2
    // outColor = vec4(c_camera_q3, 1.0); // uncomment for Q3
    // outColor = vec4(c_camera_bonus1, 1.0); // uncomment for BONUS1
    
    //outColor = vec4(c_camera_q1 + c_camera_bonus1, 1.0); // uncomment for  Q1-2 & BONUS1
    outColor = vec4(c_camera_q3 + c_camera_bonus1, 1.0); // uncomment for Q3 & BONUS1
   
   
}