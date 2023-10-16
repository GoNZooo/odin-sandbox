package bits_and_bobs

// bytes: [4]u8 = {0x12, 0x34, 0x56, 0x78}
// x_little_endian := transmute(u32le)bytes
// x_big_endian := transmute(u32be)bytes
// x_default := transmute(u32)bytes
//
// fmt.printf("x_little_endian\t: %d\t(%#x)\n", x_little_endian, x_little_endian)
// fmt.printf("x_big_endian\t: %d\t(%#x)\n", x_big_endian, x_big_endian)
// fmt.printf("x_default\t: %d\t(%#x)\n", x_default, x_default)
