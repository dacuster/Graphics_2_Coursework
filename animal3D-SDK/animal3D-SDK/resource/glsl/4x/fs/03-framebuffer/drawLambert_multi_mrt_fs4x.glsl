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
	
	drawLambert_multi_mrt_fs4x.glsl
	Draw Lambert shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component

/***************************
**	FORWARD DECLARATIONS  **
***************************/
// Diffuse function forward declaration.
float diffuse(vec3 _normal, vec3 _light);


/*************************************
**  OUTPUT MULTI-RENDERING TARGETS  **
*************************************/
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) out vec4 rtViewPosition;
layout (location = 2) out vec4 rtViewNormal;
layout (location = 3) out vec4 rtTexcoord;
layout (location = 4) out vec4 rtDiffuseMap;
layout (location = 6) out vec4 rtDiffuseTotal;


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
	vec3 finalDiffuse = vec3(0.0, 0.0, 0.0);
	
	// Loop through all the colors in the scene.
	for (int count = 0; count < uLightCt; count++)
	{
		// Light vector. pL - p
		vec3 lightVector = uLightPos[count].xyz - vViewPosition.xyz;

		// Sum up all light diffuse values and scale by light color.
		finalDiffuse += diffuse(vNormal.xyz, lightVector) * uLightCol[count].xyz;
	}

	// Assign texture and diffuse to outbound fragment color.
	rtFragColor = texture(uTex_dm, vec2(vTexcoord)) * vec4(finalDiffuse, 1.0);

	rtViewPosition = vViewPosition;

	// Normal values are [0.0 - 1.0] needs to be mapped to [-1.0 - 1.0].
	rtViewNormal = vec4(normalize(vNormal).xyz * 0.5 + 0.5, 1.0);

	rtTexcoord = vTexcoord;

	rtDiffuseMap = texture(uTex_dm, vec2(vTexcoord));

	rtDiffuseTotal = vec4(finalDiffuse, 1.0);

	//rtDepthBuffer = vec4(vViewPosition.zzz, 1.0);
}

// Calculate diffuse value of given light and surface normal.
float diffuse(vec3 _normal, vec3 _light)
{
	// Normalize surface normal.
	vec3 surfaceNormal = normalize(_normal);

	// Noralized light.
	vec3 lightNormal = normalize(_light);

	// Make sure value is not less than 0 and return.
	return max(0.0, dot(lightNormal, surfaceNormal));
}