// Code your testbench here
// or browse Examples
module mini_processor_tb;
    reg clk;
    reg reset;
    reg [3:0] data_in;
    reg load_en;
    reg [1:0] op_sel;
    wire [3:0] data_out;

    // --- 2. Instantiate the Unit Under Test (UUT) ---
    mini_processor uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .load_en(load_en),
        .op_sel(op_sel),
        .data_out(data_out)
    );
  
    reg [10:0] error = 0;
    reg [3:0] ref_sram [15:0];      // Golden Memory
    reg [3:0] ref_addr_counter;     // Shadow Counter
    reg [3:0] expected_data_out;    // The "Golden" Result
    reg [1:0] ok;
    event rst_en, rst_done;
    event terminate_sim;

    // --- 3. Clock Generation (100MHz) ---
    initial begin // Clock generator
      clk = 0;
      #10
      forever 
      #10 clk =~clk;
    end
  
    always begin //reset
      @(rst_en);
      @(negedge clk);
      reset = 1;
      @(negedge clk);
      reset = 0;
      -> rst_done; 
    end 

    // --- 4. Stimulus Process (The Test Plan) ---
    initial begin
      load_en = 0;
      op_sel = 2'b00;
      data_in = 4'b0;
      #10 -> rst_en;
      $display ("reset start %0t",$time); 
      @(rst_done);
      $display ("reset done %0t",$time); 
      #5;
      
      fork
        // --- Process 1: Random Operations ---
        repeat(500) begin
          //repeat(4) begin
            @(negedge clk);
            if (reset) begin
               ok = 0;
               load_en = 0;
               op_sel = 2'b00;
            end
            else begin
            // Randomly choose between: 
            // 0: Idle, 1: Load Data, 2: Add, 3: Subtract
              case ($urandom_range(0, 3))
                  0: begin // IDLE
                      load_en = 0; op_sel = 2'b00;
                  end
                  1: begin // LOAD
                      repeat(2) begin
                        @(negedge clk);
                        load_en = 1; op_sel = 2'b00;
                        data_in = $random; ok = ok + 1;
                      end
                     @(negedge clk);
                     load_en = 0;
                  end
                  2: begin // ADD
                       if(ok == 2) begin
                         op_sel = 2'b01;
                         @(negedge clk);
                         op_sel = 2'b00;
                         ok = 0; 
                       end
                  end
                  3: begin // SUB
                       if(ok == 2) begin
                         op_sel = 2'b10;
                         @(negedge clk);
                         op_sel = 2'b00;
                         ok = 0;
                       end
                  end
              endcase
            end
        end

        // --- Process 2: Random Resets ---
        // This will inject resets every few thousand nanoseconds
        repeat(5) begin
          #($urandom_range(1000, 5000)); 
            -> rst_en;
            @(rst_done);
        end
    join
      
      
      #20 -> terminate_sim;
    end
  
    // Reference Reset Logic (Must match UUT exactly)
    always @(posedge clk or posedge reset) begin
      if (reset) begin
          ref_addr_counter <= 4'b0000;
          expected_data_out <= 4'b0000;
          // Optional: Clear ref_sram if needed
      end 
      else begin  
          // Mirroring Memory Load
          if (load_en) begin
              ref_sram[ref_addr_counter] <= data_in;
              ref_addr_counter <= ref_addr_counter + 1;
          end

          // Mirroring ALU & Auto-Store Logic
          if (op_sel == 2'b01 || op_sel == 2'b10) begin
              // Reference Calculation using Shadow Memory
              if (op_sel == 2'b01) 
                  expected_data_out = ref_sram[ref_addr_counter-2] + ref_sram[ref_addr_counter-1];
              else 
                  expected_data_out = ref_sram[ref_addr_counter-2] - ref_sram[ref_addr_counter-1];
            
              // Mirroring the internal store in next address
              ref_sram[ref_addr_counter] <= expected_data_out;
              ref_addr_counter <= ref_addr_counter + 1;
          end
      end
    end
  
    // Self-Checking Monitor (The Checker)
    always @(posedge clk) begin
      #1; // Wait for UUT to update signals (Sampling edge)
      if (!reset && (op_sel == 2'b01 || op_sel == 2'b10)) begin
          if (data_out != expected_data_out) begin
              $display("ERROR at %0t: Expected %d, Got %d", $time, expected_data_out, data_out);
              error = error + 1;
          end 
          else begin
              $display("PASS at %0t: ALU Result %d matched Reference", $time, data_out);
          end
      end
    end
  
  
  
  
  
  
  
  

    // --- 5. Monitor Output ---
    initial begin
      $monitor("Time: %0t | Reset: %b | Data_In: %d | Op: %b |         Result: %d",$time, reset, data_in, op_sel, data_out);
    end
  
    // finish and wave
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0, mini_processor_tb);
      @(terminate_sim);
      $display("\n################################");
      if(error == 0) 
        $display("SIMULATION PASSED!");
      else                   
        $display("SIMULATION FAILED WITH %0d ERRORS", error);
      $display("################################");
      #10 $finish;
    end

endmodule
