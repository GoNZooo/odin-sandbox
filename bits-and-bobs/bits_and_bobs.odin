package bits_and_bobs

import "core:fmt"

// 128 64 32 16   8 4 2 1
//   0  0  0  0   0 1 0 1

// 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 16
// 0 1 2 3 4 5 6 7 8 9  a  b  c  d  e  f

main :: proc() {
	b1: byte = 0b0000_0001
	b2 := 0b0000_0010
	b4 := 0b0000_0100
	b8 := 0b0000_1000
	b16 := 0b0001_0000
	b32 := 0b0010_0000
	b64 := 0b0100_0000
	b128 := 0b1000_0000
	b5 := 0b0000_0101
	xa5 := 0xa5
	ba5 := 0b1010_0101
	da5 := 165
	x05 := 0x05

	larger := 407708164 // 0x184d2204

	fmt.printf("0 0 0 0   0 0 0 1: %d\n", b1)
	fmt.printf("0 0 0 0   0 0 1 0: %d\n", b2)
	fmt.printf("0 0 0 0   0 1 0 0: %d\n", b4)
	fmt.printf("0 0 0 0   1 0 0 0: %d\n", b8)
	fmt.printf("0 0 0 1   0 0 0 0: %d\n", b16)
	fmt.printf("0 0 1 0   0 0 0 0: %d\n", b32)
	fmt.printf("0 1 0 0   0 0 0 0: %d\n", b64)
	fmt.printf("1 0 0 0   0 0 0 0: %d\n", b128)
	fmt.printf("0 0 0 0   0 1 0 1: %d\n", b5)

	fmt.printf("0x05: %d (%#0x)\n", xa5, xa5)
	fmt.printf("ba5: %d (%#0x)\n", ba5, ba5)
	fmt.printf("da5: %d (%0#x)\n", da5, da5)
	fmt.printf("x05: %d (%#02x)\n", x05, x05)

	fmt.printf("larger: %d (%#0x)\n", larger, larger)
}
