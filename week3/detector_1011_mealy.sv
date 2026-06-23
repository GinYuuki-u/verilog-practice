module detector_1011_mealy(
    input logic  clk,
    input logic  rst,
    input logic  in,
    output logic out
);
  //此题用移位寄存器秒了比较合适，但这里只用Mealy状态机来做
    localparam S0 = 0, S1 = 1, S10 = 2, S101 = 3; //S0即为没开始，之后错误就回到S0,
    logic [1:0]state, next_state;

    always_comb begin
        case(state)
            S0:     next_state = in? S1: S0;
            S1:     next_state = !in? S10: S1; //--10 or --11
            S10:    next_state = in? S101: S0; //-101 or -100
            S101:   next_state = in? S1: S10; //1011已完成视为S1 未完成回退到S10
            default:next_state = S0;
        endcase
    end

    always_ff@(posedge clk) begin
        if(rst)
            state <= 0;
        else
            state <= next_state;
    end

    assign out = (state == S101) && in;

endmodule
