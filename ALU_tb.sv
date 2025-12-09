`timescale 1ns/1ps

module alu_tb();

  reg clk, rst;
  reg [7:0] A, B;
  reg [3:0] ALU_opcode;
  wire [7:0] out;
  wire Z, N, C, V;

  // Instantiate DUT
  ALU dut(
    .clk(clk),
    .rst(rst),
    .A(A),
    .B(B),
    .ALU_opcode(ALU_opcode),
    .out(out),
    .Z(Z),
    .N(N),
    .C(C),
    .V(V)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #2 clk = ~clk;
  end

  // Helper task for display
  task check_output;
    input [7:0] expected_out;
    input string op_name;
    begin
      if (out === expected_out)
        $display("[%0t] %s  Passed | A=%0d B=%0d OUT=%0d Z=%b N=%b C=%b V=%b", 
                 $time, op_name, A, B, out, Z, N, C, V);
      else
        $display("[%0t] %s  Failed | A=%0d B=%0d OUT=%0d (expected %0d) Z=%b N=%b C=%b V=%b", 
                 $time, op_name, A, B, out, expected_out, Z, N, C, V);
    end
  endtask


  // Reset and sequential test
  initial begin
    rst = 1;
    @(negedge clk);
     rst = 0;

    // ---- 0000 MOV ----
    A = 8'hAA; B = 8'h55; ALU_opcode = 4'b0000; #5;
    check_output(B, "MOV");

    // ---- 0001 ADD ----
    A = 8'd100; B = 8'd50; ALU_opcode = 4'b0001; #5;
    check_output(8'd150, "ADD");

    // ---- 0010 SUB ----
    A = 8'd50; B = 8'd20; ALU_opcode = 4'b0010; #5;
    check_output(8'd30, "SUB");

    // ---- 0011 AND ----
    A = 8'b10101010; B = 8'b11001100; ALU_opcode = 4'b0011; #5;
    check_output(A & B, "AND");

    // ---- 0100 OR ----
    A = 8'b10101010; B = 8'b11001100; ALU_opcode = 4'b0100; #5;
    check_output(A | B, "OR");

    // ---- 0101 RLC ----
    B = 8'b10110011; dut.CCR = 4'b0100; // C=1
    ALU_opcode = 4'b0101; #5;
    check_output({B[6:0], 1'b0}, "RLC");

    // ---- 0110 RRC ----
    B = 8'b10110011; dut.CCR = 4'b0010; // C=0
    ALU_opcode = 4'b0110; #5;
    check_output({1'b0, B[7:1]}, "RRC");

    // ---- 0111 SETC ----
    ALU_opcode = 4'b0111; #5;
    if (C == 1) $display("[%0t] SETC  Passed", $time);
    else $display("[%0t] SETC  Failed", $time);

    // ---- 1000 CLRC ----
    ALU_opcode = 4'b1000; #5;
    if (C == 0) $display("[%0t] CLRC  Passed", $time);
    else $display("[%0t] CLRC  Failed", $time);

    // ---- 1001 NOT ----
    B = 8'b10101010; ALU_opcode = 4'b1001; #5;
    check_output(~B, "NOT");

    // ---- 1010 NEG ----
    B = 8'd5; ALU_opcode = 4'b1010; #5;
    check_output(~B + 1, "NEG");

    // ---- 1011 INC ----
    B = 8'd10; ALU_opcode = 4'b1011; #5;
    check_output(8'd11, "INC");

    // ---- 1100 DEC ----
    B = 8'd10; ALU_opcode = 4'b1100; #5;
    check_output(8'd9, "DEC");

    // ---- 1101 LOOP (DEC A) ----
    A = 8'd20; ALU_opcode = 4'b1101; #5;
    check_output(8'd19, "LOOP");

    // ---- 1110 PASS A ----
    A = 8'hF0; ALU_opcode = 4'b1110; #5;
    check_output(A, "PASS A");

    $display("All test cases finished at %0t", $time);
    $stop;
  end

endmodule
