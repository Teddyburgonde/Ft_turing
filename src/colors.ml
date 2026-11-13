
(* ANSI Color codes *)
type color =
    [ `Black
    | `Red
    | `Yellow
    | `Green
    | `Blue
    | `Magenta
    | `Cyan
    | `White
    ]


(* ANSI Color matching *)
let int_of_color_ = function
    | `Black -> 0
    | `Red -> 1
    | `Green -> 2
    | `Yellow -> 3
    | `Blue -> 4
    | `Magenta -> 5
    | `Cyan -> 6
    | `White -> 7


(* All possible styles *)
type style =
    [ `FG of color (* foreground *)
    | `BG of color (* background *)
    | `Bold
    | `Reset
    ]

(* Helper function to generate ANSI color string *)
let code_of_style : style -> int = function
    | `FG c -> 30 + int_of_color_ c
    | `BG c -> 40 + int_of_color_ c
    | `Bold -> 1
    | `Reset -> 0


let string_of_style style = Printf.sprintf "\x1b[%dm" (code_of_style style)
let string_of_color color = string_of_style (`FG color)
let string_of_bold_style style = string_of_style (style) ^ (string_of_style `Bold)
let string_of_bold_color color = string_of_bold_style (`FG color)
let clear_line = "\x1b[2K\r"
let reset = string_of_style `Reset
