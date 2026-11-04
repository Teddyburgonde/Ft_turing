let display_help () =
  print_endline "usage: ft_turing [-h] jsonfile input";
  print_endline "";
  print_endline "positional arguments:";
  print_endline "  jsonfile    json description of the machine";
  print_endline "  input       input of the machine";
  print_endline "";
  print_endline "optional arguments:";
  print_endline "  -h, --help  show this help message and exit"

let report_error message =
  prerr_endline ("ft_turing: " ^ message);
  1

let run_machine jsonfile input =
  match Parser.load_machine jsonfile with
  | Error message -> report_error message
  | Ok description ->
      (match Parser.validate_input description input with
       | Error message -> report_error message
       | Ok () ->
           let configuration = Machine.initialize description input in
           match Machine.run configuration with
           | Machine.Halted _ -> 0
           | Machine.Blocked (_, reason) -> report_error reason
           | Machine.Continue (_, _) ->
               report_error "internal error: run stopped before halting")

let main () =
  match Array.to_list Sys.argv with
  | [_; ("-h" | "--help")] ->
      display_help ();
      0
  | [_; jsonfile; input] -> run_machine jsonfile input
  | _ ->
      display_help ();
      1

let () = exit (main ())

