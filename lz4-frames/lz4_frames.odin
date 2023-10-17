package lz4_frames

import "core:bytes"
import "core:fmt"
import "core:mem"
import "core:os"
import "core:testing"

MAGIC_VALUE :: 0x184D2204

frame_next :: proc(data: []byte) -> (frame: []byte, rest: []byte) {
	if len(data) < 7 {
		return nil, data
	}

	for i := 0; i < len(data); i += 1 {
		if i + 4 > len(data) {
			return nil, data
		}

		potential_magic_value := mem.reinterpret_copy(u32le, raw_data(data[i:i + 4]))

		if potential_magic_value != MAGIC_VALUE {
			continue
		}

		frame_end := bytes.index(data[i + 4:], []byte{0, 0, 0, 0})
		if frame_end == -1 {
			return nil, data
		}

		frame_end += i
		frame_end += 4 // Add the 4 bytes of the magic number
		frame_end += 4 // Add the 4 bytes of the frame end marker

		frame = data[i:frame_end]
		rest = data[frame_end:]

		return frame, rest
	}

	return nil, nil
}

@(test, private = "package")
test_frame_next :: proc(t: ^testing.T) {
	path :: "test-data/lz4-example.pak"

	file_data, ok := os.read_entire_file_from_filename(path)
	if !ok {
		panic("Could not read file for test: '" + path + "'")
	}
	frames, alloc_error := make([dynamic][]byte, 0, 0)
	if alloc_error != nil {
		panic("Could not allocate frames array")
	}

	for frame, rest := frame_next(file_data); frame != nil; frame, rest = frame_next(rest) {
		_, err := append(&frames, frame)
		if err != nil {
			panic("Could not append frame")
		}
	}

	testing.expect_value(t, len(frames), 12)
}

main :: proc() {
	arguments := os.args[1:]

	if len(arguments) == 0 {
		fmt.println("Usage: lz4-frames <file>")
		os.exit(1)
	}

	file_data, ok := os.read_entire_file_from_filename(arguments[0])
	if !ok {
		fmt.println("Could not read file")
		os.exit(1)
	}

	i := 0
	for frame, rest := frame_next(file_data); frame != nil; frame, rest = frame_next(rest) {
		fmt.printf("[%d] %d\n", i, len(frame))
		i += 1
	}
}
