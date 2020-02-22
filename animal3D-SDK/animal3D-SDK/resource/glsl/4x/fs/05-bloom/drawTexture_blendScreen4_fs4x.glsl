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
	
	drawTexture_blendScreen4_fs4x.glsl
	Draw blended sample from multiple textures using screen function.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare additional texture uniforms
//	2) implement screen function with 4 inputs
//	3) use screen function to sample input textures

uniform sampler2D uImage00;
uniform sampler2D uImage01;
uniform sampler2D uImage02;
uniform sampler2D uImage03;

layout (location = 0) out vec4 rtFragColor;

in vec4 vTexcoord;

vec4 screen(in vec4 screenA, in vec4 screenB, in vec4 screenC, in vec4 screenD)
{
	return 1.0 - (1.0 - screenA) * (1.0 - screenB) * (1.0 - screenC) * (1.0 - screenD);
}

void main()
{

	vec4 screenOne = texture(uImage00, vTexcoord.xy);
	vec4 screenTwo = texture(uImage01, vTexcoord.xy);
	vec4 screenThree = texture(uImage02, vTexcoord.xy);
	vec4 screenFour = texture(uImage03, vTexcoord.xy);

	rtFragColor = screen(screenOne, screenTwo, screenThree, screenFour);
}
