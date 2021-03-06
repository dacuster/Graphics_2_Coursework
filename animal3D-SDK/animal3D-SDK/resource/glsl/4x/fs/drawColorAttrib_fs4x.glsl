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
	
	drawColorAttrib_fs4x.glsl
	Draw color attribute passed from prior stage as varying.
*/

#version 410

//	--1) declare varying to receive input vertex color from vertex shader
//	--2) assign vertex color to output color

// Output variable for fragment shader color.
out vec4 rtFragColor;

// Input from vertex shader for color data.
in vec4 vColor;

void main()
{
	// Set the fragment shader color to the input color.
	rtFragColor = vColor;
}