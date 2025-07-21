// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

using System;

namespace GameUtils
{
    /// <summary>
    /// Converts base data types to an array of bytes, and an array of bytes to base data types.
    /// </summary>
    public static class BitConverter
    {
        // This field indicates the "endianness" of the architecture.
        // The value is set to true if the architecture is
        // little endian; false if it is big endian.
#if BIGENDIAN
        public static readonly bool IsLittleEndian /* = false */;
#else
        public static readonly bool IsLittleEndian = true;
#endif

        /// <summary>
        /// Returns the specified Boolean value as a byte array.
        /// </summary>
        /// <param name="value">A Boolean value.</param>
        /// <returns>A byte array with length 1.</returns>
        public static uint8[] GetBytes(bool value)
        {
            uint8[] r = new uint8[1];
            r[0] = (value ? (int8)1 : (int8)0);
            return r;
        }

        /// <summary>
        /// Converts a Boolean into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted Boolean.</param>
        /// <param name="value">The Boolean to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<uint8> destination, bool value)
        {
            if (destination.Length < sizeof(uint8))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value ? (uint8)1 : (uint8)0);
            return true;
        }

        /// <summary>
        /// Returns the specified Unicode character value as a byte array.
        /// </summary>
        /// <param name="value">A char16 value.</param>
        /// <returns>An array of bytes with length 2.</returns>
        public static int8[] GetBytes(char16 value)
        {
            int8[] bytes = new int8[sizeof(char16)];
            Unsafe.As<int8, char>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a character into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted character.</param>
        /// <param name="value">The character to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<uint8> destination, char16 value)
        {
            if (destination.Length < sizeof(char16))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified 16-bit signed integer value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 2.</returns>
        public static int8[] GetBytes(int16 value)
        {
            int8[] bytes = new int8[sizeof(int16)];
            Unsafe.As<int8, int16>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a 16-bit signed integer into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted 16-bit signed integer.</param>
        /// <param name="value">The 16-bit signed integer to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<int8> destination, int16 value)
        {
            if (destination.Length < sizeof(int16))
                return false;
			
            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified 32-bit signed integer value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 4.</returns>
        public static int8[] GetBytes(int value)
        {
            int8[] bytes = new int8[sizeof(int)];
            Unsafe.As<int8, int>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a 32-bit signed integer into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted 32-bit signed integer.</param>
        /// <param name="value">The 32-bit signed integer to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<int8> destination, int32 value)
        {
            if (destination.Length < sizeof(int32))
                return false;

			
            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified 64-bit signed integer value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 8.</returns>
        public static int8[] GetBytes(int64 value)
        {
            int8[] bytes = new int8[sizeof(int64)];
            Unsafe.As<uint8, int64>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a 64-bit signed integer into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted 64-bit signed integer.</param>
        /// <param name="value">The 64-bit signed integer to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<int8> destination, int64 value)
        {
            if (destination.Length < sizeof(int64))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified 16-bit unsigned integer value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 2.</returns>
        public static int8[] GetBytes(uint16 value)
        {
            int8[] bytes = new int8[sizeof(uint16)];
            Unsafe.As<int8, uint16>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a 16-bit unsigned integer into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted 16-bit unsigned integer.</param>
        /// <param name="value">The 16-bit unsigned integer to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<byte> destination, uint16 value)
        {
            if (destination.Length < sizeof(uint16))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified 32-bit unsigned integer value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 4.</returns>
        public static uint8[] GetBytes(uint value)
        {
            uint8[] bytes = new byte[sizeof(uint)];
            Unsafe.As<byte, uint>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a 32-bit unsigned integer into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted 32-bit unsigned integer.</param>
        /// <param name="value">The 32-bit unsigned integer to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<byte> destination, uint value)
        {
            if (destination.Length < sizeof(uint))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified 64-bit signed integer value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 8.</returns>
        public static uint8[] GetBytes(uint64 value)
        {
            uint8[] bytes = new byte[sizeof(uint64)];
            Unsafe.As<byte, uint64>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a 64-bit unsigned integer into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted 64-bit unsigned integer.</param>
        /// <param name="value">The 64-bit unsigned integer to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<byte> destination, uint64 value)
        {
            if (destination.Length < sizeof(uint64))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified half-precision floating point value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 2.</returns>
        public static unsafe uint8[] GetBytes(Half value)
        {
            uint8[] bytes = new byte[sizeof(Half)];
            Unsafe.As<byte, Half>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a half-precision floating-point value into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted half-precision floating-point value.</param>
        /// <param name="value">The half-precision floating-point value to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static unsafe bool TryWriteBytes(Span<byte> destination, Half value)
        {
            if (destination.Length < sizeof(Half))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified single-precision floating point value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 4.</returns>
        public static uint8[] GetBytes(float value)
        {
            uint8[] bytes = new byte[sizeof(float)];
            Unsafe.As<byte, float>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a single-precision floating-point value into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted single-precision floating-point value.</param>
        /// <param name="value">The single-precision floating-point value to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<byte> destination, float value)
        {
            if (destination.Length < sizeof(float))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns the specified double-precision floating point value as an array of bytes.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>An array of bytes with length 8.</returns>
        public static uint8[] GetBytes(double value)
        {
            uint8[] bytes = new byte[sizeof(double)];
            Unsafe.As<byte, double>(ref bytes[0]) = value;
            return bytes;
        }

        /// <summary>
        /// Converts a double-precision floating-point value into a span of bytes.
        /// </summary>
        /// <param name="destination">When this method returns, the bytes representing the converted double-precision floating-point value.</param>
        /// <param name="value">The double-precision floating-point value to convert.</param>
        /// <returns><see langword="true"/> if the conversion was successful; <see langword="false"/> otherwise.</returns>
        public static bool TryWriteBytes(Span<byte> destination, double value)
        {
            if (destination.Length < sizeof(double))
                return false;

            Unsafe.WriteUnaligned(ref MemoryMarshal.GetReference(destination), value);
            return true;
        }

        /// <summary>
        /// Returns a Unicode character converted from two bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A character formed by two bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException"><paramref name="startIndex"/> equals the length of <paramref name="value"/> minus 1.</exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static char16 ToChar(uint8[] value, int startIndex) => unchecked((char)ToInt16(value, startIndex));

        /// <summary>
        /// Converts a read-only byte span into a character.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A character representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than the length of a <see cref="char"/>.</exception>
        [Inline]
        public static char16 ToChar(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(char))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<char>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a 16-bit signed integer converted from two bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A 16-bit signed integer formed by two bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException"><paramref name="startIndex"/> equals the length of <paramref name="value"/> minus 1.</exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static int16 ToInt16(uint8[] value, int startIndex)
        {
            if (value == null)
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.value);
            if (unchecked((uint)startIndex) >= unchecked((uint)value.Length))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.startIndex, ExceptionResource.ArgumentOutOfRange_IndexMustBeLess);
            if (startIndex > value.Length - sizeof(int16))
                ThrowHelper.ThrowArgumentException(ExceptionResource.Arg_ByteArrayTooSmallForValue, ExceptionArgument.value);

            return Unsafe.ReadUnaligned<int16>(ref value[startIndex]);
        }

        /// <summary>
        /// Converts a read-only byte span into a 16-bit signed integer.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A 16-bit signed integer representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 2.</exception>
        [Inline]
        public static int16 ToInt16(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(int16))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<int16>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a 32-bit signed integer converted from four bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A 32-bit signed integer formed by four bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException">
        /// <paramref name="startIndex"/> is greater than or equal to the length of <paramref name="value"/> minus 3,
        /// and is less than or equal to the length of <paramref name="value"/> minus 1.
        /// </exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static int ToInt32(uint8[] value, int startIndex)
        {
            if (value == null)
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.value);
            if (unchecked((uint)startIndex) >= unchecked((uint)value.Length))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.startIndex, ExceptionResource.ArgumentOutOfRange_IndexMustBeLess);
            if (startIndex > value.Length - sizeof(int))
                ThrowHelper.ThrowArgumentException(ExceptionResource.Arg_ByteArrayTooSmallForValue, ExceptionArgument.value);

            return Unsafe.ReadUnaligned<int>(ref value[startIndex]);
        }

        /// <summary>
        /// Converts a read-only byte span into a 32-bit signed integer.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A 32-bit signed integer representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 4.</exception>
        [Inline]
        public static int ToInt32(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(int))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<int>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a 64-bit signed integer converted from eight bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A 64-bit signed integer formed by eight bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException">
        /// <paramref name="startIndex"/> is greater than or equal to the length of <paramref name="value"/> minus 7,
        /// and is less than or equal to the length of <paramref name="value"/> minus 1.
        /// </exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static long ToInt64(uint8[] value, int startIndex)
        {
            if (value == null)
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.value);
            if (unchecked((uint)startIndex) >= unchecked((uint)value.Length))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.startIndex, ExceptionResource.ArgumentOutOfRange_IndexMustBeLess);
            if (startIndex > value.Length - sizeof(long))
                ThrowHelper.ThrowArgumentException(ExceptionResource.Arg_ByteArrayTooSmallForValue, ExceptionArgument.value);

            return Unsafe.ReadUnaligned<long>(ref value[startIndex]);
        }

        /// <summary>
        /// Converts a read-only byte span into a 64-bit signed integer.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A 64-bit signed integer representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 8.</exception>
        [Inline]
        public static long ToInt64(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(long))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<long>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a 16-bit unsigned integer converted from two bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A 16-bit unsigned integer formed by two bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException"><paramref name="startIndex"/> equals the length of <paramref name="value"/> minus 1.</exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static uint16 ToUInt16(uint8[] value, int startIndex) => unchecked((uint16)ToInt16(value, startIndex));

        /// <summary>
        /// Converts a read-only byte span into a 16-bit unsigned integer.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A 16-bit unsigned integer representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 2.</exception>
        [Inline]
        public static uint16 ToUInt16(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(uint16))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<uint16>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a 32-bit unsigned integer converted from four bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A 32-bit unsigned integer formed by four bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException">
        /// <paramref name="startIndex"/> is greater than or equal to the length of <paramref name="value"/> minus 3,
        /// and is less than or equal to the length of <paramref name="value"/> minus 1.
        /// </exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static uint ToUInt32(uint8[] value, int startIndex) => unchecked((uint)ToInt32(value, startIndex));

        /// <summary>
        /// Converts a read-only byte span into a 32-bit unsigned integer.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A 32-bit unsigned integer representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 4.</exception>
        [Inline]
        public static uint ToUInt32(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(uint))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<uint>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a 64-bit unsigned integer converted from four bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A 64-bit unsigned integer formed by eight bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException">
        /// <paramref name="startIndex"/> is greater than or equal to the length of <paramref name="value"/> minus 7,
        /// and is less than or equal to the length of <paramref name="value"/> minus 1.
        /// </exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static uint64 ToUInt64(uint8[] value, int startIndex) => unchecked((uint64)ToInt64(value, startIndex));

        /// <summary>
        /// Converts a read-only byte span into a 64-bit unsigned integer.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A 64-bit unsigned integer representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 8.</exception>
        [Inline]
        public static uint64 ToUInt64(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(uint64))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<uint64>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a half-precision floating point number converted from two bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A half-precision floating point number signed integer formed by two bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException"><paramref name="startIndex"/> equals the length of <paramref name="value"/> minus 1.</exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static Half ToHalf(uint8[] value, int startIndex) => Int16BitsToHalf(ToInt16(value, startIndex));

        /// <summary>
        /// Converts a read-only byte span into a half-precision floating-point value.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A half-precision floating-point value representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 2.</exception>
        [Inline]
        public static unsafe Half ToHalf(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(Half))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<Half>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a single-precision floating point number converted from four bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A single-precision floating point number formed by four bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException">
        /// <paramref name="startIndex"/> is greater than or equal to the length of <paramref name="value"/> minus 3,
        /// and is less than or equal to the length of <paramref name="value"/> minus 1.
        /// </exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static float ToSingle(uint8[] value, int startIndex) => Int32BitsToSingle(ToInt32(value, startIndex));

        /// <summary>
        /// Converts a read-only byte span into a single-precision floating-point value.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A single-precision floating-point value representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 4.</exception>
        [Inline]
        public static float ToSingle(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(float))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<float>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Returns a double-precision floating point number converted from four bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A double-precision floating point number formed by eight bytes beginning at <paramref name="startIndex"/>.</returns>
        /// <exception cref="ArgumentException">
        /// <paramref name="startIndex"/> is greater than or equal to the length of <paramref name="value"/> minus 7,
        /// and is less than or equal to the length of <paramref name="value"/> minus 1.
        /// </exception>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static double ToDouble(uint8[] value, int startIndex) => Int64BitsToDouble(ToInt64(value, startIndex));

        /// <summary>
        /// Converts a read-only byte span into a double-precision floating-point value.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A double-precision floating-point value representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 8.</exception>
        [Inline]
        public static double ToDouble(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(double))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<double>(ref MemoryMarshal.GetReference(value));
        }

        /// <summary>
        /// Converts the numeric value of each element of a specified array of bytes
        /// to its equivalent hexadecimal string representation.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <param name="length">The number of array elements in <paramref name="value"/> to convert.</param>
        /// <returns>A string of hexadecimal pairs separated by hyphens,
        /// where each pair represents the corresponding element in a subarray of <paramref name="value"/>;
        /// for example, "7F-2C-4A-00".</returns>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is <see langword="null"/>.</exception>
        /// <exception cref="ArgumentOutOfRangeException">
        /// <paramref name="startIndex"/> or <paramref name="length"/> is less than zero.
        /// <para>-or-</para>
        /// <paramref name="startIndex"/> is greater than zero and is greater than or equal to the length of <paramref name="value"/>.
        /// </exception>
        /// <exception cref="ArgumentException">
        /// The combination of <paramref name="startIndex"/> and <paramref name="length"/> does not specify a position within <paramref name="value"/>;
        /// that is, the <paramref name="startIndex"/> parameter is greater than the length of <paramref name="value"/> minus the <paramref name="length"/> parameter.
        /// </exception>
        public static string ToString(uint8[] value, int startIndex, int length)
        {
            if (value == null)
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.value);
            if (startIndex < 0 || startIndex >= value.Length && startIndex > 0)
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.startIndex, ExceptionResource.ArgumentOutOfRange_IndexMustBeLess);
            ArgumentOutOfRangeException.ThrowIfNegative(length);
            if (startIndex > value.Length - length)
                ThrowHelper.ThrowArgumentException(ExceptionResource.Arg_ByteArrayTooSmallForValue, ExceptionArgument.value);

            if (length == 0)
            {
                return string.Empty;
            }

            // (int.MaxValue / 3) == 715,827,882 Bytes == 699 MB
            ArgumentOutOfRangeException.ThrowIfGreaterThan(length, int.MaxValue / 3);

            string result = string.FastAllocateString(length * 3 - 1);

            var dst = new Span<char>(ref result.GetRawStringData(), result.Length);
            var src = new ReadOnlySpan<byte>(value, startIndex, length);
            int i = 0;
            int j = 0;
            byte b = src[i++];
            dst[j++] = HexConverter.ToCharUpper(b >> 4);
            dst[j++] = HexConverter.ToCharUpper(b);
            while (i < src.Length)
            {
                b = src[i++];
                dst[j++] = '-';
                dst[j++] = HexConverter.ToCharUpper(b >> 4);
                dst[j++] = HexConverter.ToCharUpper(b);
            }

            return result;
        }

        /// <summary>
        /// Converts the numeric value of each element of a specified array of bytes
        /// to its equivalent hexadecimal string representation.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <returns>A string of hexadecimal pairs separated by hyphens,
        /// where each pair represents the corresponding element in <paramref name="value"/>;
        /// for example, "7F-2C-4A-00".</returns>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is <see langword="null"/>.</exception>
        public static string ToString(uint8[] value)
        {
            if (value == null)
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.value);
            return ToString(value, 0, value.Length);
        }

        /// <summary>
        /// Converts the numeric value of each element of a specified array of bytes
        /// to its equivalent hexadecimal string representation.
        /// </summary>
        /// <param name="value">An array of bytes.</param>
        /// <param name="startIndex">The starting position within <paramref name="value"/>.</param>
        /// <returns>A string of hexadecimal pairs separated by hyphens,
        /// where each pair represents the corresponding element in a subarray of <paramref name="value"/>;
        /// for example, "7F-2C-4A-00".</returns>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is <see langword="null"/>.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static string ToString(uint8[] value, int startIndex)
        {
            if (value == null)
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.value);
            return ToString(value, startIndex, value.Length - startIndex);
        }

        /// <summary>
        /// Returns a Boolean value converted from two bytes at a specified position in a byte array.
        /// </summary>
        /// <param name="value">A byte array.</param>
        /// <param name="startIndex">The index of the byte within <paramref name="value"/>.</param>
        /// <returns><see langword="true"/> if the byte at <paramref name="startIndex"/> is nonzero; otherwise <see langword="false"/>.</returns>
        /// <exception cref="ArgumentNullException"><paramref name="value"/> is null.</exception>
        /// <exception cref="ArgumentOutOfRangeException"><paramref name="startIndex"/> is less than zero or greater than the length of <paramref name="value"/> minus 1.</exception>
        public static bool ToBoolean(uint8[] value, int startIndex)
        {
            if (value == null)
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.value);
            if (startIndex < 0)
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.startIndex, ExceptionResource.ArgumentOutOfRange_IndexMustBeLess);
            if (startIndex >= value.Length)
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.startIndex, ExceptionResource.ArgumentOutOfRange_IndexMustBeLess); // differs from other overloads, which throw base ArgumentException

            return value[startIndex] != 0;
        }

        /// <summary>
        /// Converts a read-only byte span into a Boolean value.
        /// </summary>
        /// <param name="value">A read-only span containing the bytes to convert.</param>
        /// <returns>A Boolean representing the converted bytes.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The length of <paramref name="value"/> is less than 1.</exception>
        [Inline]
        public static bool ToBoolean(ReadOnlySpan<byte> value)
        {
            if (value.Length < sizeof(byte))
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.value);
            return Unsafe.ReadUnaligned<byte>(ref MemoryMarshal.GetReference(value)) != 0;
        }

        /// <summary>
        /// Converts the specified double-precision floating point number to a 64-bit signed integer.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A 64-bit signed integer whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe long DoubleToInt64Bits(double value) => Unsafe.BitCast<double, long>(value);

        /// <summary>
        /// Converts the specified 64-bit signed integer to a double-precision floating point number.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A double-precision floating point number whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe double Int64BitsToDouble(long value) => Unsafe.BitCast<long, double>(value);

        /// <summary>
        /// Converts the specified single-precision floating point number to a 32-bit signed integer.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A 32-bit signed integer whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe int SingleToInt32Bits(float value) => Unsafe.BitCast<float, int>(value);

        /// <summary>
        /// Converts the specified 32-bit signed integer to a single-precision floating point number.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A single-precision floating point number whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe float Int32BitsToSingle(int value) => Unsafe.BitCast<int, float>(value);

        /// <summary>
        /// Converts the specified half-precision floating point number to a 16-bit signed integer.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A 16-bit signed integer whose bits are identical to <paramref name="value"/>.</returns>
        [Inline]
        public static unsafe int16 HalfToInt16Bits(Half value) => (int16)value._value;

        /// <summary>
        /// Converts the specified 16-bit signed integer to a half-precision floating point number.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A half-precision floating point number whose bits are identical to <paramref name="value"/>.</returns>
        [Inline]
        public static unsafe Half Int16BitsToHalf(int16 value) => new Half((uint16)(value));

        /// <summary>
        /// Converts the specified double-precision floating point number to a 64-bit unsigned integer.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A 64-bit unsigned integer whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe uint64 DoubleToUInt64Bits(double value) => Unsafe.BitCast<double, uint64>(value);

        /// <summary>
        /// Converts the specified 64-bit unsigned integer to a double-precision floating point number.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A double-precision floating point number whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe double UInt64BitsToDouble(uint64 value) => Unsafe.BitCast<uint64, double>(value);

        /// <summary>
        /// Converts the specified single-precision floating point number to a 32-bit unsigned integer.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A 32-bit unsigned integer whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe uint SingleToUInt32Bits(float value) => Unsafe.BitCast<float, uint>(value);

        /// <summary>
        /// Converts the specified 32-bit unsigned integer to a single-precision floating point number.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A single-precision floating point number whose bits are identical to <paramref name="value"/>.</returns>
        public static unsafe float UInt32BitsToSingle(uint value) => Unsafe.BitCast<uint, float>(value);

        /// <summary>
        /// Converts the specified half-precision floating point number to a 16-bit unsigned integer.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A 16-bit unsigned integer whose bits are identical to <paramref name="value"/>.</returns>
        [Inline]
        public static unsafe uint16 HalfToUInt16Bits(Half value) => value._value;

        /// <summary>
        /// Converts the specified 16-bit unsigned integer to a half-precision floating point number.
        /// </summary>
        /// <param name="value">The number to convert.</param>
        /// <returns>A half-precision floating point number whose bits are identical to <paramref name="value"/>.</returns>
        [Inline]
        public static unsafe Half UInt16BitsToHalf(uint16 value) => new Half(value);
    }
}