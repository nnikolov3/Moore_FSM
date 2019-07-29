
// Moore Finite State Machine 
// Vending Machine that does not give change


module VendingMoore (
  					clk, 
  					reset, 
 					coin,
  					empty,
 					quarter,
					fifty,
					seventyfive,
					dollar,
					dispense );
  
  input logic clk; // clock
  input logic reset; // reset
  input logic  [4:0] coin; 
  // outputs
  output logic empty;
  output logic quarter;
  output logic fifty;
  output logic seventyfive;
  output logic dollar;
  output logic dispense;
  
  // coins
  parameter [4:0] Zero			= 5'b00000;
  parameter [4:0] Quarter  		= 5'b00001;
  parameter [4:0] Fifty	  		= 5'b00010;
  parameter [4:0] Seventyfive 	= 5'b00100;
  parameter [4:0] Dollar 		= 5'b01000;
  
  // states
  typedef enum logic [4:0] { // explicit enum definition
    EMPTY = 		5'b00000,
   	QUARTER = 		5'b00001,
    FIFTY = 		5'b00010,
    SEVENTYFIVE = 	5'b00100,
    DOLLAR =		5'b01000,
    DISPENSE =		5'b10000  } states_t;
  
  states_t current_state, next_state;
  
  always_ff @(posedge clk, posedge reset)
    if (reset) current_state <= EMPTY; // reset to empty
	else 	   current_state <= next_state; 
  
  always_comb begin: set_next_state
   	next_state = EMPTY; // default for each branch below
    unique case (current_state)
      
    EMPTY: case (coin) // empty state
       Zero			: next_state = EMPTY; // no money
       Quarter		: next_state = QUARTER; // one quarter
       Fifty		: next_state = FIFTY;// 50 cents
       Seventyfive	: next_state = SEVENTYFIVE;
       Dollar		: next_state = DOLLAR;// 1 dollar
       default		: next_state = EMPTY;// empty
      endcase
     
    // A quarter paid
    QUARTER: case (coin) // for a quarter
      Quarter  		: next_state = FIFTY;
      Fifty			: next_state = SEVENTYFIVE;
      Seventyfive	: next_state = DOLLAR;
      Dollar		: next_state = DISPENSE;
      default 		: next_state = QUARTER;
    endcase
      
    // Fifty cents  paid
    FIFTY: case (coin) // for fifty cents
      Quarter		: next_state = SEVENTYFIVE; // 50 + 25
      Fifty			: next_state = DOLLAR;// 50 + 50 
      Seventyfive 	: next_state = DISPENSE; // 1.25
      default		: next_state = FIFTY;// else stay at 50
    endcase
    // Seventy five cents paid
      SEVENTYFIVE: case (coin)
        Quarter		: next_state = DOLLAR; // 75 + 25
        Fifty		: next_state = DISPENSE; // 75 + 50
        default		: next_state = SEVENTYFIVE;
      endcase
    // One Dollar
    DOLLAR: case (coin) // for 1 dollar
     Quarter		: next_state = DISPENSE;// 1.00 + 25  = dispense
     default		: next_state = FIFTY;// for other values stay 1
    endcase
      
  	DISPENSE		: next_state = EMPTY; // After it dispenses it gets empty 
     			
    endcase      
  end: set_next_state
  
  always_comb begin: set_outputs
    {empty, quarter,fifty,seventyfive,dollar,dispense} = 6'b00000;
    
    unique case (current_state)
    
	EMPTY		:	empty 		= 1'b1;
	QUARTER		: 	quarter 	= 1'b1;
    FIFTY  		:	fifty		= 1'b1;
    SEVENTYFIVE	:	seventyfive = 1'b1;
    DOLLAR		:	dollar		= 1'b1;
    DISPENSE	:	dispense	= 1'b1;
      
    endcase
    
  end: set_outputs
    
  
endmodule
