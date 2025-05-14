module obstacle_avoidance_robot(
    input clk, reset,
    input [3:0] arduino_input,   // 4-bit input from Arduino via PMOD pins
    output reg motorL_pwm, motorR_pwm,
    output reg motorL_dir, motorR_dir
);

// States
localparam IDLE         = 3'b000;
localparam FORWARD      = 3'b001;
localparam TURN_RIGHT   = 3'b010;
localparam STOP         = 3'b100;

// Constants
localparam OBSTACLE_THRESHOLD = 4'd8; // Threshold for 4-bit input (adjust as needed)
localparam TURN_DURATION = 16'd4000;  // Duration for turning (adjust as needed)

// Internal registers
reg [2:0] state, next_state;
reg [7:0] pwm_counter = 0;
reg [7:0] dutycycle_L, dutycycle_R;
reg [15:0] turn_counter;
reg obstacle_detected;

// State transition logic
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end

// Process Arduino input data
always @(posedge clk) begin
    // Check if obstacle is detected (higher value = closer obstacle)
    obstacle_detected <= (arduino_input > OBSTACLE_THRESHOLD);
end

// FSM next state logic - always turn right on obstacle detection
always @(*) begin
    case(state)
        IDLE: begin
            next_state = FORWARD;
        end

        FORWARD: begin
            if(obstacle_detected)
                next_state = TURN_RIGHT; // Turn right when obstacle detected
            else
                next_state = FORWARD;
        end

        TURN_RIGHT: begin
            if(turn_counter >= TURN_DURATION) begin
                if(obstacle_detected)
                    next_state = TURN_RIGHT; // Keep turning if obstacle still detected
                else
                    next_state = FORWARD;
            end
            else
                next_state = TURN_RIGHT;
        end

        STOP: begin
            next_state = STOP; // Emergency stop state
        end

        default: next_state = IDLE;
    endcase
end

// Combinational output logic
always @(*) begin
    case(state)
        IDLE: begin
            dutycycle_L = 8'd0;
            dutycycle_R = 8'd0;
            motorL_dir = 1'b0;
            motorR_dir = 1'b0;
        end

        FORWARD: begin
            dutycycle_L = 8'd200;
            dutycycle_R = 8'd200;
            motorL_dir = 1'b1;
            motorR_dir = 1'b1;
        end

        TURN_RIGHT: begin
            dutycycle_L = 8'd200; // Full left motor
            dutycycle_R = 8'd0;   // Stop right motor to turn right
            motorL_dir = 1'b1;
            motorR_dir = 1'b1;
        end

        STOP: begin
            dutycycle_L = 8'd0;
            dutycycle_R = 8'd0;
            motorL_dir = 1'b0;
            motorR_dir = 1'b0;
        end

        default: begin
            dutycycle_L = 8'd0;
            dutycycle_R = 8'd0;
            motorL_dir = 1'b0;
            motorR_dir = 1'b0;
        end
    endcase
end

// Sequential block for turn counter and PWM counter
always @(posedge clk) begin
    pwm_counter <= pwm_counter + 1;

    if (state == TURN_RIGHT)
        turn_counter <= turn_counter + 1;
    else
        turn_counter <= 0;
end

// PWM signal generation
always @(posedge clk) begin
    motorL_pwm <= (pwm_counter < dutycycle_L) ? 1'b1 : 1'b0;
    motorR_pwm <= (pwm_counter < dutycycle_R) ? 1'b1 : 1'b0;
end

endmodule
