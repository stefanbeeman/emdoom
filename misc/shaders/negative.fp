
// Derived from http://r3dux.org/2011/06/glsl-image-processing/

#version 120

uniform sampler2D sampler0;

void main()
{
	vec4 color = texture2D(sampler0, gl_TexCoord[0].xy);
 
	gl_FragColor = vec4(1.0 - color.rgb, 1.0);
}
