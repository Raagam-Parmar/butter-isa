open Common.Bits.Bit
open Butter_processor.Basics
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


let nand_test _ =
  let nand_testcases : (nand_input, nand_output) testcases =
    [
      Test ({a=O; b=O}, I);
      Test ({a=O; b=I}, I);
      Test ({a=I; b=O}, I);
      Test ({a=I; b=I}, O);
    ]
  in
  test_chip nand nand_testcases


let nott_test _ =
  let not_testcases : (not_input, not_output) testcases =
    [
      Test (O, I);
      Test (I, O)
    ]
  in
  test_chip nott not_testcases


let andd_test _ =
  let andd_testcases : (andd_input, andd_output) testcases =
    [
      Test ({a=O; b=O}, O);
      Test ({a=O; b=I}, O);
      Test ({a=I; b=O}, O);
      Test ({a=I; b=I}, I);
    ]
  in
  test_chip andd andd_testcases


let orr_test _ =
  let orr_testcases : (orr_input, orr_output) testcases =
    [
      Test ({a=O; b=O}, O);
      Test ({a=O; b=I}, I);
      Test ({a=I; b=O}, I);
      Test ({a=I; b=I}, I);
    ]
  in
  test_chip orr orr_testcases


let xor_test _ =
  let xor_testcases : (xor_input, xor_output) testcases =
    [
      Test ({a=O; b=O}, O);
      Test ({a=O; b=I}, I);
      Test ({a=I; b=O}, I);
      Test ({a=I; b=I}, O);
    ]
  in
  test_chip xor xor_testcases


let mux2_test _ =
  let mux2_testcases : (mux2_input, mux2_output) testcases =
    [
      Test ({a=O; b=O; addr=O}, O);
      Test ({a=O; b=O; addr=I}, O);
      Test ({a=O; b=I; addr=O}, O);
      Test ({a=O; b=I; addr=I}, I);
      Test ({a=I; b=O; addr=O}, I);
      Test ({a=I; b=O; addr=I}, O);
      Test ({a=I; b=I; addr=O}, I);
      Test ({a=I; b=I; addr=I}, I);
    ]
  in
  test_chip mux2 mux2_testcases


let dmxu2_test _ =
  let dmux2_testcases : (dmux2_input, dmux2_output) testcases =
    [
      Test ({inp=O; addr=O}, (O, O));
      Test ({inp=O; addr=I}, (O, O));
      Test ({inp=I; addr=O}, (I, O));
      Test ({inp=I; addr=I}, (O, I));
    ]
  in
  test_chip dmux2 dmux2_testcases


let not_x8_test _ =
  let not_x8_testcases : (not_x8_input, not_x8_output) testcases =
    [
      Test ((O, O, O, O, O, O, O, O), (I, I, I, I, I, I, I, I))
    ]
  in
  test_chip not_x8 not_x8_testcases


let suite = "test suite for basics" >::: [
    "nand" >:: nand_test;
    "nott" >:: nott_test;
    "andd" >:: andd_test;
    "orr" >:: orr_test;
    "xor" >:: xor_test;
    "mux2" >:: mux2_test;
    "dmux2" >:: dmxu2_test;
    "not_x8" >:: not_x8_test
  ]

let _ = run_test_tt_main suite
