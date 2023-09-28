package sandbox

import "core:fmt"

Configuration :: struct {
	filename: string,
	interval: Interval,
}

Interval :: union {
	Never,
	Once,
	int,
}

Never :: struct {}

Once :: struct {}

SomeOtherUnion :: union {
	Never,
	bool,
	int,
}

// EveryMilliseconds :: struct {
// 	interval: int,
// }

read_configuration :: proc(filename: string, interval: Interval) -> (config: Configuration) {
	config.filename = filename
	config.interval = interval

	other_union: SomeOtherUnion

	switch i in interval {
	case Never, Once:
		fmt.printf("never or once: %v\n", i)
	case int:
		fmt.printf("every: %v\n", i)
	}

	if every, is_every_milliseconds := interval.(int); is_every_milliseconds {
		fmt.printf("every milliseconds: %v\n", every)
	}

	switch o in other_union {
	case Never, bool:
		fmt.printf("never or bool: %v\n", o)
	case int:
		fmt.printf("int: %v\n", o)
	}

	if int, is_int := interval.(int); is_int {
		fmt.printf("int: %v\n", int)
	}

	return config
}
