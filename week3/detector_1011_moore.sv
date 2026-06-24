module detector_1011_moore(
    input logic  clk,
    input logic  rst,
    input logic  in,
    output logic out
);
  //此题用移位寄存器秒了比较合适，但这里只用Moore状态机来做
    localparam S0 = 0, S1 = 1, S10 = 2, S101 = 3, S1011 = 4; //S0即为没开始，之后错误就回到S0,
    logic [2:0]state, next_state;

    always_comb begin
        case(state)
            S0:     next_state = in? S1: S0;
            S1:     next_state = !in? S10: S1; //--10 or --11
            S10:    next_state = in? S101: S0; //-101 or -100
            S101:   next_state = in? S1: S10; //1011已完成视为S1 未完成回退到S10
            S1011:  next_state = !in? S10: S1; //本质上视为和S1同类的状态 但是Moore必须用显式状态来输出 因此转移模式一样只是显示表达出完成状态
            default:next_state = S0;
        endcase
    end

    always_ff@(posedge clk) begin
        if(rst)
            state <= 0;
        else
            state <= next_state;
    end

    assign out = (state == S1011);

endmodule