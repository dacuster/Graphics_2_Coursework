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
	
	drawPhong_multi_fs4x.glsl
	Draw Phong shading model for multiple lights.
*/

#version 410

// ****TO-DO: 
//	--1) declare uniform variables for textures; see demo code for hints
//	--2) declare uniform variables for lights; see demo code for hints
//	--3) declare inbound varying data
//	4) implement Phong shading model
//	Note: test all data and inbound values before using them!


/***************************
**	FORWARD DECLARATIONS  **
***************************/
// Diffuse calculation.
float diffuse(vec4 _normal, vec4 _lightDirection);

// Specular calculation.
float specular(vec4 _viewDirection, vec4 _reflectionDirection, float _specularStrength = 1.0, int _shininess = 4);

// Ambient calculation.
vec4 ambient(vec4 _lightColor, float _ambientStrength = 0.01);


/**************
**	OUTPUTS  **
**************/
// Output fragment color.
out vec4 rtFragColor;


/***************
**	UNIFORMS  **
***************/
// Texture diffuse map matrix.
uniform sampler2D uTex_dm;

// Texture specular map matrix.
uniform sampler2D uTex_sm;

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

	// Final specular.
	vec4 finalSpecular = vec4(0.0, 0.0, 0.0, 0.0);

	// Final ambient.
	vec4 finalAmbient = vec4(0.0, 0.0, 0.0, 0.0);

	// Calculate the view direction normal vector.
	vec4 viewDirection = normalize(vViewPosition);

	// Surface normal.
	vec4 surfaceNormal = normalize(vNormal);
	
	// Loop through all the colors in the scene.
	for (int count = 0; count < uLightCt; count++)
	{
		// Light direction as a normal vector. pL - p
		vec4 lightDirection = normalize(uLightPos[count] - vViewPosition);

		// Calculate the reflection direction.
		vec4 reflectionDirection = reflect(lightDirection, surfaceNormal);

		// Sum up all diffuse lighting values scaled by light color.
		finalDiffuse += diffuse(surfaceNormal, lightDirection) * uLightCol[count];

		// Sum up all the specular lighting values scaled by light color.
		finalSpecular += specular(viewDirection, reflectionDirection) * uLightCol[count];

		// Sum up all the ambient lighting values scaled by light color.
		finalAmbient += ambient(uLightCol[count]);
	}

	// Assign texture and diffuse to outbound fragment color.
	// Diffuse_map * finalDiffuse + ambient + Specular_map * finalSpecular
	rtFragColor = texture(uTex_dm, vec2(vTexcoord)) * finalDiffuse + finalAmbient + texture(uTex_sm, vec2(vTexcoord)) * finalSpecular;
}

// Calculate diffuse value of given light and surface normal.
float diffuse(vec4 _surfaceNormal, vec4 _lightDirection)
{
	// Make sure value is not less than 0 and return.
	return max(0.0, dot(_lightDirection, _surfaceNormal));
}

// Calculate specular highlights.
// Shininess is an exponential power of 2.
// ks *= ks = ks^2 : ks *= ks = ks^4 : ks *= ks = ks^8 etc...
float specular(vec4 _viewDirection, vec4 _reflectionDirection, float _specularStrength /*= 1.0*/, int _shininess /*= 4*/)
{
	// Calculate the initial specular coefficient with a minimum of 0.
	float specularCoefficient = max(0.0, dot(_viewDirection, _reflectionDirection));
	
	// Calculate the specular coefficient based on the shininess desired.
	for (int counter = 0; counter < _shininess; ++counter)
	{
		specularCoefficient *= specularCoefficient;
	}

	// Return the product of the strength and coefficient.
	return _specularStrength * specularCoefficient;
}

// Calculate ambient lighting.
vec4 ambient(vec4 _lightColor, float _ambientStrength/* = 0.001 */)
{
	return _ambientStrength * _lightColor;
}