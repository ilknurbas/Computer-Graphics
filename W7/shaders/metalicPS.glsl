#version 460
#define PI 3.1415926535897932384626433832795

// This is metalic object, only 1st question implemented according to it.

in vec3 fragNormal;
in vec4 fragPosition;
in vec2 fragTexture;

in vec4 color;
out vec4 outColor;

// Q1
// F, Schlicks approximation of the Fresnel term
// material specular color
vec3 f0 = vec3(4.7, 4.7, 0.0); // 0.04 for non-metals, others metal color
vec3 light_dir = normalize(vec3(1.0, 1.0, 20.0));
vec3 lightColor = vec3(4.7, 4.7, 0.0);  
uniform vec3 camera_pos;

// D, Trowbridge-Reitz/GGX normal distribution function
float alpha = 0.6 ; // bumpiness of the surface, roughness 


void main() {
   
   	// Q1 
   	// Specular BRDF terM
   
   	// F, Schlicks approximation of the Fresnel term
   	vec3 view_dir = normalize(camera_pos - fragPosition.xyz);
   	
   	vec3 half_vector = normalize(light_dir + view_dir);
   	float temp = clamp(dot(half_vector, light_dir), 0.0, 1.0);
   	vec3 fresnel = f0 + (1.0 - f0) * pow((1- temp), 5.0);

   	// G, Smiths joint shadowing and masking function
   	float nv =  clamp( dot(normalize(fragNormal), view_dir), 0.0, 1.0);
   	float nl =  clamp( dot(normalize(fragNormal), light_dir), 0.0, 1.0);
	float inside_left = pow(alpha, 4) + (nl * (nl - (pow(alpha, 4) * nl))); 
	float inside_right = pow(alpha, 4) + (nv * (nv - (pow(alpha, 4) * nv))); 
   	float left = nv * pow( inside_left, 0.5);
   	float right = nl * pow( inside_right, 0.5);
   	float middle_term = 0.5 / (left + right) ;
   
   	// D, Trowbridge-Reitz/GGX normal distribution function
   	float numerator = pow(alpha, 4);
   	float nh = dot(normalize(fragNormal), half_vector);
   	float temp2 =  pow(nh, 2.0) * (numerator - 1.0) + 1.0 ;
   	float denominator =  PI * pow(temp2, 2.0);
   	float distribution = numerator / denominator;
	vec3 brdf_specular = fresnel *  middle_term * distribution;

  	// add diffuse only for non metals
    vec3 total = nl * brdf_specular;
    // uncomment this in order to see resulting object from Q1 for metalic object
  	outColor = vec4(total, 1.0);
  	
  	
   
}