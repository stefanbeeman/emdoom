
// Derived from http://r3dux.org/2011/06/glsl-image-processing/

#version 120

uniform sampler2D sampler0;

void main()
{
	// Convert to greyscale using NTSC weightings
	float grey = dot(texture2D(sampler0, gl_TexCoord[0].xy).rgb, vec3(0.299, 0.587, 0.114));
 
	gl_FragColor = vec4(grey, grey, grey, 1.0);
}
