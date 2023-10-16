package lz4_frames

import "core:bytes"
import "core:fmt"
import "core:os"

MAGIC_BYTES := [4]byte{0x04, 0x22, 0x4D, 0x18}

frame_next :: proc(data: []byte) -> (frame: []byte, rest: []byte) {
	if len(data) < 7 {
		return nil, data
	}

	for i := 0; i < len(data); i += 1 {
		if i + 4 > len(data) {
			return nil, data
		}

		if bytes.compare(data[i:i + 4], MAGIC_BYTES[:]) != 0 {
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
