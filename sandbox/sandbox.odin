package sandbox

import "core:fmt"
import "core:log"
import "core:mem/virtual"
import "core:os"

main :: proc() {
	arena: virtual.Arena
	arena_buffer: [256]byte
	arena_init_error := virtual.arena_init_buffer(&arena, arena_buffer[:])
	if arena_init_error != nil {
		fmt.panicf("Error initializing arena: %v\n", arena_init_error)
	}
	arena_allocator := virtual.arena_allocator(&arena)
	defer virtual.arena_destroy(&arena)

	log_file_handle, log_file_open_error := os.open("log.txt", os.O_WRONLY)
	if log_file_open_error != os.ERROR_NONE {
		fmt.panicf("Error opening log file: %v\n", log_file_open_error)
	}
	context.allocator = arena_allocator
	context.logger = log.create_multi_logger(
		log.create_console_logger(),
		log.create_file_logger(log_file_handle),
	)
	config, err := read_configuration("file1.txt", Once{}, "url")
	if err != nil {
		fmt.panicf("Error reading configuration file: %v\n", err)
	}

	fmt.printf("Configuration: %v\n", config)
}
