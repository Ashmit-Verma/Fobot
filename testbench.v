`timescale 1ns / 1ps

module obstacle_avoidance_robot_tb;
    // Test bench signals
    reg clk;
    reg reset;
    reg [3:0] arduino_input;
    wire motorL_pwm, motorR_pwm;
    wire motorL_dir, motorR_dir;
    
    // State names for readability in simulation
    localparam IDLE = 3'b000;
    localparam FORWARD = 3'b001;
    localparam TURN_RIGHT = 3'b010;
    localparam STOP = 3'b100;
    
    // Create a string to display current state
    reg [8*20:1] state_string;
    
    // Instantiate the Unit Under Test (UUT)
    obstacle_avoidance_robot uut (
        .clk(clk),
        .reset(reset),
        .arduino_input(arduino_input),
        .motorL_pwm(motorL_pwm),
        .motorR_pwm(motorR_pwm),
        .motorL_dir(motorL_dir),
        .motorR_dir(motorR_dir)
    );
    
    // Monitor state transitions
    always @(uut.state) begin
        case(uut.state)
            IDLE: state_string = "IDLE";
            FORWARD: state_string = "FORWARD";
            TURN_RIGHT: state_string = "TURN_RIGHT";
            STOP: state_string = "STOP";
            default: state_string = "UNKNOWN";
        endcase
        $display("Time %t: State changed to %s", $time, state_string);
    end
    
    // Clock generation (50 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period
    end
    
    // Test procedure
    initial begin
        // Initialize inputs
        reset = 1;
        arduino_input = 4'b0000;
        
        // Apply reset
        #100;
        reset = 0;
        
        // CASE 1: No obstacle (should go to FORWARD state)
        $display("TEST CASE 1: No obstacle, should move FORWARD");
        arduino_input = 4'b0011; // Below threshold
        #500;
        
        // Verify forward motion
        if(uut.state !== FORWARD) 
            $display("ERROR: State should be FORWARD but is %s", state_string);
        
        // CASE 2: Obstacle detected (should go to TURN_RIGHT state)
        $display("TEST CASE 2: Obstacle detected, should TURN RIGHT");
        arduino_input = 4'b1010; // Above threshold
        #500;
        
        // Verify turning right
        if(uut.state !== TURN_RIGHT) 
            $display("ERROR: State should be TURN_RIGHT but is %s", state_string);
        
        // CASE 3: Test continued turning during obstacle
        $display("TEST CASE 3: Testing continued turning while obstacle present");
        // Wait for partial turn duration
        #2000;
        
        // Obstacle still present
        arduino_input = 4'b1100; // Still above threshold
        #500;
        
        // Should still be turning
        if(uut.state !== TURN_RIGHT) 
            $display("ERROR: State should be TURN_RIGHT but is %s", state_string);
        
        // CASE 4: Test transition back to FORWARD after turning
        $display("TEST CASE 4: Testing transition to FORWARD after turn");
        // Wait for full turn duration
        #6000;
        
        // Clear obstacle
        arduino_input = 4'b0010; // Below threshold
        #500;
        
        // Check transition back to FORWARD
        if(uut.state !== FORWARD) 
            $display("ERROR: State should be FORWARD but is %s", state_string);
        
        // CASE 5: Test multiple sequential obstacles
        $display("TEST CASE 5: Testing multiple sequential obstacles");
        // First obstacle
        arduino_input = 4'b1111; // Max value
        #1000;
        
        // Clear first obstacle
        arduino_input = 4'b0001;
        // Wait for turn to complete
        #5000;
        
        // Second obstacle immediately
        arduino_input = 4'b1110;
        #1000;
        
        // Verify proper turn response
        if(uut.state !== TURN_RIGHT) 
            $display("ERROR: State should be TURN_RIGHT but is %s", state_string);
        
        // CASE 6: Test PWM outputs
        $display("TEST CASE 6: Testing PWM signal generation");
        // Go to FORWARD state
        arduino_input = 4'b0000;
        #5000;
        
        // Monitor some PWM cycles
        $display("Observing PWM signals for motor control in FORWARD state");
        #1000;
        
        // End simulation
        $display("All test cases completed.");
        #1000;
        $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%t, Reset=%b, Arduino_Input=%b, State=%s, L_PWM=%b, R_PWM=%b, L_DIR=%b, R_DIR=%b",
                $time, reset, arduino_input, state_string, motorL_pwm, motorR_pwm, motorL_dir, motorR_dir);
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("obstacle_avoidance_robot.vcd");
        $dumpvars(0, obstacle_avoidance_robot_tb);
    end
    
endmodule
