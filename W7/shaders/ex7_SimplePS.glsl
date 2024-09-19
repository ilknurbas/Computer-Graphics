#version 460
#define PI 3.1415926535897932384626433832795

// This is non-metalic object, all parts are implemented.

in vec3 fragNormal;
in vec4 fragPosition;
in vec2 fragTexture;
in vec3 fragTangent;

 
out vec4 outColor;

// Q1
// F, Schlicks approximation of the Fresnel term
// material specular color
vec3 f0 = vec3(0.04, 0.04, 0.04); // 0.04 for non-metals, others metal color
vec3 light_dir = normalize(vec3(15.0, 5.0, 5.0)); 
vec3 lightColor = vec3(4.0, 4.0, 4.0);  
uniform vec3 camera_pos;

// D, Trowbridge-Reitz/GGX normal distribution function
float alpha = 0.8; // bumpiness of the surface, roughness 

// Q2
uniform sampler2D albedo_texture;

// BONUS 1
uniform sampler2D roughness_texture;

// BONUS 2
uniform sampler2D normal_texture; 

void main() {
   	
   	// Q1 
   	// Specular BRDF term
   
   	// F, Schlicks approximation of the Fresnel term
   	vec3 view_dir = normalize(camera_pos - fragPosition.xyz);
   	vec3 half_vector = normalize(light_dir + view_dir);
   	float temp = clamp(dot(half_vector, light_dir), 0.0, 1.0);
   	vec3 fresnel = f0 + ((1.0 - f0) * pow((1- temp), 5.0));
   
   	// G, Smiths joint shadowing and masking function
   	float nv = clamp( dot(normalize(fragNormal), view_dir), 0.0, 1.0);
   	float nl = clamp( dot(normalize(fragNormal), light_dir), 0.0, 1.0);
   	float kaydet =nl;
	float inside_left = pow(alpha, 4) + (nl * (nl - (pow(alpha, 4) * nl))); 
	float inside_right = pow(alpha, 4) + (nv * (nv - (pow( alpha, 4) * nv))); 
   	float left = nv * pow( inside_left, 0.5);
   	float right = nl * pow( inside_right, 0.5);
   	float middle_term = 0.5 / (left + right) ;
   
   	// D, Trowbridge-Reitz/GGX normal distribution function
   	float numerator = pow(alpha, 4);
   	float nh = dot(normalize(fragNormal), half_vector);
   	float temp2 = (pow(nh, 2.0) * (numerator - 1.0)) + 1.0 ;
   	float denominator =  PI * pow(temp2, 2.0);
   	float distribution = numerator/denominator;

	vec3 brdf_specular = fresnel *  middle_term * distribution;
	
	// diffuse scattering with a Lambertian term, add diffuse for non metals
	vec3 albedo = vec3(0.0, 3.0, 0.0); // green
	vec3 brdf_diffuse = albedo / PI;
  	vec3 diffuse = ((1 - fresnel) * brdf_diffuse);
  	vec3 total = nl * (brdf_specular + diffuse)  ;
  	outColor = vec4(total, 1.0);
  	
  	// Q2
  	albedo = texture(albedo_texture, fragTexture).rgb; 
  	albedo = pow(albedo, vec3(2.2));
    brdf_diffuse = (albedo / PI);
  	vec3 diffuse_texture = (1 - fresnel) * brdf_diffuse;
  	total =  nl * brdf_specular + nl * diffuse_texture; 
  	
  	// uncomment this in order to see texture added object
  	// and comment lines (line 109,141) staring with outColor = ... ; below 
  	outColor = vec4(total * lightColor, 1.0);
  	
  	// BONUS 1
	float roughness = texture(roughness_texture, fragTexture).r; 
	float metalness = 0.0;   
  	
  	// Specular BRDF terM
  	// F, Schlicks approximation of the Fresnel term
  	f0 = mix(f0, albedo, metalness);
  	vec3 fresnel_bonus1 = f0 + (1.0 - f0) * pow((1- temp), 5.0);
  	
  	// G, Smiths joint shadowing and masking function
	inside_left = pow(roughness, 4)  + (nl * (nl - (pow(roughness, 4)  * nl))); 
	inside_right = pow(roughness, 4)  + (nv * (nv - (pow(roughness, 4)  * nv))); 
   	left = nv * pow( inside_left, 0.5);
   	right = nl * pow( inside_right, 0.5);
   	middle_term = 0.5 / (left + right) ;
   
   	// D, Trowbridge-Reitz/GGX normal distribution function
   	numerator = pow(roughness, 4);
   	nh = dot(normalize(fragNormal), half_vector);
   	temp2 =  pow(nh, 2.0) * (numerator - 1.0) + 1.0 ;
   	denominator =  PI * pow(temp2, 2.0);
   	distribution = numerator / denominator;

	vec3 brdf_specular_bonus1 = fresnel_bonus1 *  middle_term * distribution;
	total =  nl * brdf_specular_bonus1 + nl * diffuse_texture;  
	// uncomment this in order to see texture added object with roughness map
	// and comment lines (line 141) staring with outColor = ... ; below
	outColor = vec4(total * lightColor, 1.0);

	
	// BONUS 2 
	vec3 bitangent = normalize(cross(normalize(fragNormal), normalize(fragTangent)));
	mat3 tbn = mat3(normalize(fragTangent), bitangent, normalize(fragNormal));
	
	vec3 normal_map = texture(normal_texture, fragTexture).rgb;  
	normal_map = normal_map * 2.0 - 1.0;
	vec3 normal_map_world = normalize(tbn * normal_map);
	
	// Specular BRDF terM
   	//  Fresnel term does not change
   	// G, Smiths joint shadowing and masking function
   	nv = clamp(dot(normal_map_world, view_dir), 0.0, 1.0);
   	nl = clamp(dot(normal_map_world, light_dir), 0.0, 1.0);
	inside_left = pow(roughness, 4)  + (nl * (nl - (pow(roughness, 4)  * nl))); 
	inside_right = pow(roughness, 4)  + (nv * (nv - (pow(roughness, 4)  * nv)));  
   	left = nv * pow( inside_left, 0.5);
   	right = nl * pow( inside_right, 0.5);
   	float middle_term_bonus2 = 0.5 / (left + right) ;
   
   	// D, Trowbridge-Reitz/GGX normal distribution function
   	numerator = pow(roughness, 4) ;
   	nh = dot(normal_map_world, half_vector);
   	temp2 =  pow(nh, 2.0) * (numerator - 1.0) + 1.0 ;
   	denominator =  PI * pow(temp2, 2.0);
   	float distribution_bonus2 = numerator / denominator;

	vec3 brdf_specular_bonus2 = fresnel_bonus1 *  middle_term_bonus2 * distribution_bonus2;
	total =  nl * brdf_specular_bonus2 + nl * diffuse_texture; 
	// uncomment this in order to see the implementation with normal maps instead of geometric normals 
	outColor = vec4(total * lightColor, 1.0);
 
   
}