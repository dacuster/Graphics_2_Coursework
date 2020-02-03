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
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!

float lambert(vec4 _normal, vec4 _light);

out vec4 rtFragColor;

// Texture matrix.
uniform sampler2D uTex_dm;

// Light source count.
uniform int uLightCt;

// Light size.
uniform float uLightSz;

// Light size inverse squared.
uniform float uLightSzInvSq;

// Light position.
uniform vec4 uLightPos;

// Light color.
uniform vec4 uLightCol;

// Inbound varying for texture coordinate.
in vec4 vTexcoord;

in vec4 vViewPosition;

in vec4 vNormal;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE RED
	//rtFragColor = vec4(1.0, 0.0, 0.0, 1.0);

	// DEBUGGING:
	rtFragColor = uLightCol;
	
	// Sample texture using texture coordinate and assign to output color.
	vec4 normalizedView = normalize(uLightPos);

	vec4 finalLambert;


	for (int count = 0; count < uLightCt; count++)
	{
		finalLambert += (lambert(vNormal, vViewPosition - uLightPos));
	}

	rtFragColor = texture(uTex_dm, vec2(vTexcoord)) * finalLambert * uLightCol;
	//rtFragColor = lambert(uNormal, ) * uLightColor;

}


float lambert(vec4 _normal, vec4 _light)
{
	// Surface normal.
	vec4 surfaceNormal = normalize(_normal);

	// Noralized light.
	vec4 lightNormal = normalize(_light);

	return max(0.0, dot(lightNormal, surfaceNormal));
}

