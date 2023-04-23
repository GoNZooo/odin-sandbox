package main

import "core:fmt"

main :: proc() {
    x := add(1, 2)
    fmt.println("Hello, world!")
}

add :: proc(a: int, b: int) -> int {
    return a + b
}
