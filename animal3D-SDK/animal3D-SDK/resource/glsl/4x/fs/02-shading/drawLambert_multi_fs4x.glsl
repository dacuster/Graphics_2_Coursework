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
	
	drawLambert_multi_fs4x.glsl
	Draw Lambert shading model for multiple lights.
*/

#version 410

// ****TO-DO: 
//	--1) declare uniform variable for texture; see demo code for hints
//	--2) declare uniform variables for lights; see demo code for hints
//	--3) declare inbound varying data
//	--4) implement Lambert shading model
//	Note: test all data and inbound values before using them!

/***************************
**	FORWARD DECLARATIONS  **
***************************/
// Diffuse function forward declaration.
float diffuse(vec4 _normal, vec4 _light);


/**************
**	OUTPUTS  **
**************/
// Output fragment color.
out vec4 rtFragColor;


/***************
**	UNIFORMS  **
***************/
// Texture matrix.
uniform sampler2D uTex_dm;

// Light source count.
uniform int uLightCt;

// Light position. Maximum 4 lights built in.
uniform vec4 uLightPos[4];

// Light color. Maximum 4 lights built in.
uniform vec4 uLightCol[4];


/*************
**	INPUTS  **
*************/
// Inbound varying for texture coordinate.
in vec4 vTexcoord;

// Inbound varying view position.
in vec4 vViewPosition;

// Inbound vertex normal vector.
in vec4 vNormal;


/***********
**	MAIN  **
***********/
void main()
{
	// Final diffuse.
	vec4 finalDiffuse = vec4(0.0, 0.0, 0.0, 0.0);
	
	// Loop through all the colors in the scene.
	for (int count = 0; count < uLightCt; count++)
	{
		// Light vector. pL - p
		vec4 lightVector = uLightPos[count] - vViewPosition;

		// Sum up all light diffuse values and scale by light color.
		finalDiffuse += diffuse(vNormal, lightVector) * uLightCol[count];
	}

	// Assign texture and diffuse to outbound fragment color.
	rtFragColor = texture(uTex_dm, vec2(vTexcoord)) * finalDiffuse;
}

// Calculate diffuse value of given light and surface normal.
float diffuse(vec4 _normal, vec4 _light)
{
	// Normalize surface normal.
	vec4 surfaceNormal = normalize(_normal);

	// Noralized light.
	vec4 lightNormal = normalize(_light);

	// Make sure value is not less than 0 and return.
	return max(0.0, dot(lightNormal, surfaceNormal));
}