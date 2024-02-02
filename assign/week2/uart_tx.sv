module main(
    input clk,
    input rst,
    output tx
);
    
    localparam WAIT_TICKS_10MS = 100;
    localparam MSG_LEN = 12;
    reg [MSG_LEN*8-1:0] hello_world = "Hello World!";
    
    reg tx_reg;
    reg [3:0] cnt_data_bit;
    reg [7:0] cnt_10ms;
    reg [31:0] cnt_1sec;
    enum logic [2:0] {RESET, WAIT_10MS, START_BIT, DATA_BIT, STOP_BIT, DELAY, ERROR} state, next_state;
    
    assign tx = tx_reg;
    
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= RESET;
        end else begin
            state <= next_state;
        end
    end
    
    always_comb begin
        next_state = state;
        
        case (state)
            RESET:
                next_state = WAIT_10MS;
            WAIT_10MS:
                if (cnt_10ms >= WAIT_TICKS_10MS)
                    next_state = START_BIT;
            START_BIT:
                next_state = DATA_BIT;
            DATA_BIT: begin
                tx_reg <= hello_world[cnt_data_bit[3:0]];
                if (cnt_data_bit >= MSG_LEN*8 - 1) begin
                    cnt_data_bit <= 0;
                    next_state = STOP_BIT;
                end else begin
                    cnt_data_bit <= cnt_data_bit + 1;
                    next_state = DATA_BIT;
                end
            end
            STOP_BIT:
                next_state = DELAY;
            DELAY:
                if (cnt_1sec >= 50000000)
                    next_state = RESET;
                    
            ERROR: next_state = ERROR;
            default: next_state = ERROR;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_reg <= 1;
            cnt_data_bit <= 0;
            cnt_10ms <= 0;
            cnt_1sec <= 0;
        end else begin
            case (next_state)
                RESET: begin
                end
                
                WAIT_10MS: begin
                    cnt_data_bit <= 0;
                    cnt_10ms <= cnt_10ms + 1;
                end
                
                START_BIT: begin
                    cnt_10ms <= 0;
                    tx_reg <= 0;
                end
                
                DATA_BIT: begin
                    cnt_data_bit <= cnt_data_bit + 1;
                    tx_reg <= hello_world[cnt_data_bit[3:0]];
                end
                
                STOP_BIT: begin
                    tx_reg <= 1;
                end
                
                DELAY: begin
                    cnt_1sec <= cnt_1sec + 1;
                end
                
                ERROR: begin
                    tx_reg <= 1;
                    cnt_1sec <= 0;
                end
                
                default: begin
                    tx_reg <= 1;
                end
            endcase
        end
    end
    
endmodule
