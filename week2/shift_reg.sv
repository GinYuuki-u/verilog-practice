module shift_reg #(parameter WIDTH=4 //位宽=4
)(
    input  logic             rst,
    input  logic             clk,
    input  logic             en,
    input  logic             serial_in,
    output logic [WIDTH-1:0] q,
    output logic             serial_out
);

    assign serial_out = q[0];

    always_ff @(posedge clk) begin
        if(rst)
            q <= 0;
        else if(en)
            q <= {serial_in, q[WIDTH-1:1]};
    end
endmodule

