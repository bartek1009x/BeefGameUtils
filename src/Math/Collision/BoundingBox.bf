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

namespace GameUtils.Math.Collision;

using System;
using System.Collections;

/** Encapsulates an axis aligned bounding box represented by a minimum and a maximum Vector. Additionally you can query for the
 * bounding box's center, dimensions and corner points.
 *
 * @author badlogicgames@gmail.com, Xoppa */
public class BoundingBox {
	private static Vector3 tmpVector = new Vector3();

	/** Minimum vector. All XYZ components should be inferior to corresponding max components. Call update() if
	 * you manually change this vector. */
	public Vector3 min = new Vector3();
	/** Maximum vector. All XYZ components should be superior to corresponding min components. Call update() if
	 * you manually change this vector. */
	public Vector3 max = new Vector3();

	private Vector3 cnt = new Vector3();
	private Vector3 dim = new Vector3();

	/** @param out The Vector3 to receive the center of the bounding box.
	 * @return The vector specified with the out argument. */
	public Vector3 getCenter (Vector3 outV) {
		return outV.set(cnt);
	}

	public float getCenterX () {
		return cnt.x;
	}

	public float getCenterY () {
		return cnt.y;
	}

	public float getCenterZ () {
		return cnt.z;
	}

	public Vector3 getCorner000 (Vector3 outV) {
		return outV.set(min.x, min.y, min.z);
	}

	public Vector3 getCorner001 (Vector3 outV) {
		return outV.set(min.x, min.y, max.z);
	}

	public Vector3 getCorner010 (Vector3 outV) {
		return outV.set(min.x, max.y, min.z);
	}

	public Vector3 getCorner011 (Vector3 outV) {
		return outV.set(min.x, max.y, max.z);
	}

	public Vector3 getCorner100 (Vector3 outV) {
		return outV.set(max.x, min.y, min.z);
	}

	public Vector3 getCorner101 (Vector3 outV) {
		return outV.set(max.x, min.y, max.z);
	}

	public Vector3 getCorner110 (Vector3 outV) {
		return outV.set(max.x, max.y, min.z);
	}

	public Vector3 getCorner111 (Vector3 outV) {
		return outV.set(max.x, max.y, max.z);
	}

	/** @param out The Vector3 to receive the dimensions of this bounding box on all three axis.
	 * @return The vector specified with the out argument */
	public Vector3 getDimensions (Vector3 outV) {
		return outV.set(dim);
	}

	public float getWidth () {
		return dim.x;
	}

	public float getHeight () {
		return dim.y;
	}

	public float getDepth () {
		return dim.z;
	}

	/** @param out The Vector3 to receive the minimum values.
	 * @return The vector specified with the out argument */
	public Vector3 getMin (Vector3 outV) {
		return outV.set(min);
	}

	/** @param out The Vector3 to receive the maximum values.
	 * @return The vector specified with the out argument */
	public Vector3 getMax (Vector3 outV) {
		return outV.set(max);
	}

	/** Constructs a new bounding box with the minimum and maximum vector set to zeros. */
	public this() {
		clr();
	}

	/** Constructs a new bounding box from the given bounding box.
	 *
	 * @param bounds The bounding box to copy */
	public this(BoundingBox bounds) {
		this.set(bounds);
	}

	/** Constructs the new bounding box using the given minimum and maximum vector.
	 *
	 * @param minimum The minimum vector
	 * @param maximum The maximum vector */
	public this(Vector3 minimum, Vector3 maximum) {
		this.set(minimum, maximum);
	}

	/** Sets the given bounding box.
	 *
	 * @param bounds The bounds.
	 * @return This bounding box for chaining. */
	public BoundingBox set (BoundingBox bounds) {
		return this.set(bounds.min, bounds.max);
	}

	/** Sets the given minimum and maximum vector.
	 *
	 * @param minimum The minimum vector
	 * @param maximum The maximum vector
	 * @return This bounding box for chaining. */
	public BoundingBox set (Vector3 minimum, Vector3 maximum) {
		min.set(minimum.x < maximum.x ? minimum.x : maximum.x, minimum.y < maximum.y ? minimum.y : maximum.y,
			minimum.z < maximum.z ? minimum.z : maximum.z);
		max.set(minimum.x > maximum.x ? minimum.x : maximum.x, minimum.y > maximum.y ? minimum.y : maximum.y,
			minimum.z > maximum.z ? minimum.z : maximum.z);
		update();
		return this;
	}

	/** Should be called if you modify min and/or max vectors manually. */
	public void update () {
		cnt.set(min).add(max).scl(0.5f);
		dim.set(max).sub(min);
	}

	/** Sets the bounding box minimum and maximum vector from the given points.
	 *
	 * @param points The points.
	 * @return This bounding box for chaining. */
	public BoundingBox set (Vector3[] points) {
		this.inf();
		for (Vector3 l_point in points)
			this.ext(l_point);
		return this;
	}

	/** Sets the bounding box minimum and maximum vector from the given points.
	 *
	 * @param points The points.
	 * @return This bounding box for chaining. */
	public BoundingBox set (List<Vector3> points) {
		this.inf();
		for (Vector3 l_point in points)
			this.ext(l_point);
		return this;
	}

	/** Sets the minimum and maximum vector to positive and negative infinity.
	 *
	 * @return This bounding box for chaining. */
	public BoundingBox inf () {
		min.set(Float.PositiveInfinity, Float.PositiveInfinity, Float.PositiveInfinity);
		max.set(Float.NegativeInfinity, Float.NegativeInfinity, Float.NegativeInfinity);
		cnt.set(0, 0, 0);
		dim.set(0, 0, 0);
		return this;
	}

	/** Extends the bounding box to incorporate the given Vector3.
	 * @param point The vector
	 * @return This bounding box for chaining. */
	public BoundingBox ext (Vector3 point) {
		return this.set(min.set(min(min.x, point.x), min(min.y, point.y), min(min.z, point.z)),
			max.set(Math.Max(max.x, point.x), Math.Max(max.y, point.y), Math.Max(max.z, point.z)));
	}

	/** Sets the minimum and maximum vector to zeros.
	 * @return This bounding box for chaining. */
	public BoundingBox clr () {
		return this.set(min.set(0, 0, 0), max.set(0, 0, 0));
	}

	/** Returns whether this bounding box is valid. This means that max is greater than or equal to min.
	 * @return True in case the bounding box is valid, false otherwise */
	public bool isValid () {
		return min.x <= max.x && min.y <= max.y && min.z <= max.z;
	}

	/** Extends this bounding box by the given bounding box.
	 *
	 * @param a_bounds The bounding box
	 * @return This bounding box for chaining. */
	public BoundingBox ext (BoundingBox a_bounds) {
		return this.set(min.set(min(min.x, a_bounds.min.x), min(min.y, a_bounds.min.y), min(min.z, a_bounds.min.z)),
			max.set(max(max.x, a_bounds.max.x), max(max.y, a_bounds.max.y), max(max.z, a_bounds.max.z)));
	}

	/** Extends this bounding box by the given sphere.
	 *
	 * @param center Sphere center
	 * @param radius Sphere radius
	 * @return This bounding box for chaining. */
	public BoundingBox ext (Vector3 center, float radius) {
		return this.set(min.set(min(min.x, center.x - radius), min(min.y, center.y - radius), min(min.z, center.z - radius)),
			max.set(max(max.x, center.x + radius), max(max.y, center.y + radius), max(max.z, center.z + radius)));
	}

	/** Extends this bounding box by the given transformed bounding box.
	 *
	 * @param bounds The bounding box
	 * @param transform The transformation matrix to apply to bounds, before using it to extend this bounding box.
	 * @return This bounding box for chaining. */
	public BoundingBox ext (BoundingBox bounds, Matrix4 transform) {
		ext(tmpVector.set(bounds.min.x, bounds.min.y, bounds.min.z).mul(transform));
		ext(tmpVector.set(bounds.min.x, bounds.min.y, bounds.max.z).mul(transform));
		ext(tmpVector.set(bounds.min.x, bounds.max.y, bounds.min.z).mul(transform));
		ext(tmpVector.set(bounds.min.x, bounds.max.y, bounds.max.z).mul(transform));
		ext(tmpVector.set(bounds.max.x, bounds.min.y, bounds.min.z).mul(transform));
		ext(tmpVector.set(bounds.max.x, bounds.min.y, bounds.max.z).mul(transform));
		ext(tmpVector.set(bounds.max.x, bounds.max.y, bounds.min.z).mul(transform));
		ext(tmpVector.set(bounds.max.x, bounds.max.y, bounds.max.z).mul(transform));
		return this;
	}

	/** Multiplies the bounding box by the given matrix. This is achieved by multiplying the 8 corner points and then calculating
	 * the minimum and maximum vectors from the transformed points.
	 *
	 * @param transform The matrix
	 * @return This bounding box for chaining. */
	public BoundingBox mul (Matrix4 transform) {
		float x0 = min.x, y0 = min.y, z0 = min.z, x1 = max.x, y1 = max.y, z1 = max.z;
		inf();
		ext(tmpVector.set(x0, y0, z0).mul(transform));
		ext(tmpVector.set(x0, y0, z1).mul(transform));
		ext(tmpVector.set(x0, y1, z0).mul(transform));
		ext(tmpVector.set(x0, y1, z1).mul(transform));
		ext(tmpVector.set(x1, y0, z0).mul(transform));
		ext(tmpVector.set(x1, y0, z1).mul(transform));
		ext(tmpVector.set(x1, y1, z0).mul(transform));
		ext(tmpVector.set(x1, y1, z1).mul(transform));
		return this;
	}

	/** Returns whether the given bounding box is contained in this bounding box.
	 * @param b The bounding box
	 * @return Whether the given bounding box is contained */
	public bool contains (BoundingBox b) {
		return !isValid() || (min.x <= b.min.x && min.y <= b.min.y && min.z <= b.min.z && max.x >= b.max.x && max.y >= b.max.y
			&& max.z >= b.max.z);
	}

	/** Returns whether the given oriented bounding box is contained in this oriented bounding box.
	 * @param obb The bounding box
	 * @return Whether the given oriented bounding box is contained */
	public bool contains (OrientedBoundingBox obb) {
		return contains(obb.getCorner000(tmpVector)) && contains(obb.getCorner001(tmpVector))
			&& contains(obb.getCorner010(tmpVector)) && contains(obb.getCorner011(tmpVector))
			&& contains(obb.getCorner100(tmpVector)) && contains(obb.getCorner101(tmpVector))
			&& contains(obb.getCorner110(tmpVector)) && contains(obb.getCorner111(tmpVector));
	}

	/** Returns whether the given bounding box is intersecting this bounding box (at least one point in).
	 * @param b The bounding box
	 * @return Whether the given bounding box is intersected */
	public bool intersects (BoundingBox b) {
		if (!isValid()) return false;

		// test using SAT (separating axis theorem)

		float lx = Math.Abs(this.cnt.x - b.cnt.x);
		float sumx = (this.dim.x / 2.0f) + (b.dim.x / 2.0f);

		float ly = Math.Abs(this.cnt.y - b.cnt.y);
		float sumy = (this.dim.y / 2.0f) + (b.dim.y / 2.0f);

		float lz = Math.Abs(this.cnt.z - b.cnt.z);
		float sumz = (this.dim.z / 2.0f) + (b.dim.z / 2.0f);

		return (lx <= sumx && ly <= sumy && lz <= sumz);
	}

	/** Returns whether the given vector is contained in this bounding box.
	 * @param v The vector
	 * @return Whether the vector is contained or not. */
	public bool contains (Vector3 v) {
		return min.x <= v.x && max.x >= v.x && min.y <= v.y && max.y >= v.y && min.z <= v.z && max.z >= v.z;
	}

	public override void ToString(String strBuffer) {
		strBuffer.Append(scope $"[{min}|{max}]");
	}

	/** Extends the bounding box by the given vector.
	 *
	 * @param x The x-coordinate
	 * @param y The y-coordinate
	 * @param z The z-coordinate
	 * @return This bounding box for chaining. */
	public BoundingBox ext (float x, float y, float z) {
		return this.set(min.set(min(min.x, x), min(min.y, y), min(min.z, z)), max.set(max(max.x, x), max(max.y, y), max(max.z, z)));
	}

	static float min (float a, float b) {
		return a > b ? b : a;
	}

	static float max (float a, float b) {
		return a > b ? a : b;
	}
}