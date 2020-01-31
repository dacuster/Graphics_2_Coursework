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
	
	passLightingData_transform_vs4x.glsl
	Vertex shader that prepares and passes lighting data. Outputs transformed 
		position attribute and all others required for lighting.
*/

#version 410

// ****TO-DO: 
//	--1) declare uniform variable for MV matrix; see demo code for hint
//	--2) declare view position as outbound varying
//	--3) correctly transform input position by MV matrix to get view position
//	--4) declare uniform variable for P matrix; see demo code for hint
//	--5) correctly transform view position by P matrix to get final position
//	--6) declare normal attribute; see renderer library for location
//	--7) declare MV matrix for normals; see demo code for hint
//	--8) declare outbound normal
//	9) correctly transform input normal by MV normal matrix
//	10+) see instructions in passTexcoord...vs4x.glsl for information on 
//		how to handle the texture coordinate


/*************
**	INPUTS  **
*************/
layout (location = 0) in vec4 aPosition;

// 6) Declare normal inbound attribute.
layout (location = 2) in vec4 aNormal;

// Attribute input texture coordinate.
layout (location = 8) in vec4 aTexcoord;


/***************
**	UNIFORMS  **
***************/
// 7) Model view matrix for normals.
uniform mat4 uMV_nrm;

// 1) Model view matrix.
uniform mat4 uMV;

// 4) Projection matrix.
uniform mat4 uP;

// Texture Atlas matrix.
uniform mat4 uAtlas;


/***************
**	VARYINGS  **
***************/
// 2) Outbound view position.
out vec4 vViewPosition;

// 8) Outbound normal.
out vec4 vNormal;

// Varying output texture coordinate.
out vec4 vTexcoord;

void main()
{
	// 3) Transform input position by model view matrix.
	//gl_Position = uP * uMV * aPosition;
	vViewPosition = uMV * aPosition;

	// 5) Transform view position by projection matrix.
	gl_Position = uP * vViewPosition;

	// 9) Transform input normal by MV normal matrix.
	vNormal = uMV_nrm * aNormal;

	//vTexcoord = vec2(uAtlas * aTexcoord);
	vTexcoord = uAtlas * aTexcoord;

	// DUMMY OUTPUT: directly assign input position to output position
	//gl_Position = aPosition;
}
