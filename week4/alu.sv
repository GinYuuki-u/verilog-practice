module alu #(parameter WIDTH = 16) (
    input  logic       [WIDTH-1:0]a,
    input  logic       [WIDTH-1:0]b,
    input  logic            [2:0]op,
    input  logic                cin, //加法里是进位，减法里是借位 cin=1时候计算方法为a-b-cin
    output logic  [WIDTH-1:0]result,
    output logic               zero,
    output logic              carry, //加法里是进位，减法里是借位 carry=1时候a<b
    output logic           overflow,
    output logic           negative
    );

    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR  = 3'b011;
    localparam ALU_XOR = 3'b100;
    localparam ALU_NOT = 3'b101;
    localparam ALU_SLL = 3'b110;
    localparam ALU_SRL = 3'b111;

    always_comb begin
         //默认值
        result = 0;
        carry = 0;
        case(op)
            ALU_ADD: {carry, result} = a + b + cin;
            ALU_SUB: {carry, result} = a - b - cin; //够减 如5+(~3) 结果最高位为0，反之为1
            ALU_AND:          result = a & b;
            ALU_OR :          result = a | b;
            ALU_XOR:          result = a ^ b;
            ALU_NOT:          result = ~a   ;
            ALU_SLL:          result = a << b[$clog2(WIDTH)-1:0];
            ALU_SRL:          result = a >> b[$clog2(WIDTH)-1:0];
        endcase
    end

    assign zero     =   (result == 0);
    assign negative = result[WIDTH-1];
    assign overflow = ((op==ALU_ADD) && (a[WIDTH-1] == b[WIDTH-1]) && (result[WIDTH-1]!=a[WIDTH-1]) )|| 
                      ((op==ALU_SUB) && (a[WIDTH-1] != b[WIDTH-1]) && (result[WIDTH-1]!=a[WIDTH-1]) ) ; 
                    //两个加数同正/负，而结果为负/正；两个减数分别为正负/负正，而结果为负/正。这里不用考虑cin

            
endmodule