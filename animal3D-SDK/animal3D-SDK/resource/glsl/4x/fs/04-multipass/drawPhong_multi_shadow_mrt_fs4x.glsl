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
	
	drawPhong_multi_shadow_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output and 
		shadow mapping.
*/

#version 410

// ****TO-DO: 
//	--0) copy existing Phong shader
//	--1) receive shadow coordinate
//	2) perform perspective divide
//	--3) declare shadow map texture
//	4) perform shadow test


/***************************
**	FORWARD DECLARATIONS  **
***************************/
// Diffuse calculation.
float diffuse(vec3 _normal, vec3 _lightDirection);

// Specular calculation.
float specular(vec3 _viewDirection, vec3 _reflectionDirection, float _specularStrength = 1.0, int _shininess = 4);

// Ambient calculation.
vec4 ambient(vec4 _lightColor, float _ambientStrength = 0.01);

// Shadow calculation.
float calculateShadow(vec4 shadowCoordinate);


/*************************************
**  OUTPUT MULTI-RENDERING TARGETS  **
*************************************/
layout (location = 0) out vec4 rtFragColor;
layout (location = 1) out vec4 rtViewPosition;
layout (location = 2) out vec4 rtViewNormal;
layout (location = 3) out vec4 rtTexcoord;
layout (location = 4) out vec4 rtDiffuseMap;
layout (location = 5) out vec4 rtSpecularMap;
layout (location = 6) out vec4 rtDiffuseTotal;
layout (location = 7) out vec4 rtSpecularTotal;


/***************
**	UNIFORMS  **
***************/
// Texture diffuse map matrix.
uniform sampler2D uTex_dm;

// Texture specular map matrix.
uniform sampler2D uTex_sm;

// Shadow map texture
uniform sampler2D uTex_shadow;

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

// Shadow map texture coordinates.
in vec4 vShadowCoordinate;


/***********
**	MAIN  **
***********/
void main()
{
	// Final diffuse.
	vec3 finalDiffuse = vec3(0.0, 0.0, 0.0);

	// Final specular.
	vec3 finalSpecular = vec3(0.0, 0.0, 0.0);

	// Final ambient.
	vec4 finalAmbient = vec4(0.0, 0.0, 0.0, 0.0);

	// Calculate the view direction normal vector.
	vec3 viewDirection = normalize(vViewPosition.xyz);

	// Surface normal.
	vec3 surfaceNormal = normalize(vNormal.xyz);
	
	// Loop through all the colors in the scene.
	for (int count = 0; count < uLightCt; count++)
	{
		// Light direction as a normal vector. pL - p
		vec3 lightDirection = normalize(uLightPos[count].xyz - vViewPosition.xyz);

		// Calculate the reflection direction.
		vec3 reflectionDirection = reflect(lightDirection, surfaceNormal);

		// Sum up all diffuse lighting values scaled by light color.
		finalDiffuse += diffuse(surfaceNormal, lightDirection) * uLightCol[count].xyz;

		// Sum up all the specular lighting values scaled by light color.
		finalSpecular += specular(viewDirection, reflectionDirection) * uLightCol[count].xyz;

		// Sum up all the ambient lighting values scaled by light color.
		finalAmbient += ambient(uLightCol[count]);
	}

	// Calculate the shadow of the models.
	float shadow = calculateShadow(vShadowCoordinate);

	// Assign texture and diffuse to outbound fragment color.
	// Diffuse_map * finalDiffuse + ambient + Specular_map * finalSpecular
	rtFragColor = (texture(uTex_dm, vec2(vTexcoord)) * vec4(finalDiffuse, 1.0) + texture(uTex_dm, vTexcoord.xy) * finalAmbient + texture(uTex_sm, vec2(vTexcoord)) * vec4(finalSpecular, 1.0)) * vec4((1.0 - shadow), 1.0 - shadow, 1.0 - shadow, 1.0);

	//rtFragColor = texture(uTex_shadow, vec2(vShadowCoordinate));

//	rtViewPosition = vViewPosition;
//
//	rtViewNormal = vec4(normalize(vNormal).xyz * 0.5 + 0.5, 1.0);
//
//	rtTexcoord = vTexcoord;
//
//	rtDiffuseMap = texture(uTex_dm, vec2(vTexcoord));
//
//	rtSpecularMap = texture(uTex_sm, vec2(vTexcoord));
//
//	rtDiffuseTotal = vec4(finalDiffuse, 1.0);
//
//	rtSpecularTotal = vec4(finalSpecular, 1.0);
}

// Calculate diffuse value of given light and surface normal.
float diffuse(vec3 _surfaceNormal, vec3 _lightDirection)
{
	// Make sure value is not less than 0 and return.
	return max(0.0, dot(_lightDirection, _surfaceNormal));
}

// Calculate specular highlights.
// Shininess is an exponential power of 2.
// ks *= ks = ks^2 : ks *= ks = ks^4 : ks *= ks = ks^8 etc...
float specular(vec3 _viewDirection, vec3 _reflectionDirection, float _specularStrength /*= 1.0*/, int _shininess /*= 4*/)
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

float calculateShadow(vec4 shadowCoordinate)
{
	// Perspective divide.
	vec3 projectorCoordinates = shadowCoordinate.xyz / shadowCoordinate.w;

	// Transform to [0,1] range.
	projectorCoordinates *= 0.5 + 0.5;

	// Get the closest depth value.
	float closestDepth = texture(uTex_shadow, projectorCoordinates.xy).r;

	// Get the current depth value.
	float currentDepth = projectorCoordinates.z;

	// Bias for surface depth offset.
	float bias = 0.005;

	// Check if the current fragment position is in the shadow.
	return currentDepth - bias > closestDepth ? 1.0 : 0.0;
}