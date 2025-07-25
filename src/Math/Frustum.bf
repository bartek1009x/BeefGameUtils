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

using GameUtils.Math.Collision;

/** A truncated rectangular pyramid. Used to define the viewable region and its projection onto the screen.
 * @see Camera#frustum */
public class Frustum {
	protected static Vector3[?] clipSpacePlanePoints = .(new Vector3(-1, -1, -1), new Vector3(1, -1, -1), new Vector3(1, 1, -1), new Vector3(-1, 1, -1), new Vector3(-1, -1, 1), new Vector3(1, -1, 1), new Vector3(1, 1, 1), new Vector3(-1, 1, 1));
	protected static float[] clipSpacePlanePointsArray = new float[8 * 3];

	private static Vector3 tmpV = new Vector3();

	/** the six clipping planes, near, far, left, right, top, bottom **/
	public Plane[] planes = new Plane[6];

	/** eight points making up the near and far clipping "rectangles". order is counter clockwise, starting at bottom left **/
	public Vector3[?] planePoints = .(new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(),
		new Vector3(), new Vector3());
	protected float[] planePointsArray = new float[8 * 3];

	static this() {
		int j = 0;
		for (Vector3 v in clipSpacePlanePoints) {
			clipSpacePlanePointsArray[j++] = v.x;
			clipSpacePlanePointsArray[j++] = v.y;
			clipSpacePlanePointsArray[j++] = v.z;
		}
	}

	public this() {
		for (int i = 0; i < 6; i++) {
			planes[i] = new Plane(new Vector3(), 0);
		}
	}

	/** Updates the clipping plane's based on the given inverse combined projection and view matrix, e.g. from an
	 * OrthographicCamera or PerspectiveCamera.
	 * @param inverseProjectionView the combined projection and view matrices. */
	public void update (Matrix4 inverseProjectionView) {
		clipSpacePlanePointsArray.CopyTo(planePointsArray);
		Matrix4.prj(inverseProjectionView.val, planePointsArray, 0, 8, 3);
		for (int i = 0, j = 0; i < 8; i++) {
			Vector3 v = planePoints[i];
			v.x = planePointsArray[j++];
			v.y = planePointsArray[j++];
			v.z = planePointsArray[j++];
		}

		planes[0].set(planePoints[1], planePoints[0], planePoints[2]);
		planes[1].set(planePoints[4], planePoints[5], planePoints[7]);
		planes[2].set(planePoints[0], planePoints[4], planePoints[3]);
		planes[3].set(planePoints[5], planePoints[1], planePoints[6]);
		planes[4].set(planePoints[2], planePoints[3], planePoints[6]);
		planes[5].set(planePoints[4], planePoints[0], planePoints[1]);
	}

	/** Returns whether the point is in the frustum.
	 * 
	 * @param point The point
	 * @return Whether the point is in the frustum. */
	public bool pointInFrustum (Vector3 point) {
		for (int i = 0; i < planes.Count; i++) {
			Plane.PlaneSide result = planes[i].testPoint(point);
			if (result == Plane.PlaneSide.Back) return false;
		}
		return true;
	}

	/** Returns whether the point is in the frustum.
	 * 
	 * @param x The X coordinate of the point
	 * @param y The Y coordinate of the point
	 * @param z The Z coordinate of the point
	 * @return Whether the point is in the frustum. */
	public bool pointInFrustum (float x, float y, float z) {
		for (int i = 0; i < planes.Count; i++) {
			Plane.PlaneSide result = planes[i].testPoint(x, y, z);
			if (result == Plane.PlaneSide.Back) return false;
		}
		return true;
	}

	/** Returns whether the given sphere is in the frustum.
	 * 
	 * @param center The center of the sphere
	 * @param radius The radius of the sphere
	 * @return Whether the sphere is in the frustum */
	public bool sphereInFrustum (Vector3 center, float radius) {
		for (int i = 0; i < 6; i++)
			if ((planes[i].normal.x * center.x + planes[i].normal.y * center.y + planes[i].normal.z * center.z) < (-radius
				- planes[i].d)) return false;
		return true;
	}

	/** Returns whether the given sphere is in the frustum.
	 * 
	 * @param x The X coordinate of the center of the sphere
	 * @param y The Y coordinate of the center of the sphere
	 * @param z The Z coordinate of the center of the sphere
	 * @param radius The radius of the sphere
	 * @return Whether the sphere is in the frustum */
	public bool sphereInFrustum (float x, float y, float z, float radius) {
		for (int i = 0; i < 6; i++)
			if ((planes[i].normal.x * x + planes[i].normal.y * y + planes[i].normal.z * z) < (-radius - planes[i].d)) return false;
		return true;
	}

	/** Returns whether the given sphere is in the frustum not checking whether it is behind the near and far clipping plane.
	 * 
	 * @param center The center of the sphere
	 * @param radius The radius of the sphere
	 * @return Whether the sphere is in the frustum */
	public bool sphereInFrustumWithoutNearFar (Vector3 center, float radius) {
		for (int i = 2; i < 6; i++)
			if ((planes[i].normal.x * center.x + planes[i].normal.y * center.y + planes[i].normal.z * center.z) < (-radius
				- planes[i].d)) return false;
		return true;
	}

	/** Returns whether the given sphere is in the frustum not checking whether it is behind the near and far clipping plane.
	 * 
	 * @param x The X coordinate of the center of the sphere
	 * @param y The Y coordinate of the center of the sphere
	 * @param z The Z coordinate of the center of the sphere
	 * @param radius The radius of the sphere
	 * @return Whether the sphere is in the frustum */
	public bool sphereInFrustumWithoutNearFar (float x, float y, float z, float radius) {
		for (int i = 2; i < 6; i++)
			if ((planes[i].normal.x * x + planes[i].normal.y * y + planes[i].normal.z * z) < (-radius - planes[i].d)) return false;
		return true;
	}

	/** Returns whether the given BoundingBox is in the frustum.
	 * 
	 * @param bounds The bounding box
	 * @return Whether the bounding box is in the frustum */
	public bool boundsInFrustum (BoundingBox bounds) {
		for (int i = 0, len2 = planes.Count; i < len2; i++) {
			if (planes[i].testPoint(bounds.getCorner000(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(bounds.getCorner001(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(bounds.getCorner010(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(bounds.getCorner011(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(bounds.getCorner100(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(bounds.getCorner101(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(bounds.getCorner110(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(bounds.getCorner111(tmpV)) != Plane.PlaneSide.Back) continue;
			return false;
		}

		return true;
	}

	/** Returns whether the given bounding box is in the frustum.
	 * @return Whether the bounding box is in the frustum */
	public bool boundsInFrustum (Vector3 center, Vector3 dimensions) {
		return boundsInFrustum(center.x, center.y, center.z, dimensions.x / 2, dimensions.y / 2, dimensions.z / 2);
	}

	/** Returns whether the given bounding box is in the frustum.
	 * @return Whether the bounding box is in the frustum */
	public bool boundsInFrustum (float x, float y, float z, float halfWidth, float halfHeight, float halfDepth) {
		for (int i = 0, len2 = planes.Count; i < len2; i++) {
			if (planes[i].testPoint(x + halfWidth, y + halfHeight, z + halfDepth) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(x + halfWidth, y + halfHeight, z - halfDepth) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(x + halfWidth, y - halfHeight, z + halfDepth) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(x + halfWidth, y - halfHeight, z - halfDepth) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(x - halfWidth, y + halfHeight, z + halfDepth) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(x - halfWidth, y + halfHeight, z - halfDepth) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(x - halfWidth, y - halfHeight, z + halfDepth) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(x - halfWidth, y - halfHeight, z - halfDepth) != Plane.PlaneSide.Back) continue;
			return false;
		}

		return true;
	}

	/** Returns whether the given OrientedBoundingBox is in the frustum.
	 *
	 * @param obb The oriented bounding box
	 * @return Whether the oriented bounding box is in the frustum */
	public bool boundsInFrustum (OrientedBoundingBox obb) {
		for (int i = 0, len2 = planes.Count; i < len2; i++) {
			if (planes[i].testPoint(obb.getCorner000(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(obb.getCorner001(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(obb.getCorner010(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(obb.getCorner011(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(obb.getCorner100(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(obb.getCorner101(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(obb.getCorner110(tmpV)) != Plane.PlaneSide.Back) continue;
			if (planes[i].testPoint(obb.getCorner111(tmpV)) != Plane.PlaneSide.Back) continue;
			return false;
		}

		return true;
	}
}