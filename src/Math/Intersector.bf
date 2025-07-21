/*******************************************************************************
* Copyright 2011 See AUTHORS file.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*   http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
******************************************************************************/

namespace GameUtils.Math;

using System;

public static class Intersector {

	public static bool hasOverlap (Vector3[] axes, Vector3[] aVertices, Vector3[] bVertices) {
		for (Vector3 axis in axes) {
			float minA = Float.MaxValue;
			float maxA = -Float.MaxValue;
			// project shape a on axis
			for (Vector3 aVertex in aVertices) {
				float p = aVertex.dot(axis);
				minA = Math.Min(minA, p);
				maxA = Math.Max(maxA, p);
			}

			float minB = Float.MaxValue;
			float maxB = -Float.MaxValue;
			// project shape b on axis
			for (Vector3 bVertex in bVertices) {
				float p = bVertex.dot(axis);
				minB = Math.Min(minB, p);
				maxB = Math.Max(maxB, p);
			}

			if (maxA < minB || maxB < minA) {
				// Found an axis so the geometries are not intersecting
				return false;
			}
		}

		return true;
	}

}