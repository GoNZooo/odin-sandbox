package byte_order

import "core:fmt"

// byte ordering
// endianness

// Big-endian:
// MSB        LSB
//  00 11 22 33

// Little-endian:
// LSB        MSB
//  33 22 11 00

main :: proc() {
	x: u32 = 0x18_4d_22_04
	x_bytes := transmute([4]byte)x

	x_le: u32le = 0x18_4d_22_04
	x_le_bytes := transmute([4]byte)x_le

	x_be: u32be = 0x18_4d_22_04
	x_be_bytes := transmute([4]byte)x_be

	fmt.printf("Default:\t%d = %x\t(%02x)\n", x, x, x_bytes)
	fmt.printf("Little Endian:\t%d = %x\t(%02x)\n", x_le, x_le, x_le_bytes)
	fmt.printf("Big Endian:\t%d = %x\t(%02x)\n", x_be, x_be, x_be_bytes)
}
