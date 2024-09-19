#version 460

// YOU CAN USE THIS SHADER FOR BONUS 1&2

uniform vec2 uResolution;
uniform float uTime;

in vec2 fragTexCoord; 
out vec4 outColor;

void main()
{
	// with BONUS 2
    vec2 uv = fragTexCoord;

    outColor = vec4(0.5 + 0.5*cos(uv.yxy + uTime),1.0);
    outColor = vec4(0.0, 1.0, 1.0 ,1.0);
    
    int squareSize = 8;  
    int a = int(uv.x * squareSize);
    int b = int(uv.y * squareSize);
    
    int decide_color = (a + b) % 2;
    vec3 c1 = vec3(1.0, 1.0, 1.0);
    vec3 c2 = vec3(1.0, 0.0, 0.0); 
    outColor = vec4(mix(c1, c2, float(decide_color)),1.0);;
}