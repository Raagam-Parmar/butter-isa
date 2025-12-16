open Common.Bits.Bit
open Butter_processor.Adders
open OUnit2


type ('a, 'b) testcase = Test of ('a * 'b)
type ('a, 'b) testcases = ('a, 'b) testcase list


let test_chip_singleton chip testcase =
  match testcase with
  | Test (ip, op) -> assert_equal op (chip ip)


let test_chip chip testcases =
  List.iter
    (test_chip_singleton chip)
    testcases


let half_adder_test _ =
  let half_adder_testcases : (half_adder_input, half_adder_output) testcases =
    [
      Test ({a=O; b=O}, {sum=O; cout=O});
      Test ({a=O; b=I}, {sum=I; cout=O});
      Test ({a=I; b=O}, {sum=I; cout=O});
      Test ({a=I; b=I}, {sum=O; cout=I});
    ]
  in
  test_chip half_adder half_adder_testcases


let suite = "test suite for basics" >::: [
    "half_adder" >:: half_adder_test
  ]

let _ = run_test_tt_main suite
