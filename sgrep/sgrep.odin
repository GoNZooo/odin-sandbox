package sgrep

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"

GrepError :: union {
	UnableToOpenFile,
	UnableToReadFromFile,
	mem.Allocator_Error,
}

UnableToOpenFile :: struct {
	filename: string,
	error:    os.Errno,
}

UnableToReadFromFile :: struct {
	filename: string,
	error:    os.Errno,
}

main :: proc() {
	arguments := os.args[1:]

	if len(arguments) != 2 {
		fmt.printf("Usage: sgrep <pattern> <file>\n")
		os.exit(1)
	}
	pattern := arguments[0]
	filename := arguments[1]

	grep_error := grep_file(pattern, filename)
	if grep_error != nil {
		fmt.printf("Error while grepping file ̈́'%s': %v\n", filename, grep_error)
		os.exit(1)
	}
}

grep_file :: proc(pattern, filename: string) -> GrepError {
	file_handle, open_error := os.open(filename, os.O_RDONLY)
	if open_error != os.ERROR_NONE {
		return UnableToOpenFile{filename = filename, error = open_error}
	}

	read_buffer: [mem.Kilobyte]byte
	for {
		bytes_read, read_error := os.read(file_handle, read_buffer[:])
		if read_error != os.ERROR_NONE {
			return UnableToReadFromFile{filename = filename, error = read_error}
		}
		if bytes_read == 0 {
			break
		}
		s := string(read_buffer[:bytes_read])
		lines := strings.split_lines(s) or_return
		for l in lines {
			if strings.contains(l, pattern) {
				fmt.printf("%s\n", l)
			}
		}
	}


	return nil
}
