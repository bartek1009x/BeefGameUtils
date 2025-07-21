namespace GameUtils;

using System;

public static class NumberUtils {

	public static floatToRawIntBits(float value) {
		byte[] bytes = BitConverter.G(value);

		int result = BitConverter.ToInt32(bytes, 0);
	}

	public static int floatToIntBits (float value) {
		return Float.floatToIntBits(value);
	}

	public static int floatToRawIntBits (float value) {
		return Float.floatToRawIntBits(value);
	}

	/** Converts the color from a float ABGR encoding to an int ABGR encoding. The alpha is expanded from 0-254 in the float
	 * encoding (see {@link #intToFloatColor(int)}) to 0-255, which means converting from int to float and back to int can be
	 * lossy. */
	public static int floatToIntColor (float value) {
		int intBits = Float.floatToRawIntBits(value);
		intBits |= (int)((intBits >>> 24) * (255f / 254f)) << 24;
		return intBits;
	}

	/** Encodes the ABGR int color as a float. The alpha is compressed to use only even numbers between 0-254 to avoid using bits
	 * in the NaN range (see {@link Float#intBitsToFloat(int)} javadocs). Rendering which uses colors encoded as floats should
	 * expand the 0-254 back to 0-255, else colors cannot be fully opaque. */
	public static float intToFloatColor (int value) {
		return Float.intBitsToFloat(value & 0xfeffffff);
	}

	public static float intBitsToFloat (int value) {
		return Float.intBitsToFloat(value);
	}

	public static long doubleToLongBits (double value) {
		return Double.doubleToLongBits(value);
	}

	public static double longBitsToDouble (long value) {
		return Double.longBitsToDouble(value);
	}
}