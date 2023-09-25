package main

import "core:fmt"
import "core:intrinsics"

Nothing :: struct {}

Just :: struct($T: typeid) {
    value: T,
}

Maybe :: union($T: typeid) {
    T,
}

Left :: struct($L, $R: typeid) {
    value: L,
}

Right :: struct($L, $R: typeid) {
    value: R,
}

Either :: union($L, $R: typeid) {
    Left(L, R),
    Right(L, R),
}

unsafeUnwrap :: proc {
    unsafeUnwrapMaybe,
    unsafeUnwrapEither,
}

unsafeUnwrapMaybe :: proc(maybe: Maybe($T)) -> T {
    value, ok := maybe.(Just(T))
    if ok {
        return value.value
    } else {
        panic("Tried to unwrap Nothing")
    }
}

unsafeUnwrapEither :: proc(either: Either($L, $R)) -> R {
    value, ok := either.(Right(L, R))
    if ok {
        return value.value
    } else {
        panic("Tried to unwrap Left")
    }
}

unwrap :: proc {
    unwrapMaybe,
    unwrapEither,
}

unwrapMaybe :: proc(maybe: Maybe($T), default: T) -> T {
    return (maybe.(Just(T)) or_else Just(T){value = default}).value
}

unwrapEither :: proc(either: Either($L, $R), default: R) -> R {
    return (either.(Right(L, R)) or_else Right(L, R){value = default}).value
}

fmap :: proc {
    fmapMaybe,
    fmapEither,
}

fmapMaybe :: proc(maybe: Maybe($T), f: proc(_: T) -> $U) -> Maybe(U) {
    value, ok := maybe.(Just(T))
    if ok {
        return Just(U){value = f(value.value)}
    } else {
        return Nothing{}
    }
}

fmapEither :: proc(either: Either($L, $R), f: proc(_: R) -> $U) -> Either(L, U) {
    switch e in either {
    case Left(L, R):
        return Left(L, U){value = e.value}

    case Right(L, R):
        return Right(L, U){value = f(e.value)}
    }

    unreachable()
}

lookupInMapOrDefault :: proc(m: map[$K]$V, key: K, default: V) -> V {
    return m[key] or_else default
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
    array_long := [?]f32{1, 2, 3, 4, 5}
    array_short := [?]f32{0, 1, 2}

    fmt.printf("xyzw: %v\n", array_long.xyzw)
    fmt.printf("rgba: %v\n", array_long.rgba)
    fmt.printf("xyz * 2: %v\n", array_long.xyz * 2)
    fmt.printf("zyx + 1: %v\n", array_long.zyx + 1)
    fmt.printf("zyx + short_array: %v\n", array_long.zyx + array_short)

    // i := add(1, 2)
    // f := add(1.0, 2.0)
    // fmt.println(i, f)

    // maybe
    justValue: Maybe(int) = Just(int) {
        value = 42,
    }
    value := unsafeUnwrap(justValue)
    nothingValue: Maybe(int) = Nothing{}
    safeValue := unwrap(justValue, 0)
    safeValue2 := unwrap(nothingValue, 0)
    fmt.println(
        "just:",
        justValue,
        "value:",
        value,
        "safeValue:",
        safeValue,
        "safeValue2:",
        safeValue2,
        "justFmapped+1:",
        fmap(justValue, proc(x: int) -> int {return x + 1}),
        "nothingFmapped+1:",
        fmap(nothingValue, proc(x: int) -> int {return x + 1}),
    )

    // either
    // rightValue: Either(int, string) = Right(int, string) {
    //     value = "hello",
    // }
    // leftValue: Either(int, string) = Left(int, string) {
    //     value = 42,
    // }
    // unwrapped := unsafeUnwrap(rightValue)
    // rightUnwrappedSafely := unwrap(rightValue, "default")
    // safeUnwrapped2 := unwrap(leftValue, "default")
    // fmt.println(
    //     "rightValue:",
    //     rightValue,
    //     "leftValue:",
    //     leftValue,
    //     "unwrapped:",
    //     unwrapped,
    //     "safeUnwrapped:",
    //     rightUnwrappedSafely,
    //     "safeUnwrapped2:",
    //     safeUnwrapped2,
    //     "rightFmappedLen+1:",
    //     fmap(rightValue, proc(x: string) -> int {return len(x) + 1}),
    //     "leftFmappedLen+1:",
    //     fmap(leftValue, proc(x: string) -> int {return len(x) + 1}),
    // )

    // map
    // m := map[int]string {
    //     1 = "one",
    //     2 = "two",
    // }
    // fmt.println(lookupInMapOrDefault(m, 1, "default"))
    // fmt.println(m[1] or_else "default")
    // fmt.println(lookupInMapOrDefault(m, 3, "default"))
    // fmt.println(m[3] or_else "default")

    // This doesn't compile, because it's not a numeric type
    // s := add("hello", "world")

    // token := Token{}
    // print_token(token)
    // fmt.println(token)
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
