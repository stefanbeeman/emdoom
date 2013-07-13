
// Derived from http://r3dux.org/2011/06/glsl-image-processing/

#version 120

uniform sampler2D sampler0;

void main()
{
	// Convert to greyscale using NTSC weightings	
	float grey = dot(texture2D(sampler0, gl_TexCoord[0].xy).rgb, vec3(0.299, 0.587, 0.114));
 
	// Play with these rgb weightings to get different tones.
	// (As long as all rgb weightings add up to 1.0 you won't lighten or darken the image)
	gl_FragColor = vec4(grey * vec3(1.4, 1.0, 0.6), 1.0);
}
