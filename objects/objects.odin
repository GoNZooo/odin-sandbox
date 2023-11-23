package objects

import "core:fmt"

Redactable :: struct {
	redact: proc(l: ^Redactable),
}

Loggable :: struct {
	using redactable: Redactable,
	format:           proc(l: ^Loggable) -> string,
}

log_redacted :: proc(l: ^Loggable) {
	assert(l.format != nil, "format is nil")

	if l.redact == nil {
		l.redact = nil_redact
	}

	l->redact()
	fmt.printf("%s\n", l->format())
}

user_redact :: proc(r: ^Redactable) {
	u := cast(^User)r
	u.social_security_number = "REDACTED"
}

nil_redact :: proc(r: ^Redactable) {
}

user_format :: proc(l: ^Loggable) -> string {
	return fmt.tprintf("%v", cast(^User)l)
}

User :: struct {
	using loggable:         Loggable,
	name:                   string,
	age:                    int,
	social_security_number: string,
}

main :: proc() {
	u := User {
		name                   = "Rickard",
		age                    = 36,
		social_security_number = "1234567890",
		// redact                 = user_nil_redact,
		format                 = user_format,
	}

	log_redacted(&u)
}
