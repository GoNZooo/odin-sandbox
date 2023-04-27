package main

import "core:fmt"
import "core:intrinsics"

Nothing :: struct {}

Just :: struct($T: typeid) {
    value: T,
}

Maybe :: union($T: typeid) {
    Nothing,
    Just(T),
}

unwrapMaybe :: proc($T: typeid, maybe: Maybe(T)) -> T {
    value, ok := maybe.(Just(T))
    if ok {
        return value.value
    } else {
        panic("Tried to unwrap Nothing")
    }
}

unwrapMaybeSwitch :: proc($T: typeid, maybe: Maybe(T)) -> T {
  switch m in maybe {
    case Nothing:
        panic("Tried to unwrap Nothing")
    case Just(T):
        return m.value
    }
    unreachable()
}

Unknown :: struct {
    value: string,
}
LeftParenthesis :: struct {
    value: string,
}
RightParenthesis :: struct {
    value: string,
}
LeftCurlyBrace :: struct {
    value: string,
}
RightCurlyBrace :: struct {
    value: string,
}
LeftSquareBracket :: struct {
    value: string,
}
RightSquareBracket :: struct {
    value: string,
}
Comma :: struct {
    value: string,
}
Colon :: struct {
    value: string,
}
Hash :: struct {
    value: string,
}
String :: struct {
    value: string,
}
Integer :: struct {
    value: i64,
}
Float :: struct {
    value: f64,
}

TokenType :: union #no_nil {
    Unknown,
    LeftParenthesis,
    RightParenthesis,
    LeftCurlyBrace,
    RightCurlyBrace,
    LeftSquareBracket,
    RightSquareBracket,
    Comma,
    Colon,
    Hash,
    String,
    Integer,
    Float,
}

Position :: struct {
    line:   u32,
    column: u32,
}

Token :: struct {
    position: Position,
    type:     TokenType,
}

main :: proc() {
    i := add(1, 2)
    f := add(1.0, 2.0)
    fmt.println(i, f)
    maybeValue := Just(int){value = 42}
    value := unwrapMaybe(int, maybeValue)
    valueFromSwitch := unwrapMaybeSwitch(int, maybeValue)
    fmt.println("maybe:", maybeValue, "value:", value, "valueFromSwitch:", valueFromSwitch)

    // This doesn't compile, because it's not a numeric type
    // s := add("hello", "world")

    token := Token{}
    print_token(token)
    fmt.println(token)
}

print_token :: proc(token: Token) {
    switch t in token.type {
    case Unknown:
        fmt.println(
            sep = "",
            args = {"Unknown(", t.value, ")@", token.position.line, ":", token.position.column},
        )
    case LeftParenthesis:
        fmt.println(
            sep = "",
            args = {"LeftParenthesis()@", token.position.line, ":", token.position.column},
        )
    case RightParenthesis:
        fmt.println(
            sep = "",
            args = {"RightParenthesis()@", token.position.line, ":", token.position.column},
        )
    case LeftCurlyBrace:
        fmt.println(
            sep = "",
            args = {"LeftCurlyBrace()@", token.position.line, ":", token.position.column},
        )
    case RightCurlyBrace:
        fmt.println(
            sep = "",
            args = {"RightCurlyBrace()@", token.position.line, ":", token.position.column},
        )
    case LeftSquareBracket:
        fmt.println(
            sep = "",
            args = {"LeftSquareBracket()@", token.position.line, ":", token.position.column},
        )
    case RightSquareBracket:
        fmt.println(
            sep = "",
            args = {"RightSquareBracket()@", token.position.line, ":", token.position.column},
        )
    case Comma:
        fmt.println(sep = "", args = {"Comma()@", token.position.line, ":", token.position.column})
    case Colon:
        fmt.println(sep = "", args = {"Colon()@", token.position.line, ":", token.position.column})
    case Hash:
        fmt.println(sep = "", args = {"Hash()@", token.position.line, ":", token.position.column})
    case String:
        fmt.println(
            sep = "",
            args = {"String(", t.value, ")@", token.position.line, ":", token.position.column},
        )
    case Integer:
        fmt.println(
            sep = "",
            args = {"Integer(", t.value, ")@", token.position.line, ":", token.position.column},
        )
    case Float:
        fmt.println(
            sep = "",
            args = {"Float(", t.value, ")@", token.position.line, ":", token.position.column},
        )
    }
}

add :: proc(a, b: $T) -> T where intrinsics.type_is_numeric(T) {
    return a + b
}
