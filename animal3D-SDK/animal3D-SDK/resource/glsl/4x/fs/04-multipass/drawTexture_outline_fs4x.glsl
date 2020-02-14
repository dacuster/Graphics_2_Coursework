/*
	Copyright 2011-2020 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawTexture_outline_fs4x.glsl
	Draw texture sample with outlines.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement outline algorithm - see render code for uniform hints

vec4 sobel(sampler2D _image, vec2 _center);

in vec4 vTexcoord;

uniform sampler2D uTex_dm;

// Lab 3
// Locations in HUD!!!
layout (location = 0) out vec4 rtFragColor;

// Line color.
uniform vec4 uColor;

// Line thickness.
uniform vec2 uAxis;

// Actual pixel size.
uniform vec2 uSize;

in vec4 vNormal;

in vec4 vViewPosition;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE DARK GREY
	//rtFragColor = vec4(0.2, 0.2, 0.2, 1.0);

	// Shadertoy example of quick outlining.
	//rtFragColor -= rtFragColor - length(fwidth(texture(uTex_dm, vec2(vTexcoord)))) * 10.0;

	//rtFragColor = vec4(normalize(vNormal).xyz * 0.5 + 0.5, 1.0);
	

	// Render Target Fragment Color
	//rtFragColor = texture(uTex_dm, vec2(vTexcoord));

	//rtFragColor = vec4(vec3(sobel(vNormal.xy)), 1.0);

	float edgeDetection = (dot(vViewPosition.xyz, normalize(vNormal).xyz * 0.5 + 0.5) > 0.3 ? 1.0 : 0.0);

	//rtFragColor = vec4(edgeDetection, edgeDetection, edgeDetection, 1.0);

	rtFragColor = vec4(sobel(uTex_dm, vTexcoord.xy).rgb, texture(uTex_dm, vTexcoord.xy).a);
	rtFragColor = sobel(uTex_dm, vTexcoord.xy);


}

vec4 sobel(sampler2D _image, vec2 _center)
{
	vec4 horizontal = texture(_image, _center);
	vec4 vertical = horizontal;
	
	horizontal -= texture(_image, _center + vec2(-1, 1));
	horizontal -= texture(_image, _center + vec2(-1, 0)) * 2.0;
	horizontal -= texture(_image, _center + vec2(-1, -1));
	horizontal += texture(_image, _center + vec2(1, 1));
	horizontal += texture(_image, _center + vec2(1, 0)) * 2.0;
	horizontal += texture(_image, _center + vec2(1, -1));
	horizontal /= 6.0;

	vertical += texture(_image, _center + vec2(-1, 1));
	vertical += texture(_image, _center + vec2(0, 1)) * 2.0;
	vertical += texture(_image, _center + vec2(1, 1));
	vertical -= texture(_image, _center + vec2(-1, -1));
	vertical -= texture(_image, _center + vec2(0, -1)) * 2.0;
	vertical -= texture(_image, _center + vec2(1, -1));
	vertical /= 6.0;
	
	//vec3 edge = sqrt(horizontal.rgb * horizontal.rgb + vertical.rgb * vertical.rgb);
	vec4 edge = sqrt(horizontal * horizontal + vertical * vertical);

//	return vec4(edge, 1.0);
	return edge;
}


//float sobel(sampler2D _image, vec2 _center)
//{
//	mat3 xGradient = mat3(
//		1.0, 0.0, -1.0,
//		2.0, 0.0, -2.0,
//		1.0, 0.0, -1.0);
//
//	mat3 yGradient = mat3(
//		 1.0,  2.0,  1.0,
//		 0.0,  0.0,  0.0,
//		-1.0, -2.0, -1.0);
//
//	long sumX = 0;
//	long sumY = 0;
//	
//	for (int y = -1; y < 2; y++)
//	{
//		for (int x = -1; x < 2; x++)
//		{
//			sumX += int();
//		}
//	}
//	
//	return sqrt(gX * gX + gY * gY);
//}


