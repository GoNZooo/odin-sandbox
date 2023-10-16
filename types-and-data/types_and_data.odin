package types_and_data

import "core:fmt"
import "core:os"
import "core:runtime"
import "core:slice"
import "core:strings"

A :: struct {
	a: int,
	b: int,
	c: bool,
}

PackedA :: struct #packed {
	a: int,
	b: int,
	c: bool,
}

U :: union {
	A,
	byte,
	int,
}

U2 :: union {
	byte,
	int,
}

main :: proc() {
	if (slice.contains(os.args, "int")) {
		fmt.printf("Signed integers:\n")
		fmt.printf("\tsize_of(int)\t=\t%d\n", size_of(int))
		fmt.printf("\tsize_of(i8)\t=\t%d\n", size_of(i8))
		fmt.printf("\tsize_of(i16)\t=\t%d\n", size_of(i16))
		fmt.printf("\tsize_of(i32)\t=\t%d\n", size_of(i32))
		fmt.printf("\tsize_of(i64)\t=\t%d\n", size_of(i64))
		fmt.printf("\tsize_of(i128)\t=\t%d\n", size_of(i128))
		fmt.println("")
	}

	if (slice.contains(os.args, "uint")) {
		fmt.printf("Unsigned integers:\n")
		fmt.printf("\tsize_of(uint)\t=\t%d\n", size_of(uint))
		fmt.printf("\tsize_of(u8)\t=\t%d\n", size_of(u8))
		fmt.printf("\tsize_of(u16)\t=\t%d\n", size_of(u16))
		fmt.printf("\tsize_of(u32)\t=\t%d\n", size_of(u32))
		fmt.printf("\tsize_of(u64)\t=\t%d\n", size_of(u64))
		fmt.printf("\tsize_of(u128)\t=\t%d\n", size_of(u128))
		fmt.println("")
	}

	if (slice.contains(os.args, "float")) {
		fmt.printf("Floats:\n")
		fmt.printf("\tsize_of(f32)\t=\t%d\n", size_of(f32))
		fmt.printf("\tsize_of(f64)\t=\t%d\n", size_of(f64))
		fmt.println("")
	}

	if (slice.contains(os.args, "bool")) {
		fmt.printf("Booleans:\n")
		fmt.printf("\tsize_of(bool)\t=\t%d\n", size_of(bool))
		fmt.printf("\tsize_of(b8)\t=\t%d\n", size_of(b8))
		fmt.printf("\tsize_of(b16)\t=\t%d\n", size_of(b16))
		fmt.printf("\tsize_of(b32)\t=\t%d\n", size_of(b32))
		fmt.printf("\tsize_of(b64)\t=\t%d\n", size_of(b64))
		fmt.println("")
	}

	if (slice.contains(os.args, "char")) {
		fmt.printf("Characters:\n")
		fmt.printf("\tsize_of(u8)\t=\t%d\n", size_of(u8))
		fmt.printf("\tsize_of(byte)\t=\t%d\n", size_of(byte))
		fmt.printf("\tsize_of(rune)\t=\t%d\n", size_of(rune))
		fmt.println("")
	}

	if (slice.contains(os.args, "string")) {
		fmt.printf("Strings:\n\n")
		print_definition(string_definition)
		fmt.printf("\tsize_of(string)\t\t=\t%d\n", size_of(string))
		fmt.printf("\tsize_of(cstring)\t=\t%d\n", size_of(cstring))
		fmt.println("")
	}

	if (slice.contains(os.args, "pointer")) {
		fmt.printf("Pointers:\n")
		fmt.printf("\tsize_of(^int)\t=\t%d\n", size_of(^int))
		fmt.printf("\tsize_of(^bool)\t=\t%d\n", size_of(^bool))
		fmt.printf("\tsize_of(rawptr)\t=\t%d\n", size_of(rawptr))
		fmt.printf("\tsize_of(uintptr)\t=\t%d\n", size_of(uintptr))
		fmt.println("")
	}

	if (slice.contains(os.args, "array")) {
		fmt.printf("Arrays:\n")
		fmt.printf("\tsize_of([2]int)\t\t=\t%d\n", size_of([2]int))
		fmt.printf("\tsize_of([2]bool)\t=\t%d\n", size_of([2]bool))
		fmt.printf("\tsize_of([2]byte)\t=\t%d\n", size_of([2]byte))
		fmt.printf("\tsize_of([2]i32)\t\t=\t%d\n", size_of([2]i32))
		fmt.println("")

		fmt.printf("Slices:\n\n")
		print_definition(slice_definition)
		fmt.printf("\tsize_of([]int)\t=\t%d\n", size_of([]int))
		fmt.printf("\tsize_of([]bool)\t=\t%d\n", size_of([]bool))
		fmt.printf("\tsize_of([]byte)\t=\t%d\n", size_of([]byte))
		fmt.printf("\tsize_of([]i32)\t=\t%d\n", size_of([]i32))
		fmt.println("")

		fmt.printf("Dynamic arrays:\n\n")
		print_definition(dynamic_array_definition)
		fmt.printf("\tsize_of([dynamic]int)\t=\t%d\n", size_of([dynamic]int))
		fmt.printf("\tsize_of([dynamic]bool)\t=\t%d\n", size_of([dynamic]bool))
		fmt.printf("\tsize_of([dynamic]byte)\t=\t%d\n", size_of([dynamic]byte))
		fmt.printf("\tsize_of([dynamic]i32)\t=\t%d\n", size_of([dynamic]i32))

		fmt.printf("Allocator:\n\n")
		fmt.printf("\tsize_of(Allocator)\t=\t%d\n", size_of(runtime.Allocator))
	}

	if (slice.contains(os.args, "struct")) {
		fmt.printf("Structs:\n\n")
		print_definition(a_definition)
		fmt.printf("\tsize_of(A)\t=\t%d\n", size_of(A))
		fmt.println("")

		print_definition(packed_a_definition)
		fmt.printf("\tsize_of(PackedA)\t=\t%d\n", size_of(PackedA))
		fmt.println("")
	}

	if (slice.contains(os.args, "transmute_struct")) {
		fmt.printf("A as 3 `int`s:\n\n")
		print_definition(`transmute(A)[3]int{42, 1337, 1}`)
		fmt.printf("\t%v\n", transmute(A)[3]int{42, 1337, 1})
		// fmt.printf("\t%v\n", transmute(PackedA)[3]int{42, 1337, 1})
		fmt.println("")
	}

	if (slice.contains(os.args, "union")) {
		fmt.printf("Unions:\n\n")
		print_definition(u_definition)
		fmt.printf("\tsize_of(U)\t=\t%d\n", size_of(U))
		fmt.println("")

		print_definition(u2_definition)
		fmt.printf("\tsize_of(U2)\t=\t%d\n", size_of(U2))
		fmt.println("")
	}
}


string_definition :: `Raw_String :: struct {
	data: [^]byte,
	len:  int,
}`

slice_definition :: `Raw_Slice :: struct {
	data: rawptr,
	len:  int,
}`

dynamic_array_definition :: `Raw_Dynamic_Array :: struct {
	data:      rawptr,
	len:       int,
	cap:       int,
	allocator: Allocator,
}`

a_definition :: `A :: struct {
	a: int,
	b: int,
	c: bool,
}`

packed_a_definition :: `PackedA :: struct #packed {
	a: int,
	b: int,
	c: bool,
}`

u_definition :: `U :: union {
	A,
	byte,
	int,
}`

u2_definition :: `U2 :: union {
    byte,
    int,
}`

print_definition :: proc(d: string) {
	s, _ := strings.replace_all(d, "\n", "\n\t")
	fmt.printf("\t%s\n\n", s)
}
