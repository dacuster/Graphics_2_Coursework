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
	
	drawTexture_coordManip_fs4x.glsl
	Draw texture sample after manipulating texcoord.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare inbound varying for texture coordinate
//	3) modify texture coordinate in some creative way
//	4) sample texture using modified texture coordinate
//	5) assign sample to output color

out vec4 rtFragColor;

uniform sampler2D uTex_dm;
uniform double uTime;

in vec4 vTexcoord;

void main()
{
	vec4 texcoord = vTexcoord;

	//texcoord.x *= (tan(float(uTime)) * 0.5 + 0.5);
	//texcoord.y *= (tan(float(uTime)) * 0.5 + 0.5);
	//texcoord.z *= (tan(float(uTime)) * 0.5 + 0.5);
	texcoord.x += sin(float(uTime)) * cos(float(uTime));
	texcoord.y += sin(float(uTime)) * cos(float(uTime));

	// DUMMY OUTPUT: all fragments are OPAQUE DARK GREY
	//rtFragColor = vec4(0.2, 0.2, 0.2, 1.0);
	rtFragColor = texture(uTex_dm, vec2(texcoord));
}
