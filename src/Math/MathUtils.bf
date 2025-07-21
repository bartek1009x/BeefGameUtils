namespace GameUtils;

using System;

public static struct MathUtils
{

	public const float FLOAT_ROUNDING_ERROR = 0.000001f; // 32 bits

	public const float PI2 = Math.PI_f*2;
	public const float degreesToRadians = Math.PI_f / 180;
	public const float radiansToDegrees = 180f / Math.PI_f;

	/** Returns true if the value is zero (using the default tolerance as upper bound) */
	static public bool isZero (float value) {
		return Math.Abs(value) <= FLOAT_ROUNDING_ERROR;
	}

	/** Returns true if the value is zero.
	 * @param tolerance represent an upper bound below which the value is considered zero. */
	static public bool isZero (float value, float tolerance) {
		return Math.Abs(value) <= tolerance;
	}

	/** Returns true if a is nearly equal to b. The function uses the default floating error tolerance.
	 * @param a the first value.
	 * @param b the second value. */
	static public bool isEqual (float a, float b) {
		return Math.Abs(a - b) <= FLOAT_ROUNDING_ERROR;
	}

	/** Returns true if a is nearly equal to b.
	 * @param a the first value.
	 * @param b the second value.
	 * @param tolerance represent an upper bound below which the two values are considered equal. */
	static public bool isEqual (float a, float b, float tolerance) {
		return Math.Abs(a - b) <= tolerance;
	}


	static public Random random = new Random();

	static public int random (int range) {
		return random.Next(range + 1);
	}

	static public int random (int start, int end) {
		return start + random.Next(end - start + 1);
	}

	static public float random () {
		return (float) random.NextDouble();
	}

	public static float cosDeg(float degrees)
	{
	    return (float)Math.Cos(degrees * Math.PI_f / 180.0);
	}

	public static float sinDeg(float degrees)
	{
	    return (float)Math.Sin(degrees * Math.PI_f / 180.0);
	}

}