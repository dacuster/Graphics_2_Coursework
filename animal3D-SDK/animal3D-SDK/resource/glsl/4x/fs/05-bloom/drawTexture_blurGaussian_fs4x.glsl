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
	
	drawTexture_blurGaussian_fs4x.glsl
	Draw texture with Gaussian blurring.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare uniforms for pixel size and sampling axis
//	2) implement Gaussian blur function using a 1D kernel (hint: Pascal's triangle)
//	3) sample texture using Gaussian blur function and output result

uniform sampler2D uImage00;
uniform vec2 uAxis;
uniform vec2 uSize;
in vec4 vTexcoord;

layout (location = 0) out vec4 rtFragColor;

vec4 blurGaussian0(in sampler2D _image, in vec2 _center, in vec2 _direction)
{
	return texture(_image, _center);
}

vec4 blurGaussian2(in sampler2D _image, in vec2 _center, in vec2 _direction)
{
	vec4 _color = vec4(0.0);
	_color += texture(_image, _center) * 2.0;
	_color += texture(_image, _center + _direction);
	_color += texture(_image, _center - _direction);
	// return _color / 4.0;
	return _color * 0.25;	// Normalize by the sample size. 2, 1, 1
}

vec4 blurGaussian4(in sampler2D _image, in vec2 _center, in vec2 _direction)
{
	vec4 _color = vec4(0.0);
	_color += texture(_image, _center) * 6.0;
	_color += texture(_image, _center + _direction * 4.0);
	_color += texture(_image, _center - _direction * 4.0);
	_color += texture(_image, _center + _direction);
	_color += texture(_image, _center - _direction);
	// return _color / 16.0;
	//return _color * 0.0625;	// Normalize by the sample size. 6, 4, 4, 1, 1
	return _color * 0.09375;	// Prevent brightness change. 0.0625 * 1.5
}

vec4 blurGaussian6(in sampler2D _image, in vec2 _center, in vec2 _direction)
{
	vec4 _color = vec4(0.0);
	_color += texture(_image, _center) * 20.0;
	_color += texture(_image, _center + _direction * 15.0);
	_color += texture(_image, _center - _direction * 15.0);
	_color += texture(_image, _center - _direction * 6.0);
	_color += texture(_image, _center + _direction * 6.0);
	_color += texture(_image, _center + _direction);
	_color += texture(_image, _center - _direction);
	// return _color / 64.0;
	return _color * 0.015625 * 2.5;	// Normalize by the sample size. 20, 15, 15, 6, 6, 1, 1
}

vec4 blurGaussian8(in sampler2D _image, in vec2 _center, in vec2 _direction)
{
	vec4 _color = vec4(0.0);
	_color += texture(_image, _center) * 70.0;
	_color += texture(_image, _center + _direction * 56.0);
	_color += texture(_image, _center - _direction * 56.0);
	_color += texture(_image, _center + _direction * 28.0);
	_color += texture(_image, _center - _direction * 28.0);
	_color += texture(_image, _center + _direction * 8.0);
	_color += texture(_image, _center - _direction * 8.0);
	_color += texture(_image, _center + _direction);
	_color += texture(_image, _center - _direction);
	// return _color / 256.0;
	return _color * 0.00390625 * 3.5;	// Normalize by the sample size. 70, 56, 56, 28, 28, 8, 8, 1, 1
}

vec4 blurGaussian10(in sampler2D _image, in vec2 _center, in vec2 _direction)
{
	vec4 _color = vec4(0.0);
	_color += texture(_image, _center) * 252.0;
	_color += texture(_image, _center + _direction * 210.0);
	_color += texture(_image, _center - _direction * 210.0);
	_color += texture(_image, _center + _direction * 120.0);
	_color += texture(_image, _center - _direction * 120.0);
	_color += texture(_image, _center + _direction * 45.0);
	_color += texture(_image, _center - _direction * 45.0);
	_color += texture(_image, _center + _direction * 10.0);
	_color += texture(_image, _center - _direction * 10.0);
	_color += texture(_image, _center + _direction);
	_color += texture(_image, _center - _direction);
	// return _color / 1024.0;
	return _color * 0.0009765625;	// Normalize by the sample size. 252, 210, 210, 120, 120, 45, 45, 10, 10, 1, 1
}


void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE MAGENTA
	//rtFragColor = vec4(1.0, 0.0, 1.0, 1.0);
	rtFragColor = blurGaussian4(uImage00, vTexcoord.xy, uSize * uAxis);
}
