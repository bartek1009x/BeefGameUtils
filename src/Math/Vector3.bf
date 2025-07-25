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

namespace GameUtils;

using System;

/** Encapsulates a 3D vector. Allows chaining operations by returning a reference to itself in all modification methods.
 * @author badlogicgames@gmail.com */
public class Vector3 : Vector<Vector3> {
	/** the x-component of this vector **/
	public float x;
	/** the y-component of this vector **/
	public float y;
	/** the z-component of this vector **/
	public float z;

	public static readonly Vector3 X = new Vector3(1, 0, 0);
	public static readonly Vector3 Y = new Vector3(0, 1, 0);
	public static readonly Vector3 Z = new Vector3(0, 0, 1);
	public static readonly Vector3 Zero = new Vector3(0, 0, 0);
	public static readonly Vector3 One = new Vector3(1, 1, 1);

	private readonly Matrix4 tmpMat = new Matrix4();

	/** Constructs a vector at (0,0,0) */
	public this() {
	}

	/** Creates a vector with the given components
	 * @param x The x-component
	 * @param y The y-component
	 * @param z The z-component */
	public this(float x, float y, float z) {
		this.set(x, y, z);
	}

	/** Creates a vector from the given vector
	 * @param vector The vector */
	public this(Vector3 vector) {
		this.set(vector);
	}

	/** Creates a vector from the given array. The array must have at least 3 elements.
	 *
	 * @param values The array */
	public this(float[] values) {
		this.set(values[0], values[1], values[2]);
	}

	/** Creates a vector from the given vector and z-component
	 *
	 * @param vector The vector
	 * @param z The z-component */
	public this(Vector2 vector, float z) {
		this.set(vector.x, vector.y, z);
	}

	/** Sets the vector to the given components
	 *
	 * @param x The x-component
	 * @param y The y-component
	 * @param z The z-component
	 * @return this vector for chaining */
	public Vector3 set(float x, float y, float z) {
		this.x = x;
		this.y = y;
		this.z = z;
		return this;
	}

	
	public Vector3 set (Vector3 vector) {
		return this.set(vector.x, vector.y, vector.z);
	}

	/** Sets the components from the array. The array must have at least 3 elements
	 *
	 * @param values The array
	 * @return this vector for chaining */
	public Vector3 set (float[] values) {
		return this.set(values[0], values[1], values[2]);
	}

	/** Sets the components of the given vector and z-component
	 *
	 * @param vector The vector
	 * @param z The z-component
	 * @return This vector for chaining */
	public Vector3 set (Vector2 vector, float z) {
		return this.set(vector.x, vector.y, z);
	}

	/** Sets the components from the given spherical coordinate
	 * @param azimuthalAngle The angle between x-axis in radians [0, 2pi]
	 * @param polarAngle The angle between z-axis in radians [0, pi]
	 * @return This vector for chaining */
	public Vector3 setFromSpherical (float azimuthalAngle, float polarAngle) {
		float cosPolar = Math.Cos(polarAngle);
		float sinPolar = Math.Sin(polarAngle);

		float cosAzim = Math.Cos(azimuthalAngle);
		float sinAzim = Math.Sin(azimuthalAngle);

		return this.set(cosAzim * sinPolar, sinAzim * sinPolar, cosPolar);
	}

	
	public Vector3 setToRandomDirection () {
		float u = MathUtils.random();
		float v = MathUtils.random();

		float theta = MathUtils.PI2 * u; // azimuthal angle
		float phi = (float)Math.Acos(2f * v - 1f); // polar angle

		return this.setFromSpherical(theta, phi);
	}

	
	public Vector3 cpy () {
		return new Vector3(this);
	}

	
	public Vector3 add (Vector3 vector) {
		return this.add(vector.x, vector.y, vector.z);
	}

	/** Adds the given vector to this component
	 * @param x The x-component of the other vector
	 * @param y The y-component of the other vector
	 * @param z The z-component of the other vector
	 * @return This vector for chaining. */
	public Vector3 add (float x, float y, float z) {
		return this.set(this.x + x, this.y + y, this.z + z);
	}

	/** Adds the given value to all three components of the vector.
	 *
	 * @param values The value
	 * @return This vector for chaining */
	public Vector3 add (float values) {
		return this.set(this.x + values, this.y + values, this.z + values);
	}

	
	public Vector3 sub (Vector3 a_vec) {
		return this.sub(a_vec.x, a_vec.y, a_vec.z);
	}

	/** Subtracts the other vector from this vector.
	 *
	 * @param x The x-component of the other vector
	 * @param y The y-component of the other vector
	 * @param z The z-component of the other vector
	 * @return This vector for chaining */
	public Vector3 sub (float x, float y, float z) {
		return this.set(this.x - x, this.y - y, this.z - z);
	}

	/** Subtracts the given value from all components of this vector
	 *
	 * @param value The value
	 * @return This vector for chaining */
	public Vector3 sub (float value) {
		return this.set(this.x - value, this.y - value, this.z - value);
	}

	
	public Vector3 scl (float scalar) {
		return this.set(this.x * scalar, this.y * scalar, this.z * scalar);
	}

	
	public Vector3 scl (Vector3 other) {
		return this.set(x * other.x, y * other.y, z * other.z);
	}

	/** Scales this vector by the given values
	 * @param vx X value
	 * @param vy Y value
	 * @param vz Z value
	 * @return This vector for chaining */
	public Vector3 scl (float vx, float vy, float vz) {
		return this.set(this.x * vx, this.y * vy, this.z * vz);
	}

	
	public Vector3 mulAdd (Vector3 vec, float scalar) {
		this.x += vec.x * scalar;
		this.y += vec.y * scalar;
		this.z += vec.z * scalar;
		return this;
	}

	
	public Vector3 mulAdd (Vector3 vec, Vector3 mulVec) {
		this.x += vec.x * mulVec.x;
		this.y += vec.y * mulVec.y;
		this.z += vec.z * mulVec.z;
		return this;
	}

	/** @return The Euclidean length */
	public static float len (float x, float y, float z) {
		return (float)Math.Sqrt(x * x + y * y + z * z);
	}

	
	public float len () {
		return (float)Math.Sqrt(x * x + y * y + z * z);
	}

	/** @return The squared Euclidean length */
	public static float len2 (float x, float y, float z) {
		return x * x + y * y + z * z;
	}

	
	public float len2 () {
		return x * x + y * y + z * z;
	}

	/** Returns true if this vector and the vector parameter have identical components.
	 * @param vector The other vector
	 * @return Whether this and the other vector are equal with exact precision */
	public bool idt (Vector3 vector) {
		return x == vector.x && y == vector.y && z == vector.z;
	}

	/** @return The Euclidean distance between the two specified vectors */
	public static float dst (float x1, float y1, float z1, float x2, float y2, float z2) {
		readonly float a = x2 - x1;
		readonly float b = y2 - y1;
		readonly float c = z2 - z1;
		return (float)Math.Sqrt(a * a + b * b + c * c);
	}

	
	public float dst (Vector3 vector) {
		readonly float a = vector.x - x;
		readonly float b = vector.y - y;
		readonly float c = vector.z - z;
		return (float)Math.Sqrt(a * a + b * b + c * c);
	}

	/** @return the distance between this point and the given point */
	public float dst (float x, float y, float z) {
		readonly float a = x - this.x;
		readonly float b = y - this.y;
		readonly float c = z - this.z;
		return (float)Math.Sqrt(a * a + b * b + c * c);
	}

	/** @return the squared distance between the given points */
	public static float dst2 (float x1, float y1, float z1, float x2, float y2, float z2) {
		readonly float a = x2 - x1;
		readonly float b = y2 - y1;
		readonly float c = z2 - z1;
		return a * a + b * b + c * c;
	}

	
	public float dst2 (Vector3 point) {
		readonly float a = point.x - x;
		readonly float b = point.y - y;
		readonly float c = point.z - z;
		return a * a + b * b + c * c;
	}

	/** Returns the squared distance between this point and the given point
	 * @param x The x-component of the other point
	 * @param y The y-component of the other point
	 * @param z The z-component of the other point
	 * @return The squared distance */
	public float dst2 (float x, float y, float z) {
		readonly float a = x - this.x;
		readonly float b = y - this.y;
		readonly float c = z - this.z;
		return a * a + b * b + c * c;
	}

	
	public Vector3 nor () {
		readonly float len2 = this.len2();
		if (len2 == 0f || len2 == 1f) return this;
		return this.scl(1f / (float)Math.Sqrt(len2));
	}

	/** @return The dot product between the two vectors */
	public static float dot (float x1, float y1, float z1, float x2, float y2, float z2) {
		return x1 * x2 + y1 * y2 + z1 * z2;
	}

	
	public float dot (Vector3 vector) {
		return x * vector.x + y * vector.y + z * vector.z;
	}

	/** Returns the dot product between this and the given vector.
	 * @param x The x-component of the other vector
	 * @param y The y-component of the other vector
	 * @param z The z-component of the other vector
	 * @return The dot product */
	public float dot (float x, float y, float z) {
		return this.x * x + this.y * y + this.z * z;
	}

	/** Sets this vector to the cross product between it and the other vector.
	 * @param vector The other vector
	 * @return This vector for chaining */
	public Vector3 crs (Vector3 vector) {
		return this.set(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x);
	}

	/** Sets this vector to the cross product between it and the other vector.
	 * @param x The x-component of the other vector
	 * @param y The y-component of the other vector
	 * @param z The z-component of the other vector
	 * @return This vector for chaining */
	public Vector3 crs (float x, float y, float z) {
		return this.set(this.y * z - this.z * y, this.z * x - this.x * z, this.x * y - this.y * x);
	}

	/** Left-multiplies the vector by the given 4x3 column major matrix. The matrix should be composed by a 3x3 matrix representing
	 * rotation and scale plus a 1x3 matrix representing the translation.
	 * @param matrix The matrix
	 * @return This vector for chaining */
	public Vector3 mul4x3 (float[] matrix) {
		return set(x * matrix[0] + y * matrix[3] + z * matrix[6] + matrix[9],
			x * matrix[1] + y * matrix[4] + z * matrix[7] + matrix[10], x * matrix[2] + y * matrix[5] + z * matrix[8] + matrix[11]);
	}

	/** Left-multiplies the vector by the given matrix, assuming the fourth (w) component of the vector is 1.
	 * @param matrix The matrix
	 * @return This vector for chaining */
	public Vector3 mul (Matrix4 matrix) {
		readonly float[] l_mat = matrix.val;
		return this.set(x * l_mat[Matrix4.M00] + y * l_mat[Matrix4.M01] + z * l_mat[Matrix4.M02] + l_mat[Matrix4.M03],
			x * l_mat[Matrix4.M10] + y * l_mat[Matrix4.M11] + z * l_mat[Matrix4.M12] + l_mat[Matrix4.M13],
			x * l_mat[Matrix4.M20] + y * l_mat[Matrix4.M21] + z * l_mat[Matrix4.M22] + l_mat[Matrix4.M23]);
	}

	/** Multiplies the vector by the transpose of the given matrix, assuming the fourth (w) component of the vector is 1.
	 * @param matrix The matrix
	 * @return This vector for chaining */
	public Vector3 traMul (Matrix4 matrix) {
		readonly float[] l_mat = matrix.val;
		return this.set(x * l_mat[Matrix4.M00] + y * l_mat[Matrix4.M10] + z * l_mat[Matrix4.M20] + l_mat[Matrix4.M30],
			x * l_mat[Matrix4.M01] + y * l_mat[Matrix4.M11] + z * l_mat[Matrix4.M21] + l_mat[Matrix4.M31],
			x * l_mat[Matrix4.M02] + y * l_mat[Matrix4.M12] + z * l_mat[Matrix4.M22] + l_mat[Matrix4.M32]);
	}

	/** Left-multiplies the vector by the given matrix.
	 * @param matrix The matrix
	 * @return This vector for chaining */
	public Vector3 mul (Matrix3 matrix) {
		readonly float[] l_mat = matrix.val;
		return set(x * l_mat[Matrix3.M00] + y * l_mat[Matrix3.M01] + z * l_mat[Matrix3.M02],
			x * l_mat[Matrix3.M10] + y * l_mat[Matrix3.M11] + z * l_mat[Matrix3.M12],
			x * l_mat[Matrix3.M20] + y * l_mat[Matrix3.M21] + z * l_mat[Matrix3.M22]);
	}

	/** Multiplies the vector by the transpose of the given matrix.
	 * @param matrix The matrix
	 * @return This vector for chaining */
	public Vector3 traMul (Matrix3 matrix) {
		readonly float[] l_mat = matrix.val;
		return set(x * l_mat[Matrix3.M00] + y * l_mat[Matrix3.M10] + z * l_mat[Matrix3.M20],
			x * l_mat[Matrix3.M01] + y * l_mat[Matrix3.M11] + z * l_mat[Matrix3.M21],
			x * l_mat[Matrix3.M02] + y * l_mat[Matrix3.M12] + z * l_mat[Matrix3.M22]);
	}

	/** Multiplies the vector by the given Quaternion.
	 * @return This vector for chaining */
	public Vector3 mul (Quaternion quat) {
		return quat.transform(this);
	}

	/** Multiplies this vector by the given matrix dividing by w, assuming the fourth (w) component of the vector is 1. This is
	 * mostly used to project/unproject vectors via a perspective projection matrix.
	 *
	 * @param matrix The matrix.
	 * @return This vector for chaining */
	public Vector3 prj (Matrix4 matrix) {
		readonly float[] l_mat = matrix.val;
		readonly float l_w = 1f / (x * l_mat[Matrix4.M30] + y * l_mat[Matrix4.M31] + z * l_mat[Matrix4.M32] + l_mat[Matrix4.M33]);
		return this.set((x * l_mat[Matrix4.M00] + y * l_mat[Matrix4.M01] + z * l_mat[Matrix4.M02] + l_mat[Matrix4.M03]) * l_w,
			(x * l_mat[Matrix4.M10] + y * l_mat[Matrix4.M11] + z * l_mat[Matrix4.M12] + l_mat[Matrix4.M13]) * l_w,
			(x * l_mat[Matrix4.M20] + y * l_mat[Matrix4.M21] + z * l_mat[Matrix4.M22] + l_mat[Matrix4.M23]) * l_w);
	}

	/** Multiplies this vector by the first three columns of the matrix, essentially only applying rotation and scaling.
	 *
	 * @param matrix The matrix
	 * @return This vector for chaining */
	public Vector3 rot (Matrix4 matrix) {
		readonly float[] l_mat = matrix.val;
		return this.set(x * l_mat[Matrix4.M00] + y * l_mat[Matrix4.M01] + z * l_mat[Matrix4.M02],
			x * l_mat[Matrix4.M10] + y * l_mat[Matrix4.M11] + z * l_mat[Matrix4.M12],
			x * l_mat[Matrix4.M20] + y * l_mat[Matrix4.M21] + z * l_mat[Matrix4.M22]);
	}

	/** Multiplies this vector by the transpose of the first three columns of the matrix. Note: only works for translation and
	 * rotation, does not work for scaling. For those, use Matrix4.rot() with Matrix4.inv().
	 * @param matrix The transformation matrix
	 * @return The vector for chaining */
	public Vector3 unrotate (Matrix4 matrix) {
		readonly float[] l_mat = matrix.val;
		return this.set(x * l_mat[Matrix4.M00] + y * l_mat[Matrix4.M10] + z * l_mat[Matrix4.M20],
			x * l_mat[Matrix4.M01] + y * l_mat[Matrix4.M11] + z * l_mat[Matrix4.M21],
			x * l_mat[Matrix4.M02] + y * l_mat[Matrix4.M12] + z * l_mat[Matrix4.M22]);
	}

	/** Translates this vector in the direction opposite to the translation of the matrix and the multiplies this vector by the
	 * transpose of the first three columns of the matrix. Note: only works for translation and rotation, does not work for
	 * scaling. For those, use Matrix4.mul() with Matrix4.inv().
	 * @param matrix The transformation matrix
	 * @return The vector for chaining */
	public Vector3 untransform (Matrix4 matrix) {
		readonly float[] l_mat = matrix.val;
		x -= l_mat[Matrix4.M03];
		y -= l_mat[Matrix4.M03];
		z -= l_mat[Matrix4.M03];
		return this.set(x * l_mat[Matrix4.M00] + y * l_mat[Matrix4.M10] + z * l_mat[Matrix4.M20],
			x * l_mat[Matrix4.M01] + y * l_mat[Matrix4.M11] + z * l_mat[Matrix4.M21],
			x * l_mat[Matrix4.M02] + y * l_mat[Matrix4.M12] + z * l_mat[Matrix4.M22]);
	}

	/** Rotates this vector by the given angle in degrees around the given axis.
	 *
	 * @param degrees the angle in degrees
	 * @param axisX the x-component of the axis
	 * @param axisY the y-component of the axis
	 * @param axisZ the z-component of the axis
	 * @return This vector for chaining */
	public Vector3 rotate (float degrees, float axisX, float axisY, float axisZ) {
		return this.mul(tmpMat.setToRotation(axisX, axisY, axisZ, degrees));
	}

	/** Rotates this vector by the given angle in radians around the given axis.
	 *
	 * @param radians the angle in radians
	 * @param axisX the x-component of the axis
	 * @param axisY the y-component of the axis
	 * @param axisZ the z-component of the axis
	 * @return This vector for chaining */
	public Vector3 rotateRad (float radians, float axisX, float axisY, float axisZ) {
		return this.mul(tmpMat.setToRotationRad(axisX, axisY, axisZ, radians));
	}

	/** Rotates this vector by the given angle in degrees around the given axis.
	 *
	 * @param axis the axis
	 * @param degrees the angle in degrees
	 * @return This vector for chaining */
	public Vector3 rotate (Vector3 axis, float degrees) {
		tmpMat.setToRotation(axis, degrees);
		return this.mul(tmpMat);
	}

	/** Rotates this vector by the given angle in radians around the given axis.
	 *
	 * @param axis the axis
	 * @param radians the angle in radians
	 * @return This vector for chaining */
	public Vector3 rotateRad (Vector3 axis, float radians) {
		tmpMat.setToRotationRad(axis, radians);
		return this.mul(tmpMat);
	}

	
	public bool isUnit () {
		return isUnit(0.000000001f);
	}

	
	public bool isUnit (float margin) {
		return Math.Abs(len2() - 1f) < margin;
	}

	
	public bool isZero () {
		return x == 0 && y == 0 && z == 0;
	}

	
	public bool isZero (float margin) {
		return len2() < margin;
	}

	
	public bool isOnLine (Vector3 other, float epsilon) {
		return len2(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x) <= epsilon;
	}

	
	public bool isOnLine (Vector3 other) {
		return len2(y * other.z - z * other.y, z * other.x - x * other.z,
			x * other.y - y * other.x) <= MathUtils.FLOAT_ROUNDING_ERROR;
	}

	
	public bool isCollinear (Vector3 other, float epsilon) {
		return isOnLine(other, epsilon) && hasSameDirection(other);
	}

	
	public bool isCollinear (Vector3 other) {
		return isOnLine(other) && hasSameDirection(other);
	}

	
	public bool isCollinearOpposite (Vector3 other, float epsilon) {
		return isOnLine(other, epsilon) && hasOppositeDirection(other);
	}

	
	public bool isCollinearOpposite (Vector3 other) {
		return isOnLine(other) && hasOppositeDirection(other);
	}

	
	public bool isPerpendicular (Vector3 vector) {
		return MathUtils.isZero(dot(vector));
	}

	
	public bool isPerpendicular (Vector3 vector, float epsilon) {
		return MathUtils.isZero(dot(vector), epsilon);
	}

	
	public bool hasSameDirection (Vector3 vector) {
		return dot(vector) > 0;
	}

	
	public bool hasOppositeDirection (Vector3 vector) {
		return dot(vector) < 0;
	}

	
	public Vector3 lerp (Vector3 target, float alpha) {
		x += alpha * (target.x - x);
		y += alpha * (target.y - y);
		z += alpha * (target.z - z);
		return this;
	}

	/** Spherically interpolates between this vector and the target vector by alpha which is in the range [0,1]. The result is
	 * stored in this vector.
	 *
	 * @param target The target vector
	 * @param alpha The interpolation coefficient
	 * @return This vector for chaining. */
	public Vector3 slerp (Vector3 target, float alpha) {
		readonly float dot = dot(target);
		// If the inputs are too close for comfort, simply linearly interpolate.
		if (dot > 0.9995 || dot < -0.9995) return lerp(target, alpha);

		// theta0 = angle between input vectors
		readonly float theta0 = (float)Math.Acos(dot);
		// theta = angle between this vector and result
		readonly float theta = theta0 * alpha;

		readonly float st = (float)Math.Sin(theta);
		readonly float tx = target.x - x * dot;
		readonly float ty = target.y - y * dot;
		readonly float tz = target.z - z * dot;
		readonly float l2 = tx * tx + ty * ty + tz * tz;
		readonly float dl = st * ((l2 < 0.0001f) ? 1f : 1f / (float)Math.Sqrt(l2));

		return scl((float)Math.Cos(theta)).add(tx * dl, ty * dl, tz * dl).nor();
	}

	/** Converts this {@code Vector3} to a string in the format {@code (x,y,z)}.
	 * @return a string representation of this object. */
	
	public override void ToString(String strBuffer) {
		strBuffer.Append(scope $"({x}, {y}, {z})");
	}

	/** Sets this {@code Vector3} to the value represented by the specified string according to the format of toString().
	 * @param v the string.
	 * @return this vector for chaining */
	public Vector3 fromString (String v) {
		int s0 = v.IndexOf(',', 1);
		int s1 = v.IndexOf(',', s0 + 1);
		if (s0 != -1 && s1 != -1 && v[0] == '(' && v[v.Length - 1] == ')') {

			if (Float.Parse(v.Substring(1, s0)) case .Ok(let x)) {
				if (Float.Parse(v.Substring(s0 + 1, s1)) case .Ok(let y)) {
					if (Float.Parse(v.Substring(s1 + 1, v.Length - 1)) case .Ok(let z)) {
						return this.set(x, y, z);
					}
				} 
			}
		}

		return null;
	}

	
	public Vector3 limit (float limit) {
		return limit2(limit * limit);
	}

	
	public Vector3 limit2 (float limit2) {
		float len2 = len2();
		if (len2 > limit2) {
			scl((float)Math.Sqrt(limit2 / len2));
		}
		return this;
	}

	
	public Vector3 setLength (float len) {
		return setLength2(len * len);
	}

	
	public Vector3 setLength2 (float len2) {
		float oldLen2 = len2();
		return (oldLen2 == 0 || oldLen2 == len2) ? this : scl((float)Math.Sqrt(len2 / oldLen2));
	}

	
	public Vector3 clamp (float min, float max) {
		readonly float len2 = len2();
		if (len2 == 0f) return this;
		float max2 = max * max;
		if (len2 > max2) return scl((float)Math.Sqrt(max2 / len2));
		float min2 = min * min;
		if (len2 < min2) return scl((float)Math.Sqrt(min2 / len2));
		return this;
	}

	
	public bool equals (Object obj) {
		if (this == obj) return true;
		if (obj == null) return false;
		if (GetType() != obj.GetType()) return false;
		return true;
	}

	
	public bool epsilonEquals (Vector3 other, float epsilon) {
		if (other == null) return false;
		if (Math.Abs(other.x - x) > epsilon) return false;
		if (Math.Abs(other.y - y) > epsilon) return false;
		if (Math.Abs(other.z - z) > epsilon) return false;
		return true;
	}

	/** Compares this vector with the other vector, using the supplied epsilon for fuzzy equality testing.
	 * @return whether the vectors are the same. */
	public bool epsilonEquals (float x, float y, float z, float epsilon) {
		if (Math.Abs(x - this.x) > epsilon) return false;
		if (Math.Abs(y - this.y) > epsilon) return false;
		if (Math.Abs(z - this.z) > epsilon) return false;
		return true;
	}

	/** Compares this vector with the other vector using MathUtils.FLOAT_ROUNDING_ERROR for fuzzy equality testing
	 *
	 * @param other other vector to compare
	 * @return true if vector are equal, otherwise false */
	public bool epsilonEquals (Vector3 other) {
		return epsilonEquals(other, MathUtils.FLOAT_ROUNDING_ERROR);
	}

	/** Compares this vector with the other vector using MathUtils.FLOAT_ROUNDING_ERROR for fuzzy equality testing
	 *
	 * @param x x component of the other vector to compare
	 * @param y y component of the other vector to compare
	 * @param z z component of the other vector to compare
	 * @return true if vector are equal, otherwise false */
	public bool epsilonEquals (float x, float y, float z) {
		return epsilonEquals(x, y, z, MathUtils.FLOAT_ROUNDING_ERROR);
	}

	
	public Vector3 setZero () {
		this.x = 0;
		this.y = 0;
		this.z = 0;
		return this;
	}
}