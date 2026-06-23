module div3(input clk_in, input rst, output clk_div3);

    logic [1:0] cnt_p;
    logic [1:0] cnt_n;

    always_ff @(posedge clk_in) begin //上升沿 
        if (rst)
            cnt_p <= 2'd0;
        else if (cnt_p != 2'd2)
            cnt_p <= cnt_p + 1'b1;
        else 
            cnt_p <= 0;
    end

    always_ff @(negedge clk_in) begin
        if (rst)
            cnt_n <= 2'd0;
        else if (cnt_n != 2'd2)
            cnt_n <= cnt_n + 1'b1;
        else 
            cnt_n <= 0;
    end

    assign clk_div3 = (cnt_p == 2'd2) | (cnt_n == 2'd2);

endmodule

