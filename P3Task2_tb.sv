
// Test Bench for Vending Machine

module vending_test;
  
 logic clk;
 logic reset;
 logic [4:0]coin;
 logic empty;
 logic quarter;
 logic fifty;
 logic seventyfive;
 logic dollar;
 logic dispense;
 logic [4:0] data [7:0];
 integer k;
  
  // coins
  parameter [4:0] Zero			= 5'b00000;
  parameter [4:0] Quarter  		= 5'b00001;
  parameter [4:0] Fifty	  		= 5'b00010;
  parameter [4:0] Seventyfive 	= 5'b00100;
  parameter [4:0] Dollar 		= 5'b01000;
  
  VendingMoore UUT (
    .clk (clk),
    .reset (reset),
    .coin (coin),
    .empty (empty),
    .quarter (quarter),
    .fifty (fifty),
    .seventyfive (seventyfive),
    .dollar (dollar),
    .dispense (dispense) 
  );
  
  
  
  initial begin
    clk <= 0;
    forever #5 clk = ~clk;
  end 
   initial begin
     
    $dumpvars;
	$dumpfile("file.vcd");
     
    reset = 1;
    #5 reset = 0;
    data = {
      		Quarter,// Quarter
      		Fifty,//  Fifty
      		Fifty,// fifty == Should dispense
      		Quarter,// Quarter
      		Fifty,// fifty
      		Fifty,// fifty == should dispsense
      		Quarter,// 
      		Zero // Zero
  			 }; 
  

    
    for ( k = 8; k >= 0; k--) begin
      
      #10 coin = data[k];
      
   end 
    
    #500 $finish;
  end 
  
  initial begin
    $monitor("coin = %b ,empty = %b, quarter = %b, fifty = %b, seventyfive = %b,dollar = %b, dispense = %b ", coin,empty, quarter,fifty, seventyfive, dollar,dispense);
  end 
 
endmodule
    
