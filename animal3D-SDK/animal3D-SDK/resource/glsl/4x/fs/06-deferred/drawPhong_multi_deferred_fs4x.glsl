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
	
	drawPhong_multi_deferred_fs4x.glsl
	Draw Phong shading model by sampling from input textures instead of 
		data received from vertex shader.
*/

#version 410

#define MAX_LIGHTS 4

// ****TO-DO: 
//	0) copy original forward Phong shader
//	1) declare g-buffer textures as uniform samplers
//	2) declare light data as uniform block
//	3) replace geometric information normally received from fragment shader 
//		with samples from respective g-buffer textures; use to compute lighting
//			-> position calculated using reverse perspective divide; requires 
//				inverse projection-bias matrix and the depth map
//			-> normal calculated by expanding range of normal sample
//			-> surface texture coordinate is used as-is once sampled


/***************************
**  FORWARD DECLARATIONS  **
***************************/
// Diffuse Calculation.
vec4 calculateDiffuse(vec4 _lightColor, vec4 _normal, vec4 _lightDirection);

// Specular calculation.
vec4 calculateSpecular(vec4 _lightColor, vec4 _viewDirection, vec4 _reflectionDirection, float _specularStrength, int _shininess);

// Ambient calculation.
vec4 calculateAmbient(vec4 _lightColor, float _ambientStrength);


/*************
**  INPUTS  **
*************/
in vbLightingData
{
	vec4 vViewPosition;
	vec4 vViewNormal;
	vec4 vTexcoord;
	vec4 vBiasedClipCoord;
};


/**************
**	OUTPUTS  **
**************/
layout (location = 0) out vec4 rtFragColor;				// Fragment color.
layout (location = 4) out vec4 rtDiffuseMapSample;		// Diffuse map sample.
layout (location = 5) out vec4 rtSpecularMapSample;		// Specular map sample.
layout (location = 6) out vec4 rtDiffuseLightTotal;		// Total diffuse lighting.
layout (location = 7) out vec4 rtSpecularLightTotal;	// Total specular lighting.


/***************
**  UNIFORMS  **
***************/
uniform sampler2D uImage01;
uniform sampler2D uImage02;
uniform sampler2D uImage03;
uniform sampler2D uImage04;
uniform sampler2D uImage05;

uniform int uLightCt;		// Light count.

uniform vec4 uLightPos[4];	// Light positions.
uniform vec4 uLightCol[4];	// Light colors.

uniform mat4 uPB_inv;

void main()
{
	vec4 gPosition = texture(uImage01, vTexcoord.xy);
	vec4 gNormal = texture(uImage02, vTexcoord.xy);
	vec4 gTexcoord = texture(uImage03, vTexcoord.xy);
//	vec4 diffuseTexture  = texture(uImage04, vTexcoord.xy);	// Diffuse lighting.
//	vec4 specularTexture = texture(uImage04, vTexcoord.xy);	// Specular lighting.
	vec4 diffuse = vec4(0.0, 0.0, 0.0, 0.0);	// Diffuse lighting.
	vec4 specular = vec4(0.0, 0.0, 0.0, 0.0);	// Specular lighting.
	vec4 ambient  = vec4(0.0, 0.0, 0.0, 0.0);			// Ambient lighting.

	// Reverse perspective divide.
	gPosition *= uPB_inv;
	gPosition /= gPosition.w;

	// Calculate the view direction normal vector.
	vec4 viewDirection = normalize(gPosition);

	// Surface normal.
	vec4 surfaceNormal = normalize(gNormal);

	// Loop through each light in the scene.
	for (int lightIndex = 0; lightIndex < uLightCt; lightIndex++)
	{
		// Light direction as a normal vector.
		vec4 lightDirection = normalize(uLightPos[lightIndex] - gPosition);//vViewPosition);

		// Calculate the reflection direction.
		vec4 reflectionDirection = reflect(lightDirection, surfaceNormal);

		// Add additional diffuse lighting.
		diffuse += calculateDiffuse(uLightCol[lightIndex], surfaceNormal, lightDirection);

		// Add additional specular lighting.
		specular += calculateSpecular(uLightCol[lightIndex], viewDirection, reflectionDirection, 1.0, 4);

		// Add additional ambient lighting.
		ambient += calculateAmbient(uLightCol[lightIndex], 0.001);
	}

	vec4 diffuseTexture  = texture(uImage04, vTexcoord.xy);	// Diffuse lighting.
	vec4 specularTexture = texture(uImage04, vTexcoord.xy);	// Specular lighting.

	// DUMMY OUTPUT: all fragments are OPAQUE CYAN (and others)
	//rtFragColor = diffuseTexture * diffuse + specularTexture * specular + ambient;
	rtFragColor = vec4(0.0, 0.0, 0.0, 1.0);
	rtDiffuseMapSample = vec4(0.0, 0.0, 1.0, 1.0);
	rtSpecularMapSample = vec4(0.0, 1.0, 0.0, 1.0);
	rtDiffuseLightTotal = vec4(1.0, 0.0, 1.0, 1.0);
	rtSpecularLightTotal = vec4(1.0, 1.0, 0.0, 1.0);
}

// Calculate diffuse lighting.
vec4 calculateDiffuse(vec4 _lightColor, vec4 _surfaceNormal, vec4 _lightDirection)
{
	// Make sure the value is not less than 0 and multiply by the light color.
	return max(0.0, dot(_lightDirection, _surfaceNormal)) * _lightColor;
}

// Calculate the specular lighting.
// Shininess is an exponential power of 2.
// ks *= ks = ks^2 : ks *= ks = ks^4 : ks *= ks = ks^8 etc...
vec4 calculateSpecular(vec4 _lightColor, vec4 _viewDirection, vec4 _reflectionDirection, float _specularStrength, int _shininess)
{
	// Calculate the initial specular coefficient with a minimum of 0.
	float specularCoefficient = max(0.0, dot(_viewDirection, _reflectionDirection));

	// Calculate the specular coefficient based on the shininess desired.
	for (int shininessIndex = 0; shininessIndex < _shininess; shininessIndex++)
	{
		specularCoefficient *= specularCoefficient;
	}

	// Return the product of the strength and coefficient with the light color.
	return _specularStrength * specularCoefficient * _lightColor;
}

// Calculate the ambient lighting.
vec4 calculateAmbient(vec4 _lightColor, float _ambientStrength)
{
	return _ambientStrength * _lightColor;
}