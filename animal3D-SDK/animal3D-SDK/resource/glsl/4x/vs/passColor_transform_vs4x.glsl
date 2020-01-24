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
	
	passColor_transform_vs4x.glsl
	Transform position attribute and pass color attribute down the pipeline.
*/

#version 410

//	1) declare uniform variable for MVP matrix; see demo code for hint
//	2) correctly transform input position by MVP matrix
//	3) declare attribute for vertex color input
//	4) declare varying to pass color input to fragment shader
//	5) assign vertex color input to varying

/*
	Attribute input variable for position.
	Use layout location 0 for position data.
*/
layout (location = 0) in vec4 aPosition;

// Uniform variable for Model View Projection Matrix.
uniform mat4 uMVP;

/*
	Attribute input variable for color.
	Use layout position 3 for color data.
*/
layout (location = 3) in vec4 aColor;

/*
	Varying output variable for color.
	Use layout position 3 for color data.
	Layout is needed for output as well.
*/
out vec4 vColor;

void main()
{
	// Transform the input position by the MVP matrix and assign it to the output position.
	gl_Position = uMVP * aPosition;
	
	// Set the varying color to the vertex color value.
	vColor = aColor;
}
