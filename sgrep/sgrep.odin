package sgrep

import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"

import "dependencies:cli" // https://github.com/GoNZooo/odin-cli

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

Arguments :: struct {
	inverted: bool `cli:"i,invert"`, // gonz@severnatazvezda.com
}

main :: proc() {
	context.logger = log.create_console_logger()
	arguments := os.args[1:]
	log.debugf("arguments: %v\n", arguments)

	if len(arguments) < 2 {
		fmt.printf("Usage: sgrep <pattern> <file> [arguments]\n")
		os.exit(1)
	}
	pattern := arguments[0]
	filename := arguments[1]

	rest_of_arguments := arguments[2:]
	parsed_arguments := Arguments{}
	if len(rest_of_arguments) > 0 {
		cli_parse, _, parsing_error := cli.parse_arguments_as_type(rest_of_arguments, Arguments)
		if parsing_error != nil {
			fmt.printf("Error while parsing extra arguments: %v\n", parsing_error)
			os.exit(1)
		}

		parsed_arguments = cli_parse
	}

	grep_error := grep_file(pattern, filename, parsed_arguments)
	if grep_error != nil {
		fmt.printf("Error while grepping file ̈́'%s': %v\n", filename, grep_error)
		os.exit(1)
	}
}

grep_file :: proc(pattern, filename: string, arguments: Arguments) -> GrepError {
	log.debugf(
		"Grep file '%s' for pattern '%s' with arguments: %v\n",
		filename,
		pattern,
		arguments,
	)
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
			if arguments.inverted {
				if !strings.contains(l, pattern) {
					fmt.printf("%s\n", l)
				}
				continue
			}

			if strings.contains(l, pattern) {
				fmt.printf("%s\n", l)
			}
		}
	}


	return nil
}
