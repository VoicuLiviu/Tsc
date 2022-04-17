/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

module instr_register_test
  import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  (tb_ifc.TEST lab2if
    //input  logic          clk,
   //output logic          load_en,
   //output logic          reset_n,
   //output operand_t      operand_a,
   //output operand_t      operand_b,
   //output opcode_t       opcode,
   //output address_t      write_pointer,
   //output address_t      read_pointer,
   //input  instruction_t  instruction_word
  );

  //timeunit 1ns/1ns;
  //JUST  THE COMMITT
 

 

  //initial begin
    

  class first_test;
     int seed = 555;
    virtual tb_ifc.TEST lab2if;
    function new(virtual tb_ifc.TEST lab2if);
        this.lab2if=lab2if;

    endfunction

    task run();

    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    $display("\nFirst display...");
    lab2if.cb.write_pointer  <= 5'h00;         // initialize write pointer
    lab2if.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    lab2if.cb.load_en        <= 1'b0;          // initialize load control line
    lab2if.cb.reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge lab2if.cb) ;     // hold in reset for 2 clock cycles
    lab2if.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)
    $display("\nWriting values to register stack...");
    @(posedge lab2if.cb) lab2if.cb.load_en <= 1'b1;  // enable writing to register
    repeat (10) begin
      @(posedge lab2if.cb) randomize_transaction;
      @(negedge lab2if.cb) print_transaction;
    end
    @(posedge lab2if.cb) lab2if.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written..."); 
  
    for (int i=0; i<=9; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @(posedge lab2if.cb) lab2if.cb.read_pointer <=$unsigned($random)%10;
      @(negedge lab2if.cb) print_results;
    end

    @(posedge lab2if.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  

endtask
  

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    lab2if.cb.operand_a     <= $random(seed)%16;                 // between -15 and 15
    lab2if.cb.operand_b     <= $unsigned($random)%16;            // between 0 and 15
    lab2if.cb.opcode        <= opcode_t'($unsigned($random)%8);  // between 0 and 7, cast to opcode_t type
    lab2if.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", lab2if.cb.write_pointer);
    $display("  opcode = %0d (%s)", lab2if.cb.opcode, lab2if.cb.opcode.name);
    $display("  operand_a = %0d",   lab2if.cb.operand_a);
    $display("  operand_b = %0d\n", lab2if.cb.operand_b);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", lab2if.cb.read_pointer);
    $display("  opcode = %0d (%s)", lab2if.cb.instruction_word.opc, lab2if.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   lab2if.cb.instruction_word.op_a);
    $display("  operand_b = %0d\n", lab2if.cb.instruction_word.op_b);
    $display("  result    = %0d\n", lab2if.cb.instruction_word.res);
    if(lab2if.cb.instruction_word.opc==PASSA)
    begin 
      if(lab2if.cb.instruction_word.op_a==lab2if.cb.instruction_word.res)
      begin
        $display("Verification of PASSA operand_a = %0d and result = %0d is true",lab2if.cb.instruction_word.op_a,lab2if.cb.instruction_word.res);
      end
    end 
  endfunction: print_results
  endclass

        initial begin
           first_test fst;
              fst=new(lab2if);
                  fst.run();
        end 

endmodule: instr_register_test
