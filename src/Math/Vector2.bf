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

/** Encapsulates a 2D vector. Allows chaining methods by returning a reference to itself
 * @author badlogicgames@gmail.com */
public class Vector2 : Vector<Vector2> {

	public static readonly Vector2 X = new Vector2(1, 0);
	public static readonly Vector2 Y = new Vector2(0, 1);
	public static readonly Vector2 Zero = new Vector2(0, 0);
	public static readonly Vector2 One = new Vector2(1, 1);

	/** the x-component of this vector **/
	public float x;
	/** the y-component of this vector **/
	public float y;

	/** Constructs a new vector at (0,0) */
	public this() {
	}

	/** Constructs a vector with the given components
	 * @param x The x-component
	 * @param y The y-component */
	public this(float x, float y) {
		this.x = x;
		this.y = y;
	}

	/** Constructs a vector from the given vector
	 * @param v The vector */
	public this(Vector2 v) {
		set(v);
	}

	
	public Vector2 cpy () {
		return new Vector2(this);
	}

	public static float len (float x, float y) {
		return (float)Math.Sqrt(x * x + y * y);
	}

	
	public float len () {
		return (float)Math.Sqrt(x * x + y * y);
	}

	public static float len2 (float x, float y) {
		return x * x + y * y;
	}

	
	public float len2 () {
		return x * x + y * y;
	}

	
	public Vector2 set (Vector2 v) {
		x = v.x;
		y = v.y;
		return this;
	}

	/** Sets the components of this vector
	 * @param x The x-component
	 * @param y The y-component
	 * @return This vector for chaining */
	public Vector2 set (float x, float y) {
		this.x = x;
		this.y = y;
		return this;
	}

	
	public Vector2 sub (Vector2 v) {
		x -= v.x;
		y -= v.y;
		return this;
	}

	/** Subtracts the other vector from this vector.
	 * @param x The x-component of the other vector
	 * @param y The y-component of the other vector
	 * @return This vector for chaining */
	public Vector2 sub (float x, float y) {
		this.x -= x;
		this.y -= y;
		return this;
	}

	
	public Vector2 nor () {
		float len = len();
		if (len != 0) {
			x /= len;
			y /= len;
		}
		return this;
	}

	
	public Vector2 add (Vector2 v) {
		x += v.x;
		y += v.y;
		return this;
	}

	/** Adds the given components to this vector
	 * @param x The x-component
	 * @param y The y-component
	 * @return This vector for chaining */
	public Vector2 add (float x, float y) {
		this.x += x;
		this.y += y;
		return this;
	}

	public static float dot (float x1, float y1, float x2, float y2) {
		return x1 * x2 + y1 * y2;
	}

	
	public float dot (Vector2 v) {
		return x * v.x + y * v.y;
	}

	public float dot (float ox, float oy) {
		return x * ox + y * oy;
	}

	
	public Vector2 scl (float scalar) {
		x *= scalar;
		y *= scalar;
		return this;
	}

	/** Multiplies this vector by a scalar
	 * @return This vector for chaining */
	public Vector2 scl (float x, float y) {
		this.x *= x;
		this.y *= y;
		return this;
	}

	
	public Vector2 scl (Vector2 v) {
		this.x *= v.x;
		this.y *= v.y;
		return this;
	}

	
	public Vector2 mulAdd (Vector2 vec, float scalar) {
		this.x += vec.x * scalar;
		this.y += vec.y * scalar;
		return this;
	}

	
	public Vector2 mulAdd (Vector2 vec, Vector2 mulVec) {
		this.x += vec.x * mulVec.x;
		this.y += vec.y * mulVec.y;
		return this;
	}

	/** Returns true if this vector and the vector parameter have identical components.
	 * @param vector The other vector
	 * @return Whether this and the other vector are equal with exact precision */
	public bool idt (Vector2 vector) {
		return x == vector.x && y == vector.y;
	}

	public static float dst (float x1, float y1, float x2, float y2) {
		readonly float x_d = x2 - x1;
		readonly float y_d = y2 - y1;
		return (float)Math.Sqrt(x_d * x_d + y_d * y_d);
	}

	
	public float dst (Vector2 v) {
		readonly float x_d = v.x - x;
		readonly float y_d = v.y - y;
		return (float)Math.Sqrt(x_d * x_d + y_d * y_d);
	}

	/** @param x The x-component of the other vector
	 * @param y The y-component of the other vector
	 * @return the distance between this and the other vector */
	public float dst (float x, float y) {
		readonly float x_d = x - this.x;
		readonly float y_d = y - this.y;
		return (float)Math.Sqrt(x_d * x_d + y_d * y_d);
	}

	public static float dst2 (float x1, float y1, float x2, float y2) {
		readonly float x_d = x2 - x1;
		readonly float y_d = y2 - y1;
		return x_d * x_d + y_d * y_d;
	}

	
	public float dst2 (Vector2 v) {
		readonly float x_d = v.x - x;
		readonly float y_d = v.y - y;
		return x_d * x_d + y_d * y_d;
	}

	/** @param x The x-component of the other vector
	 * @param y The y-component of the other vector
	 * @return the squared distance between this and the other vector */
	public float dst2 (float x, float y) {
		readonly float x_d = x - this.x;
		readonly float y_d = y - this.y;
		return x_d * x_d + y_d * y_d;
	}

	
	public Vector2 limit (float limit) {
		return limit2(limit * limit);
	}

	
	public Vector2 limit2 (float limit2) {
		float len2 = len2();
		if (len2 > limit2) {
			return scl((float)Math.Sqrt(limit2 / len2));
		}
		return this;
	}

	
	public Vector2 clamp (float min, float max) {
		readonly float len2 = len2();
		if (len2 == 0f) return this;
		float max2 = max * max;
		if (len2 > max2) return scl((float)Math.Sqrt(max2 / len2));
		float min2 = min * min;
		if (len2 < min2) return scl((float)Math.Sqrt(min2 / len2));
		return this;
	}

	
	public Vector2 setLength (float len) {
		return setLength2(len * len);
	}

	
	public Vector2 setLength2 (float len2) {
		float oldLen2 = len2();
		return (oldLen2 == 0 || oldLen2 == len2) ? this : scl((float)Math.Sqrt(len2 / oldLen2));
	}

	/** Converts this {@code Vector2} to a string in the format {@code (x,y)}.
	 * @return a string representation of this object. */
	
	public override void ToString(String strBuffer) {
		strBuffer.Append(scope $"({x},{y})");
	}

	/** Sets this {@code Vector2} to the value represented by the specified string according to the format of toString().
	 * @param v the string.
	 * @return this vector for chaining */
	public Vector2 fromString (String v) {
		int s = v.IndexOf(',', 1);
		if (s != -1 && v[0] == '(' && v[v.Length - 1] == ')') {

			if (Float.Parse(v.Substring(1, s)) case .Ok(let x)) {
				if (Float.Parse(v.Substring(s + 1, v.Length - 1)) case .Ok(let y)) {
					return this.set(x, y);
				} 
			}
		}

		return null;
	}

	/** Left-multiplies this vector by the given matrix
	 * @param mat the matrix
	 * @return this vector */
	public Vector2 mul (Matrix3 mat) {
		float x = this.x * mat.val[0] + this.y * mat.val[3] + mat.val[6];
		float y = this.x * mat.val[1] + this.y * mat.val[4] + mat.val[7];
		this.x = x;
		this.y = y;
		return this;
	}

	/** Calculates the 2D cross product between this and the given vector.
	 * @param v the other vector
	 * @return the cross product */
	public float crs (Vector2 v) {
		return this.x * v.y - this.y * v.x;
	}

	/** Calculates the 2D cross product between this and the given vector.
	 * @param x the x-coordinate of the other vector
	 * @param y the y-coordinate of the other vector
	 * @return the cross product */
	public float crs (float x, float y) {
		return this.x * y - this.y * x;
	}

	/** @return the angle in degrees of this vector (point) relative to the x-axis. Angles are towards the positive y-axis
	 *         (typically counter-clockwise) and between 0 and 360.
	 * // Deprecated use angleDeg() instead. */
	// Deprecated
	public float angle () {
		float angle = (float)Math.Atan2(y, x) * MathUtils.radiansToDegrees;
		if (angle < 0) angle += 360;
		return angle;
	}

	/** @return the angle in degrees of this vector (point) relative to the given vector. Angles are towards the negative y-axis
	 *         (typically clockwise) between -180 and +180
	 * // Deprecated use angleDeg(Vector2) instead. Beware of the changes in returned angle to counter-clockwise and the
	 *             range. */
	// Deprecated
	public float angle (Vector2 reference) {
		return (float)Math.Atan2(crs(reference), dot(reference)) * MathUtils.radiansToDegrees;
	}

	/** @return the angle in degrees of this vector (point) relative to the x-axis. Angles are towards the positive y-axis
	 *         (typically counter-clockwise) and in the [0, 360) range. */
	public float angleDeg () {
		float angle = (float)Math.Atan2(y, x) * MathUtils.radiansToDegrees;
		if (angle < 0) angle += 360;
		return angle;
	}

	/** @return the angle in degrees of this vector (point) relative to the given vector. Angles are towards the positive y-axis
	 *         (typically counter-clockwise.) in the [0, 360) range */
	public float angleDeg (Vector2 reference) {
		float angle = (float)Math.Atan2(reference.crs(this), reference.dot(this)) * MathUtils.radiansToDegrees;
		if (angle < 0) angle += 360;
		return angle;
	}

	/** @return the angle in degrees of this vector (point) relative to the x-axis. Angles are towards the positive y-axis
	 *         (typically counter-clockwise) and in the [0, 360) range. */
	public static float angleDeg (float x, float y) {
		float angle = (float)Math.Atan2(y, x) * MathUtils.radiansToDegrees;
		if (angle < 0) angle += 360;
		return angle;
	}

	/** @return the angle in radians of this vector (point) relative to the x-axis. Angles are towards the positive y-axis.
	 *         (typically counter-clockwise) */
	public float angleRad () {
		return (float)Math.Atan2(y, x);
	}

	/** @return the angle in radians of this vector (point) relative to the given vector. Angles are towards the positive y-axis.
	 *         (typically counter-clockwise.) */
	public float angleRad (Vector2 reference) {
		return (float)Math.Atan2(reference.crs(this), reference.dot(this));
	}

	/** @return the angle in radians of this vector (point) relative to the x-axis. Angles are towards the positive y-axis.
	 *         (typically counter-clockwise) */
	public static float angleRad (float x, float y) {
		return (float)Math.Atan2(y, x);
	}

	/** Sets the angle of the vector in degrees relative to the x-axis, towards the positive y-axis (typically counter-clockwise).
	 * @param degrees The angle in degrees to set.
	 * // Deprecated use setAngleDeg(float) instead. */
	// Deprecated
	public Vector2 setAngle (float degrees) {
		return setAngleRad(degrees * MathUtils.degreesToRadians);
	}

	/** Sets the angle of the vector in degrees relative to the x-axis, towards the positive y-axis (typically counter-clockwise).
	 * @param degrees The angle in degrees to set. */
	public Vector2 setAngleDeg (float degrees) {
		return setAngleRad(degrees * MathUtils.degreesToRadians);
	}

	/** Sets the angle of the vector in radians relative to the x-axis, towards the positive y-axis (typically counter-clockwise).
	 * @param radians The angle in radians to set. */
	public Vector2 setAngleRad (float radians) {
		this.set(len(), 0f);
		this.rotateRad(radians);

		return this;
	}

	/** Rotates the Vector2 by the given angle, counter-clockwise assuming the y-axis points up.
	 * @param degrees the angle in degrees
	 * // Deprecated use rotateDeg(float) instead. */
	// Deprecated
	public Vector2 rotate (float degrees) {
		return rotateRad(degrees * MathUtils.degreesToRadians);
	}

	/** Rotates the Vector2 by the given angle around reference vector, counter-clockwise assuming the y-axis points up.
	 * @param degrees the angle in degrees
	 * @param reference center Vector2
	 * @deprecated use rotateAroundDeg(Vector2, float) instead. */
	// Deprecated
	public Vector2 rotateAround (Vector2 reference, float degrees) {
		return this.sub(reference).rotateDeg(degrees).add(reference);
	}

	/** Rotates the Vector2 by the given angle, counter-clockwise assuming the y-axis points up.
	 * @param degrees the angle in degrees */
	public Vector2 rotateDeg (float degrees) {
		return rotateRad(degrees * MathUtils.degreesToRadians);
	}

	/** Rotates the Vector2 by the given angle, counter-clockwise assuming the y-axis points up.
	 * @param radians the angle in radians */
	public Vector2 rotateRad (float radians) {
		float cos = (float)Math.Cos(radians);
		float sin = (float)Math.Sin(radians);

		float newX = this.x * cos - this.y * sin;
		float newY = this.x * sin + this.y * cos;

		this.x = newX;
		this.y = newY;

		return this;
	}

	/** Rotates the Vector2 by the given angle around reference vector, counter-clockwise assuming the y-axis points up.
	 * @param degrees the angle in degrees
	 * @param reference center Vector2 */
	public Vector2 rotateAroundDeg (Vector2 reference, float degrees) {
		return this.sub(reference).rotateDeg(degrees).add(reference);
	}

	/** Rotates the Vector2 by the given angle around reference vector, counter-clockwise assuming the y-axis points up.
	 * @param radians the angle in radians
	 * @param reference center Vector2 */
	public Vector2 rotateAroundRad (Vector2 reference, float radians) {
		return this.sub(reference).rotateRad(radians).add(reference);
	}

	/** Rotates the Vector2 by 90 degrees in the specified direction, where >= 0 is counter-clockwise and < 0 is clockwise. */
	public Vector2 rotate90 (int dir) {
		float x = this.x;
		if (dir >= 0) {
			this.x = -y;
			y = x;
		} else {
			this.x = y;
			y = -x;
		}
		return this;
	}

	
	public Vector2 lerp (Vector2 target, float alpha) {
		readonly float invAlpha = 1.0f - alpha;
		this.x = (x * invAlpha) + (target.x * alpha);
		this.y = (y * invAlpha) + (target.y * alpha);
		return this;
	}
	
	public Vector2 setToRandomDirection () {
		float theta = MathUtils.random(0, (int) MathUtils.PI2);
		return this.set(Math.Cos(theta), Math.Sin(theta));
	}
	
	public bool equals (Object obj) {
		if (this == obj) return true;
		if (obj == null) return false;
		if (GetType() != obj.GetType()) return false;
		return true;
	}

	
	public bool epsilonEquals (Vector2 other, float epsilon) {
		if (other == null) return false;
		if (Math.Abs(other.x - x) > epsilon) return false;
		if (Math.Abs(other.y - y) > epsilon) return false;
		return true;
	}

	/** Compares this vector with the other vector, using the supplied epsilon for fuzzy equality testing.
	 * @return whether the vectors are the same. */
	public bool epsilonEquals (float x, float y, float epsilon) {
		if (Math.Abs(x - this.x) > epsilon) return false;
		if (Math.Abs(y - this.y) > epsilon) return false;
		return true;
	}

	/** Compares this vector with the other vector using MathUtils.FLOAT_ROUNDING_ERROR for fuzzy equality testing
	 * @param other other vector to compare
	 * @return true if vector are equal, otherwise false */
	public bool epsilonEquals (Vector2 other) {
		return epsilonEquals(other, MathUtils.FLOAT_ROUNDING_ERROR);
	}

	/** Compares this vector with the other vector using MathUtils.FLOAT_ROUNDING_ERROR for fuzzy equality testing
	 * @param x x component of the other vector to compare
	 * @param y y component of the other vector to compare
	 * @return true if vector are equal, otherwise false */
	public bool epsilonEquals (float x, float y) {
		return epsilonEquals(x, y, MathUtils.FLOAT_ROUNDING_ERROR);
	}

	
	public bool isUnit () {
		return isUnit(0.000000001f);
	}

	
	public bool isUnit (float margin) {
		return Math.Abs(len2() - 1f) < margin;
	}

	
	public bool isZero () {
		return x == 0 && y == 0;
	}

	
	public bool isZero (float margin) {
		return len2() < margin;
	}

	
	public bool isOnLine (Vector2 other) {
		return MathUtils.isZero(x * other.y - y * other.x);
	}

	
	public bool isOnLine (Vector2 other, float epsilon) {
		return MathUtils.isZero(x * other.y - y * other.x, epsilon);
	}

	
	public bool isCollinear (Vector2 other, float epsilon) {
		return isOnLine(other, epsilon) && dot(other) > 0f;
	}

	
	public bool isCollinear (Vector2 other) {
		return isOnLine(other) && dot(other) > 0f;
	}

	
	public bool isCollinearOpposite (Vector2 other, float epsilon) {
		return isOnLine(other, epsilon) && dot(other) < 0f;
	}

	
	public bool isCollinearOpposite (Vector2 other) {
		return isOnLine(other) && dot(other) < 0f;
	}

	
	public bool isPerpendicular (Vector2 vector) {
		return MathUtils.isZero(dot(vector));
	}

	
	public bool isPerpendicular (Vector2 vector, float epsilon) {
		return MathUtils.isZero(dot(vector), epsilon);
	}

	
	public bool hasSameDirection (Vector2 vector) {
		return dot(vector) > 0;
	}

	
	public bool hasOppositeDirection (Vector2 vector) {
		return dot(vector) < 0;
	}

	
	public Vector2 setZero () {
		this.x = 0;
		this.y = 0;
		return this;
	}
}