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

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE DARK GREY
	//rtFragColor = vec4(0.2, 0.2, 0.2, 1.0);

	// Shadertoy example of quick outlining.
	//rtFragColor -= rtFragColor - length(fwidth(texture(uTex_dm, vec2(vTexcoord)))) * 3.0;

	rtFragColor = vec4(normalize(vNormal).xyz * 0.5 + 0.5, 1.0);
	

	// Render Target Fragment Color
	//rtFragColor = sample_dm;
}
