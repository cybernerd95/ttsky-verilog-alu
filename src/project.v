module tt_um_alu_4bit (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire       clk,
    input  wire       rst_n
);

    wire [3:0] A;
    wire [3:0] B;
    wire [2:0] opcode;

    assign A      = ui_in[3:0];
    assign opcode = ui_in[7:5];
    assign B      = {3'b000, ui_in[4]};

    reg  [4:0] result_ext;
    wire [3:0] result;
    wire carry;
    wire zero;

    always @(*) begin
        case (opcode)
            3'b000: result_ext = A + B;
            3'b001: result_ext = A - B;
            3'b010: result_ext = {1'b0, A & B};
            3'b011: result_ext = {1'b0, A | B};
            3'b100: result_ext = {1'b0, A ^ B};
            3'b101: result_ext = {1'b0, ~A};
            3'b110: result_ext = {1'b0, A << 1};
            3'b111: result_ext = {1'b0, A >> 1};
            default: result_ext = 5'b00000;
        endcase
    end

    assign result = result_ext[3:0];
    assign carry  = result_ext[4];
    assign zero   = (result == 4'b0000);

    assign uo_out[3:0] = result;
    assign uo_out[4]   = carry;
    assign uo_out[5]   = zero;
    assign uo_out[7:6] = 2'b00;

endmodule
