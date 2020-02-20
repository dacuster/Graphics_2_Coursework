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
	
	passColor_transform_instanced_vs4x.glsl
	Transform position attribute for instance and pass color attribute down 
		the pipeline.
*/

#version 410

#define MAX_INSTANCES 1024

/*
	Attribute input variable for position.
	Use layout location 0 for position data.
*/
layout (location = 0) in vec4 aPosition;
layout (location = 3) in vec4 aColor;

uniform mat4 uMVP;

out vec4 vColor;

void main()
{
	// DUMMY OUTPUT: directly assign input position to output position
	gl_Position = uMVP * aPosition;

	vColor = aColor;
}