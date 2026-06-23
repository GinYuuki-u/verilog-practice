module loadable_counter #(parameter WIDTH = 4              // 计数器位宽默认 4 位
)(
    input  logic             clk,    // 时钟
    input  logic             rst,    // 同步复位
    input  logic             load,   // 加载使能
    input  logic [WIDTH-1:0] data,   // 待装入的值
    output logic [WIDTH-1:0] count   // 当前计数值
);

    always_ff@(posedge clk) begin
        if(rst) 
            count <= 0;
        else if(load)
            count <= data;
        else   
            count <= count + 1;
    end
endmodule