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
	
	drawTexture_colorManip_fs4x.glsl
	Draw texture sample and manipulate result.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare inbound varying for texture coordinate
//	3) sample texture using texture coordinate
//	4) modify sample in some creative way
//	5) assign modified sample to output color

out vec4 rtFragColor;

uniform sampler2D uTex_dm;
uniform double uTime;

in vec4 vTexcoord;

void main()
{
	vec4 sampleTexture = texture(uTex_dm, vec2(vTexcoord));
	
	sampleTexture.x *= (sin(float(uTime)) * 0.5 + 0.5);
	sampleTexture.y *= (sin(float(uTime)) * 0.5 + 0.5);
	sampleTexture.z *= (sin(float(uTime)) * 0.5 + 0.5);

	// DUMMY OUTPUT: all fragments are OPAQUE LIGHT GREY
	//rtFragColor = vec4(0.5, 0.5, 0.5, 1.0);

	rtFragColor = sampleTexture;
}
