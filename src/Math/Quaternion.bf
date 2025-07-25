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

/** A simple quaternion class.
 * @see <a href="http://en.wikipedia.org/wiki/Quaternion">http://en.wikipedia.org/wiki/Quaternion</a>
 * @author badlogicgames@gmail.com
 * @author vesuvio
 * @author xoppa */
public class Quaternion {
	private static Quaternion tmp1 = new Quaternion(0, 0, 0, 0);
	private static Quaternion tmp2 = new Quaternion(0, 0, 0, 0);

	public float x;
	public float y;
	public float z;
	public float w;

	/** Constructor, sets the four components of the quaternion.
	 * @param x The x-component
	 * @param y The y-component
	 * @param z The z-component
	 * @param w The w-component */
	public this(float x, float y, float z, float w) {
		this.set(x, y, z, w);
	}

	public this() {
		idt();
	}

	/** Constructor, sets the quaternion components from the given quaternion.
	 * 
	 * @param quaternion The quaternion to copy. */
	public this(Quaternion quaternion) {
		this.set(quaternion);
	}

	/** Constructor, sets the quaternion from the given axis vector and the angle around that axis in degrees.
	 * 
	 * @param axis The axis
	 * @param angle The angle in degrees. */
	public this(Vector3 axis, float angle) {
		this.set(axis, angle);
	}

	/** Sets the components of the quaternion
	 * @param x The x-component
	 * @param y The y-component
	 * @param z The z-component
	 * @param w The w-component
	 * @return This quaternion for chaining */
	public Quaternion set (float x, float y, float z, float w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		return this;
	}

	/** Sets the quaternion components from the given quaternion.
	 * @param quaternion The quaternion.
	 * @return This quaternion for chaining. */
	public Quaternion set (Quaternion quaternion) {
		return this.set(quaternion.x, quaternion.y, quaternion.z, quaternion.w);
	}

	/** Sets the quaternion components from the given axis and angle around that axis.
	 * 
	 * @param axis The axis
	 * @param angle The angle in degrees
	 * @return This quaternion for chaining. */
	public Quaternion set (Vector3 axis, float angle) {
		return setFromAxis(axis.x, axis.y, axis.z, angle);
	}

	/** @return a copy of this quaternion */
	public Quaternion cpy () {
		return new Quaternion(this);
	}

	/** @return the euclidean length of the specified quaternion */
	public static float len (float x, float y, float z, float w) {
		return (float)Math.Sqrt(x * x + y * y + z * z + w * w);
	}

	/** @return the euclidean length of this quaternion */
	public float len () {
		return (float)Math.Sqrt(x * x + y * y + z * z + w * w);
	}

	
	public override void ToString(String strBuffer) {
		strBuffer.Append(scope $"[{x}|{y}|{z}|{w}]");
	}

	/** Sets the quaternion to the given euler angles in degrees.
	 * @param yaw the rotation around the y axis in degrees
	 * @param pitch the rotation around the x axis in degrees
	 * @param roll the rotation around the z axis degrees
	 * @return this quaternion */
	public Quaternion setEulerAngles (float yaw, float pitch, float roll) {
		return setEulerAnglesRad(yaw * MathUtils.degreesToRadians, pitch * MathUtils.degreesToRadians,
			roll * MathUtils.degreesToRadians);
	}

	/** Sets the quaternion to the given euler angles in radians.
	 * @param yaw the rotation around the y axis in radians
	 * @param pitch the rotation around the x axis in radians
	 * @param roll the rotation around the z axis in radians
	 * @return this quaternion */
	public Quaternion setEulerAnglesRad (float yaw, float pitch, float roll) {
		readonly float hr = roll * 0.5f;
		readonly float shr = (float)Math.Sin(hr);
		readonly float chr = (float)Math.Cos(hr);
		readonly float hp = pitch * 0.5f;
		readonly float shp = (float)Math.Sin(hp);
		readonly float chp = (float)Math.Cos(hp);
		readonly float hy = yaw * 0.5f;
		readonly float shy = (float)Math.Sin(hy);
		readonly float chy = (float)Math.Cos(hy);
		readonly float chy_shp = chy * shp;
		readonly float shy_chp = shy * chp;
		readonly float chy_chp = chy * chp;
		readonly float shy_shp = shy * shp;

		x = (chy_shp * chr) + (shy_chp * shr); // cos(yaw/2) * sin(pitch/2) * cos(roll/2) + sin(yaw/2) * cos(pitch/2) * sin(roll/2)
		y = (shy_chp * chr) - (chy_shp * shr); // sin(yaw/2) * cos(pitch/2) * cos(roll/2) - cos(yaw/2) * sin(pitch/2) * sin(roll/2)
		z = (chy_chp * shr) - (shy_shp * chr); // cos(yaw/2) * cos(pitch/2) * sin(roll/2) - sin(yaw/2) * sin(pitch/2) * cos(roll/2)
		w = (chy_chp * chr) + (shy_shp * shr); // cos(yaw/2) * cos(pitch/2) * cos(roll/2) + sin(yaw/2) * sin(pitch/2) * sin(roll/2)
		return this;
	}

	/** Get the pole of the gimbal lock, if any.
	 * @return positive (+1) for north pole, negative (-1) for south pole, zero (0) when no gimbal lock */
	public int getGimbalPole () {
		readonly float t = y * x + z * w;
		return t > 0.499f ? 1 : (t < -0.499f ? -1 : 0);
	}

	/** Get the roll euler angle in radians, which is the rotation around the z axis. Requires that this quaternion is normalized.
	 * @return the rotation around the z axis in radians (between -PI and +PI) */
	public float getRollRad () {
		readonly int pole = getGimbalPole();
		return pole == 0 ? Math.Atan2(2f * (w * z + y * x), 1f - 2f * (x * x + z * z))
			: (float)pole * 2f * Math.Atan2(y, w);
	}

	/** Get the roll euler angle in degrees, which is the rotation around the z axis. Requires that this quaternion is normalized.
	 * @return the rotation around the z axis in degrees (between -180 and +180) */
	public float getRoll () {
		return getRollRad() * MathUtils.radiansToDegrees;
	}

	/** Get the pitch euler angle in radians, which is the rotation around the x axis. Requires that this quaternion is normalized.
	 * @return the rotation around the x axis in radians (between -(PI/2) and +(PI/2)) */
	public float getPitchRad () {
		readonly int pole = getGimbalPole();
		return pole == 0 ? (float)Math.Asin(Math.Clamp(2f * (w * x - z * y), -1f, 1f)) : (float)pole * Math.PI_f * 0.5f;
	}

	/** Get the pitch euler angle in degrees, which is the rotation around the x axis. Requires that this quaternion is normalized.
	 * @return the rotation around the x axis in degrees (between -90 and +90) */
	public float getPitch () {
		return getPitchRad() * MathUtils.radiansToDegrees;
	}

	/** Get the yaw euler angle in radians, which is the rotation around the y axis. Requires that this quaternion is normalized.
	 * @return the rotation around the y axis in radians (between -PI and +PI) */
	public float getYawRad () {
		return getGimbalPole() == 0 ? Math.Atan2(2f * (y * w + x * z), 1f - 2f * (y * y + x * x)) : 0f;
	}

	/** Get the yaw euler angle in degrees, which is the rotation around the y axis. Requires that this quaternion is normalized.
	 * @return the rotation around the y axis in degrees (between -180 and +180) */
	public float getYaw () {
		return getYawRad() * MathUtils.radiansToDegrees;
	}

	public static float len2 (float x, float y, float z, float w) {
		return x * x + y * y + z * z + w * w;
	}

	/** @return the length of this quaternion without square root */
	public float len2 () {
		return x * x + y * y + z * z + w * w;
	}

	/** Normalizes this quaternion to unit length
	 * @return the quaternion for chaining */
	public Quaternion nor () {
		float len = len2();
		if (len != 0.f && !MathUtils.isEqual(len, 1f)) {
			len = (float)Math.Sqrt(len);
			w /= len;
			x /= len;
			y /= len;
			z /= len;
		}
		return this;
	}

	/** Conjugate the quaternion.
	 * 
	 * @return This quaternion for chaining */
	public Quaternion conjugate () {
		x = -x;
		y = -y;
		z = -z;
		return this;
	}

	// TODO : this would better fit into the vector3 class
	/** Transforms the given vector using this quaternion
	 * 
	 * @param v Vector to transform */
	public Vector3 transform (Vector3 v) {
		tmp2.set(this);
		tmp2.conjugate();
		tmp2.mulLeft(tmp1.set(v.x, v.y, v.z, 0)).mulLeft(this);

		v.x = tmp2.x;
		v.y = tmp2.y;
		v.z = tmp2.z;
		return v;
	}

	/** Multiplies this quaternion with another one in the form of this = this * other
	 * 
	 * @param other Quaternion to multiply with
	 * @return This quaternion for chaining */
	public Quaternion mul (Quaternion other) {
		readonly float newX = this.w * other.x + this.x * other.w + this.y * other.z - this.z * other.y;
		readonly float newY = this.w * other.y + this.y * other.w + this.z * other.x - this.x * other.z;
		readonly float newZ = this.w * other.z + this.z * other.w + this.x * other.y - this.y * other.x;
		readonly float newW = this.w * other.w - this.x * other.x - this.y * other.y - this.z * other.z;
		this.x = newX;
		this.y = newY;
		this.z = newZ;
		this.w = newW;
		return this;
	}

	/** Multiplies this quaternion with another one in the form of this = this * other
	 * 
	 * @param x the x component of the other quaternion to multiply with
	 * @param y the y component of the other quaternion to multiply with
	 * @param z the z component of the other quaternion to multiply with
	 * @param w the w component of the other quaternion to multiply with
	 * @return This quaternion for chaining */
	public Quaternion mul (float x, float y, float z, float w) {
		readonly float newX = this.w * x + this.x * w + this.y * z - this.z * y;
		readonly float newY = this.w * y + this.y * w + this.z * x - this.x * z;
		readonly float newZ = this.w * z + this.z * w + this.x * y - this.y * x;
		readonly float newW = this.w * w - this.x * x - this.y * y - this.z * z;
		this.x = newX;
		this.y = newY;
		this.z = newZ;
		this.w = newW;
		return this;
	}

	/** Multiplies this quaternion with another one in the form of this = other * this
	 * 
	 * @param other Quaternion to multiply with
	 * @return This quaternion for chaining */
	public Quaternion mulLeft (Quaternion other) {
		readonly float newX = other.w * this.x + other.x * this.w + other.y * this.z - other.z * this.y;
		readonly float newY = other.w * this.y + other.y * this.w + other.z * this.x - other.x * this.z;
		readonly float newZ = other.w * this.z + other.z * this.w + other.x * this.y - other.y * this.x;
		readonly float newW = other.w * this.w - other.x * this.x - other.y * this.y - other.z * this.z;
		this.x = newX;
		this.y = newY;
		this.z = newZ;
		this.w = newW;
		return this;
	}

	/** Multiplies this quaternion with another one in the form of this = other * this
	 * 
	 * @param x the x component of the other quaternion to multiply with
	 * @param y the y component of the other quaternion to multiply with
	 * @param z the z component of the other quaternion to multiply with
	 * @param w the w component of the other quaternion to multiply with
	 * @return This quaternion for chaining */
	public Quaternion mulLeft (float x, float y, float z, float w) {
		readonly float newX = w * this.x + x * this.w + y * this.z - z * this.y;
		readonly float newY = w * this.y + y * this.w + z * this.x - x * this.z;
		readonly float newZ = w * this.z + z * this.w + x * this.y - y * this.x;
		readonly float newW = w * this.w - x * this.x - y * this.y - z * this.z;
		this.x = newX;
		this.y = newY;
		this.z = newZ;
		this.w = newW;
		return this;
	}

	/** Add the x,y,z,w components of the passed in quaternion to the ones of this quaternion */
	public Quaternion add (Quaternion quaternion) {
		this.x += quaternion.x;
		this.y += quaternion.y;
		this.z += quaternion.z;
		this.w += quaternion.w;
		return this;
	}

	/** Add the x,y,z,w components of the passed in quaternion to the ones of this quaternion */
	public Quaternion add (float qx, float qy, float qz, float qw) {
		this.x += qx;
		this.y += qy;
		this.z += qz;
		this.w += qw;
		return this;
	}

	// TODO : the matrix4 set(quaternion) doesnt set the last row+col of the matrix to 0,0,0,1 so... that's why there is this
// method
	/** Fills a 4x4 matrix with the rotation matrix represented by this quaternion.
	 * 
	 * @param matrix Matrix to fill */
	public void toMatrix (float[] matrix) {
		readonly float xx = x * x;
		readonly float xy = x * y;
		readonly float xz = x * z;
		readonly float xw = x * w;
		readonly float yy = y * y;
		readonly float yz = y * z;
		readonly float yw = y * w;
		readonly float zz = z * z;
		readonly float zw = z * w;
		// Set matrix from quaternion
		matrix[Matrix4.M00] = 1 - 2 * (yy + zz);
		matrix[Matrix4.M01] = 2 * (xy - zw);
		matrix[Matrix4.M02] = 2 * (xz + yw);
		matrix[Matrix4.M03] = 0;
		matrix[Matrix4.M10] = 2 * (xy + zw);
		matrix[Matrix4.M11] = 1 - 2 * (xx + zz);
		matrix[Matrix4.M12] = 2 * (yz - xw);
		matrix[Matrix4.M13] = 0;
		matrix[Matrix4.M20] = 2 * (xz - yw);
		matrix[Matrix4.M21] = 2 * (yz + xw);
		matrix[Matrix4.M22] = 1 - 2 * (xx + yy);
		matrix[Matrix4.M23] = 0;
		matrix[Matrix4.M30] = 0;
		matrix[Matrix4.M31] = 0;
		matrix[Matrix4.M32] = 0;
		matrix[Matrix4.M33] = 1;
	}

	/** Sets the quaternion to an identity Quaternion
	 * @return this quaternion for chaining */
	public Quaternion idt () {
		return this.set(0, 0, 0, 1);
	}

	/** @return If this quaternion is an identity Quaternion */
	public bool isIdentity () {
		return MathUtils.isZero(x) && MathUtils.isZero(y) && MathUtils.isZero(z) && MathUtils.isEqual(w, 1f);
	}

	/** @return If this quaternion is an identity Quaternion */
	public bool isIdentity (float tolerance) {
		return MathUtils.isZero(x, tolerance) && MathUtils.isZero(y, tolerance) && MathUtils.isZero(z, tolerance)
			&& MathUtils.isEqual(w, 1f, tolerance);
	}

	// todo : the setFromAxis(v3,float) method should replace the set(v3,float) method
	/** Sets the quaternion components from the given axis and angle around that axis.
	 * 
	 * @param axis The axis
	 * @param degrees The angle in degrees
	 * @return This quaternion for chaining. */
	public Quaternion setFromAxis (Vector3 axis, float degrees) {
		return setFromAxis(axis.x, axis.y, axis.z, degrees);
	}

	/** Sets the quaternion components from the given axis and angle around that axis.
	 * 
	 * @param axis The axis
	 * @param radians The angle in radians
	 * @return This quaternion for chaining. */
	public Quaternion setFromAxisRad (Vector3 axis, float radians) {
		return setFromAxisRad(axis.x, axis.y, axis.z, radians);
	}

	/** Sets the quaternion components from the given axis and angle around that axis.
	 * @param x X direction of the axis
	 * @param y Y direction of the axis
	 * @param z Z direction of the axis
	 * @param degrees The angle in degrees
	 * @return This quaternion for chaining. */
	public Quaternion setFromAxis (float x, float y, float z, float degrees) {
		return setFromAxisRad(x, y, z, degrees * MathUtils.degreesToRadians);
	}

	/** Sets the quaternion components from the given axis and angle around that axis.
	 * @param x X direction of the axis
	 * @param y Y direction of the axis
	 * @param z Z direction of the axis
	 * @param radians The angle in radians
	 * @return This quaternion for chaining. */
	public Quaternion setFromAxisRad (float x, float y, float z, float radians) {
		float d = Vector3.len(x, y, z);
		if (d == 0f) return idt();
		d = 1f / d;
		float l_ang = radians < 0 ? MathUtils.PI2 - (-radians % MathUtils.PI2) : radians % MathUtils.PI2;
		float l_sin = (float)Math.Sin(l_ang / 2);
		float l_cos = (float)Math.Cos(l_ang / 2);
		return this.set(d * x * l_sin, d * y * l_sin, d * z * l_sin, l_cos).nor();
	}

	/** Sets the Quaternion from the given matrix, optionally removing any scaling. */
	public Quaternion setFromMatrix (bool normalizeAxes, Matrix4 matrix) {
		return setFromAxes(normalizeAxes, matrix.val[Matrix4.M00], matrix.val[Matrix4.M01], matrix.val[Matrix4.M02],
			matrix.val[Matrix4.M10], matrix.val[Matrix4.M11], matrix.val[Matrix4.M12], matrix.val[Matrix4.M20],
			matrix.val[Matrix4.M21], matrix.val[Matrix4.M22]);
	}

	/** Sets the Quaternion from the given rotation matrix, which must not contain scaling. */
	public Quaternion setFromMatrix (Matrix4 matrix) {
		return setFromMatrix(false, matrix);
	}

	/** Sets the Quaternion from the given matrix, optionally removing any scaling. */
	public Quaternion setFromMatrix (bool normalizeAxes, Matrix3 matrix) {
		return setFromAxes(normalizeAxes, matrix.val[Matrix3.M00], matrix.val[Matrix3.M01], matrix.val[Matrix3.M02],
			matrix.val[Matrix3.M10], matrix.val[Matrix3.M11], matrix.val[Matrix3.M12], matrix.val[Matrix3.M20],
			matrix.val[Matrix3.M21], matrix.val[Matrix3.M22]);
	}

	/** Sets the Quaternion from the given rotation matrix, which must not contain scaling. */
	public Quaternion setFromMatrix (Matrix3 matrix) {
		return setFromMatrix(false, matrix);
	}

	/**
	 * <p>
	 * Sets the Quaternion from the given x-, y- and z-axis which have to be orthonormal.
	 * </p>
	 * 
	 * <p>
	 * Taken from Bones framework for JPCT, see http://www.aptalkarga.com/bones/ which in turn took it from Graphics Gem code at
	 * ftp://ftp.cis.upenn.edu/pub/graphics/shoemake/quatut.ps.Z.
	 * </p>
	 * 
	 * @param xx x-axis x-coordinate
	 * @param xy x-axis y-coordinate
	 * @param xz x-axis z-coordinate
	 * @param yx y-axis x-coordinate
	 * @param yy y-axis y-coordinate
	 * @param yz y-axis z-coordinate
	 * @param zx z-axis x-coordinate
	 * @param zy z-axis y-coordinate
	 * @param zz z-axis z-coordinate */
	public Quaternion setFromAxes (float xx, float xy, float xz, float yx, float yy, float yz, float zx, float zy, float zz) {
		return setFromAxes(false, xx, xy, xz, yx, yy, yz, zx, zy, zz);
	}

	/**
	 * <p>
	 * Sets the Quaternion from the given x-, y- and z-axis.
	 * </p>
	 * 
	 * <p>
	 * Taken from Bones framework for JPCT, see http://www.aptalkarga.com/bones/ which in turn took it from Graphics Gem code at
	 * ftp://ftp.cis.upenn.edu/pub/graphics/shoemake/quatut.ps.Z.
	 * </p>
	 * 
	 * @param normalizeAxes whether to normalize the axes (necessary when they contain scaling)
	 * @param xx x-axis x-coordinate
	 * @param xy x-axis y-coordinate
	 * @param xz x-axis z-coordinate
	 * @param yx y-axis x-coordinate
	 * @param yy y-axis y-coordinate
	 * @param yz y-axis z-coordinate
	 * @param zx z-axis x-coordinate
	 * @param zy z-axis y-coordinate
	 * @param zz z-axis z-coordinate */
	public Quaternion setFromAxes (bool normalizeAxes, float xx, float xy, float xz, float yx, float yy, float yz, float zx,
		float zy, float zz) {

			float xx2 = xx;
			float xy2 = xy;
			float xz2 = xz;
			float yx2 = yx;
			float yy2 = yy;
			float yz2 = yz;
			float zx2 = zx;
			float zy2 = zy;
			float zz2 = zz;

		if (normalizeAxes) {
			float lx = 1f / Vector3.len(xx, xy, xz);
			float ly = 1f / Vector3.len(yx, yy, yz);
			float lz = 1f / Vector3.len(zx, zy, zz);

			xx2 *= lx;
			xy2 *= lx;
			xz2 *= lx;
			yx2 *= ly;
			yy2 *= ly;
			yz2 *= ly;
			zx2 *= lz;
			zy2 *= lz;
			zz2 *= lz;
		}
		// the trace is the sum of the diagonal elements; see
		// http://mathworld.wolfram.com/MatrixTrace.html
		readonly float t = xx2 + yy2 + zz2;

		// we protect the division by s by ensuring that s>=1
		if (t >= 0) { // |w| >= .5
			float s = (float)Math.Sqrt(t + 1); // |s|>=1 ...
			w = 0.5f * s;
			s = 0.5f / s; // so this division isn't bad
			x = (zy2 - yz2) * s;
			y = (xz2 - zx2) * s;
			z = (yx2 - xy2) * s;
		} else if ((xx2 > yy2) && (xx2 > zz2)) {
			float s = (float)Math.Sqrt(1.0 + xx2 - yy2 - zz2); // |s|>=1
			x = s * 0.5f; // |x| >= .5
			s = 0.5f / s;
			y = (yx2 + xy2) * s;
			z = (xz2 + zx2) * s;
			w = (zy2 - yz2) * s;
		} else if (yy2 > zz2) {
			float s = (float)Math.Sqrt(1.0 + yy2 - xx2 - zz2); // |s|>=1
			y = s * 0.5f; // |y| >= .5
			s = 0.5f / s;
			x = (yx2 + xy2) * s;
			z = (zy2 + yz2) * s;
			w = (xz2 - zx2) * s;
		} else {
			float s = (float)Math.Sqrt(1.0 + zz2 - xx2 - yy2); // |s|>=1
			z = s * 0.5f; // |z| >= .5
			s = 0.5f / s;
			x = (xz2 + zx2) * s;
			y = (zy2 + yz2) * s;
			w = (yx2 - xy2) * s;
		}

		return this;
	}

	/** Set this quaternion to the rotation between two vectors.
	 * @param v1 The base vector, which should be normalized.
	 * @param v2 The target vector, which should be normalized.
	 * @return This quaternion for chaining */
	public Quaternion setFromCross (Vector3 v1, Vector3 v2) {
		readonly float dot = Math.Clamp(v1.dot(v2), -1f, 1f);
		readonly float angle = (float)Math.Acos(dot);
		return setFromAxisRad(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x, angle);
	}

	/** Set this quaternion to the rotation between two vectors.
	 * @param x1 The base vectors x value, which should be normalized.
	 * @param y1 The base vectors y value, which should be normalized.
	 * @param z1 The base vectors z value, which should be normalized.
	 * @param x2 The target vector x value, which should be normalized.
	 * @param y2 The target vector y value, which should be normalized.
	 * @param z2 The target vector z value, which should be normalized.
	 * @return This quaternion for chaining */
	public Quaternion setFromCross (float x1, float y1, float z1, float x2, float y2,
		float z2) {
		readonly float dot = Math.Clamp(Vector3.dot(x1, y1, z1, x2, y2, z2), -1f, 1f);
		readonly float angle = (float)Math.Acos(dot);
		return setFromAxisRad(y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2, angle);
	}

	/** Spherical linear interpolation between this quaternion and the other quaternion, based on the alpha value in the range
	 * [0,1]. Taken from Bones framework for JPCT, see http://www.aptalkarga.com/bones/
	 * @param end the end quaternion
	 * @param alpha alpha in the range [0,1]
	 * @return this quaternion for chaining */
	public Quaternion slerp (Quaternion end, float alpha) {
		readonly float d = this.x * end.x + this.y * end.y + this.z * end.z + this.w * end.w;
		float absDot = d < 0.f ? -d : d;

		// Set the first and second scale for the interpolation
		float scale0 = 1f - alpha;
		float scale1 = alpha;

		// Check if the angle between the 2 quaternions was big enough to
		// warrant such calculations
		if ((1 - absDot) > 0.1) {// Get the angle between the 2 quaternions,
			// and then store the sin() of that angle
			readonly float angle = (float)Math.Acos(absDot);
			readonly float invSinTheta = 1f / (float)Math.Sin(angle);

			// Calculate the scale for q1 and q2, according to the angle and
			// it's sine value
			scale0 = ((float)Math.Sin((1f - alpha) * angle) * invSinTheta);
			scale1 = ((float)Math.Sin((alpha * angle)) * invSinTheta);
		}

		if (d < 0.f) scale1 = -scale1;

		// Calculate the x, y, z and w values for the quaternion by using a
		// special form of linear interpolation for quaternions.
		x = (scale0 * x) + (scale1 * end.x);
		y = (scale0 * y) + (scale1 * end.y);
		z = (scale0 * z) + (scale1 * end.z);
		w = (scale0 * w) + (scale1 * end.w);

		// Return the interpolated quaternion
		return this;
	}

	/** Spherical linearly interpolates multiple quaternions and stores the result in this Quaternion. Will not destroy the data
	 * previously inside the elements of q. result = (q_1^w_1)*(q_2^w_2)* ... *(q_n^w_n) where w_i=1/n.
	 * @param q List of quaternions
	 * @return This quaternion for chaining */
	public Quaternion slerp (Quaternion[] q) {

		// Calculate exponents and multiply everything from left to right
		readonly float w = 1.0f / q.Count;
		set(q[0]).exp(w);
		for (int i = 1; i < q.Count; i++)
			mul(tmp1.set(q[i]).exp(w));
		nor();
		return this;
	}

	/** Spherical linearly interpolates multiple quaternions by the given weights and stores the result in this Quaternion. Will
	 * not destroy the data previously inside the elements of q or w. result = (q_1^w_1)*(q_2^w_2)* ... *(q_n^w_n) where the sum of
	 * w_i is 1. Lists must be equal in length.
	 * @param q List of quaternions
	 * @param w List of weights
	 * @return This quaternion for chaining */
	public Quaternion slerp (Quaternion[] q, float[] w) {

		// Calculate exponents and multiply everything from left to right
		set(q[0]).exp(w[0]);
		for (int i = 1; i < q.Count; i++)
			mul(tmp1.set(q[i]).exp(w[i]));
		nor();
		return this;
	}

	/** Calculates (this quaternion)^alpha where alpha is a real number and stores the result in this quaternion. See
	 * http://en.wikipedia.org/wiki/Quaternion#Exponential.2C_logarithm.2C_and_power
	 * @param alpha Exponent
	 * @return This quaternion for chaining */
	public Quaternion exp (float alpha) {

		// Calculate |q|^alpha
		float norm = len();
		float normExp = (float)Math.Pow(norm, alpha);

		// Calculate theta
		float theta = (float)Math.Acos(w / norm);

		// Calculate coefficient of basis elements
		float coeff = 0;
		if (Math.Abs(theta) < 0.001) // If theta is small enough, use the limit of sin(alpha*theta) / sin(theta) instead of actual
// value
			coeff = normExp * alpha / norm;
		else
			coeff = (float)(normExp * Math.Sin(alpha * theta) / (norm * Math.Sin(theta)));

		// Write results
		w = (float)(normExp * Math.Cos(alpha * theta));
		x *= coeff;
		y *= coeff;
		z *= coeff;

		// Fix any possible discrepancies
		nor();

		return this;
	}

	
	public bool equals (Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (obj.GetType() != GetType()) {
			return false;
		}
		return true;
	}

	/** Get the dot product between the two quaternions (commutative).
	 * @param x1 the x component of the first quaternion
	 * @param y1 the y component of the first quaternion
	 * @param z1 the z component of the first quaternion
	 * @param w1 the w component of the first quaternion
	 * @param x2 the x component of the second quaternion
	 * @param y2 the y component of the second quaternion
	 * @param z2 the z component of the second quaternion
	 * @param w2 the w component of the second quaternion
	 * @return the dot product between the first and second quaternion. */
	public static float dot (float x1, float y1, float z1, float w1, float x2, float y2,
		float z2, float w2) {
		return x1 * x2 + y1 * y2 + z1 * z2 + w1 * w2;
	}

	/** Get the dot product between this and the other quaternion (commutative).
	 * @param other the other quaternion.
	 * @return the dot product of this and the other quaternion. */
	public float dot (Quaternion other) {
		return this.x * other.x + this.y * other.y + this.z * other.z + this.w * other.w;
	}

	/** Get the dot product between this and the other quaternion (commutative).
	 * @param x the x component of the other quaternion
	 * @param y the y component of the other quaternion
	 * @param z the z component of the other quaternion
	 * @param w the w component of the other quaternion
	 * @return the dot product of this and the other quaternion. */
	public float dot (float x, float y, float z, float w) {
		return this.x * x + this.y * y + this.z * z + this.w * w;
	}

	/** Multiplies the components of this quaternion with the given scalar.
	 * @param scalar the scalar.
	 * @return this quaternion for chaining. */
	public Quaternion mul (float scalar) {
		this.x *= scalar;
		this.y *= scalar;
		this.z *= scalar;
		this.w *= scalar;
		return this;
	}

	/** Get the axis angle representation of the rotation in degrees. The supplied vector will receive the axis (x, y and z values)
	 * of the rotation and the value returned is the angle in degrees around that axis. Note that this method will alter the
	 * supplied vector, the existing value of the vector is ignored.
	 * </p>
	 * This will normalize this quaternion if needed. The received axis is a unit vector. However, if this is an identity
	 * quaternion (no rotation), then the length of the axis may be zero.
	 * 
	 * @param axis vector which will receive the axis
	 * @return the angle in degrees
	 * @see <a href="http://en.wikipedia.org/wiki/Axis%E2%80%93angle_representation">wikipedia</a>
	 * @see <a href="http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle">calculation</a> */
	public float getAxisAngle (Vector3 axis) {
		return getAxisAngleRad(axis) * MathUtils.radiansToDegrees;
	}

	/** Get the axis-angle representation of the rotation in radians. The supplied vector will receive the axis (x, y and z values)
	 * of the rotation and the value returned is the angle in radians around that axis. Note that this method will alter the
	 * supplied vector, the existing value of the vector is ignored.
	 * </p>
	 * This will normalize this quaternion if needed. The received axis is a unit vector. However, if this is an identity
	 * quaternion (no rotation), then the length of the axis may be zero.
	 * 
	 * @param axis vector which will receive the axis
	 * @return the angle in radians
	 * @see <a href="http://en.wikipedia.org/wiki/Axis%E2%80%93angle_representation">wikipedia</a>
	 * @see <a href="http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle">calculation</a> */
	public float getAxisAngleRad (Vector3 axis) {
		if (this.w > 1) this.nor(); // if w>1 acos and sqrt will produce errors, this cant happen if quaternion is normalised
		float angle = (float)(2.0 * Math.Acos(this.w));
		double s = Math.Sqrt(1 - this.w * this.w); // assuming quaternion normalised then w is less than 1, so term always positive.
		if (s < MathUtils.FLOAT_ROUNDING_ERROR) { // test to avoid divide by zero, s is always positive due to sqrt
			// if s close to zero then direction of axis not important
			axis.x = this.x; // if it is important that axis is normalised then replace with x=1; y=z=0;
			axis.y = this.y;
			axis.z = this.z;
		} else {
			axis.x = (float)(this.x / s); // normalise axis
			axis.y = (float)(this.y / s);
			axis.z = (float)(this.z / s);
		}

		return angle;
	}

	/** Get the angle in radians of the rotation this quaternion represents. Does not normalize the quaternion. Use
	 * getAxisAngleRad(Vector3) to get both the axis and the angle of this rotation. Use
	 * getAngleAroundRad(Vector3) to get the angle around a specific axis.
	 * @return the angle in radians of the rotation */
	public float getAngleRad () {
		return (float)(2.0 * Math.Acos((this.w > 1) ? (this.w / len()) : this.w));
	}

	/** Get the angle in degrees of the rotation this quaternion represents. Use getAxisAngle(Vector3) to get both the
	 * axis and the angle of this rotation. Use getAngleAround(Vector3) to get the angle around a specific axis.
	 * @return the angle in degrees of the rotation */
	public float getAngle () {
		return getAngleRad() * MathUtils.radiansToDegrees;
	}

	/** Get the swing rotation and twist rotation for the specified axis. The twist rotation represents the rotation around the
	 * specified axis. The swing rotation represents the rotation of the specified axis itself, which is the rotation around an
	 * axis perpendicular to the specified axis.
	 * </p>
	 * The swing and twist rotation can be used to reconstruct the original quaternion: this = swing * twist
	 * 
	 * @param axisX the X component of the normalized axis for which to get the swing and twist rotation
	 * @param axisY the Y component of the normalized axis for which to get the swing and twist rotation
	 * @param axisZ the Z component of the normalized axis for which to get the swing and twist rotation
	 * @param swing will receive the swing rotation: the rotation around an axis perpendicular to the specified axis
	 * @param twist will receive the twist rotation: the rotation around the specified axis
	 * @see <a href="http://www.euclideanspace.com/maths/geometry/rotations/for/decomposition">calculation</a> */
	public void getSwingTwist (float axisX, float axisY, float axisZ, Quaternion swing,
		Quaternion twist) {
		readonly float d = Vector3.dot(this.x, this.y, this.z, axisX, axisY, axisZ);
		twist.set(axisX * d, axisY * d, axisZ * d, this.w).nor();
		if (d < 0) twist.mul(-1f);
		swing.set(twist).conjugate().mulLeft(this);
	}

	/** Get the swing rotation and twist rotation for the specified axis. The twist rotation represents the rotation around the
	 * specified axis. The swing rotation represents the rotation of the specified axis itself, which is the rotation around an
	 * axis perpendicular to the specified axis.
	 * </p>
	 * The swing and twist rotation can be used to reconstruct the original quaternion: this = swing * twist
	 * 
	 * @param axis the normalized axis for which to get the swing and twist rotation
	 * @param swing will receive the swing rotation: the rotation around an axis perpendicular to the specified axis
	 * @param twist will receive the twist rotation: the rotation around the specified axis
	 * @see <a href="http://www.euclideanspace.com/maths/geometry/rotations/for/decomposition">calculation</a> */
	public void getSwingTwist (Vector3 axis, Quaternion swing, Quaternion twist) {
		getSwingTwist(axis.x, axis.y, axis.z, swing, twist);
	}

	/** Get the angle in radians of the rotation around the specified axis. The axis must be normalized.
	 * @param axisX the x component of the normalized axis for which to get the angle
	 * @param axisY the y component of the normalized axis for which to get the angle
	 * @param axisZ the z component of the normalized axis for which to get the angle
	 * @return the angle in radians of the rotation around the specified axis */
	public float getAngleAroundRad (float axisX, float axisY, float axisZ) {
		readonly float d = Vector3.dot(this.x, this.y, this.z, axisX, axisY, axisZ);
		readonly float l2 = Quaternion.len2(axisX * d, axisY * d, axisZ * d, this.w);
		return MathUtils.isZero(l2) ? 0f
			: (float)(2.0 * Math.Acos(Math.Clamp((float)((d < 0 ? -this.w : this.w) / Math.Sqrt(l2)), -1f, 1f)));
	}

	/** Get the angle in radians of the rotation around the specified axis. The axis must be normalized.
	 * @param axis the normalized axis for which to get the angle
	 * @return the angle in radians of the rotation around the specified axis */
	public float getAngleAroundRad (Vector3 axis) {
		return getAngleAroundRad(axis.x, axis.y, axis.z);
	}

	/** Get the angle in degrees of the rotation around the specified axis. The axis must be normalized.
	 * @param axisX the x component of the normalized axis for which to get the angle
	 * @param axisY the y component of the normalized axis for which to get the angle
	 * @param axisZ the z component of the normalized axis for which to get the angle
	 * @return the angle in degrees of the rotation around the specified axis */
	public float getAngleAround (float axisX, float axisY, float axisZ) {
		return getAngleAroundRad(axisX, axisY, axisZ) * MathUtils.radiansToDegrees;
	}

	/** Get the angle in degrees of the rotation around the specified axis. The axis must be normalized.
	 * @param axis the normalized axis for which to get the angle
	 * @return the angle in degrees of the rotation around the specified axis */
	public float getAngleAround (Vector3 axis) {
		return getAngleAround(axis.x, axis.y, axis.z);
	}
}