package sandbox

import "core:log"
import "core:mem"
import "core:os"
import "core:strings"

Configuration :: struct {
	filename: string,
	interval: Interval,
	url:      string,
}

Interval :: union {
	Never,
	Once,
	EveryMilliseconds,
}

Never :: struct {}

Once :: struct {}

SomeOtherUnion :: union {
	Never,
	bool,
	int,
}

EveryMilliseconds :: struct {
	interval: int,
}

ParsingError :: union {
	InvalidSyntax,
	InvalidValue,
}

InvalidSyntax :: struct {
	line:   int,
	column: int,
	data:   []byte,
}

InvalidValue :: struct {
	line:   int,
	column: int,
	data:   []byte,
	value:  string,
}

ConfigurationError :: union {
	ParsingError,
	FileReadFailed,
	mem.Allocator_Error,
}

FileReadFailed :: struct {
	filename: string,
}

parse_configuration :: proc(data: []byte) -> (config: Configuration, err: ParsingError) {
	return config, nil
}

read_configuration :: proc(
	filename: string,
	interval: Interval,
	url: string,
	allocator := context.allocator,
) -> (
	config: Configuration,
	err: ConfigurationError,
) {
	config.filename = filename
	config.interval = interval

	file_data, read_was_successful := os.read_entire_file_from_filename(filename, allocator)
	if !read_was_successful {
		return Configuration{}, FileReadFailed{filename = filename}
	}

	parsed_config := parse_configuration(file_data) or_return
	log.debugf("Parsed config: %v\n", parsed_config)
	parsed_config.url = strings.concatenate(
		{
			"prefix://prefix://prefix://prefix://prefix://prefix://prefix://prefix://",
			parsed_config.url,
		},
		allocator,
	) or_return

	return parsed_config, nil
}
