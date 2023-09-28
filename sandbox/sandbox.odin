package sandbox

import "core:fmt"
import "core:log"
import "core:runtime"

main :: proc() {
	context.allocator = runtime.default_allocator()
	context.logger = log.create_console_logger()

	config := read_configuration("ols2.json", Once{})

	fmt.printf("Configuration: %v\n", config)
}
