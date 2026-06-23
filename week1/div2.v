module div2(input clk_in, input rst, output reg clk_div2);
    always @(posedge clk_in) begin
        if (rst)  
            clk_div2 <= 1'b0;
        else
            clk_div2 <= ~ clk_div2;
    end
endmodule 


