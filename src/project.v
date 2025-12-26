`default_nettype none

module tt_um_alu_4bit (
    input  wire [7:0] ui_in,     // Dedicated inputs
    output wire [7:0] uo_out,    // Dedicated outputs
    input  wire [7:0] uio_in,    // IOs: Input path
    output wire [7:0] uio_out,   // IOs: Output path
    output wire [7:0] uio_oe,    // IOs: Enable path
    input  wire       ena,       // Enable
    input  wire       clk,       // Clock
    input  wire       rst_n       // Active-low reset
);


    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;


    wire [3:0] A      = ui_in[3:0];
    wire       B      = ui_in[4];
    wire [2:0] opcode = ui_in[7:5];


    reg [4:0] result_ext;

    always @(*) begin
        if (!ena) begin
            result_ext = 5'b00000;
        end else begin
            case (opcode)
                3'b000: result_ext = A + B;          // ADD
                3'b001: result_ext = A - B;          // SUB
                3'b010: result_ext = {1'b0, A & B};  // AND
                3'b011: result_ext = {1'b0, A | B};  // OR
                3'b100: result_ext = {1'b0, A ^ B};  // XOR
                3'b101: result_ext = {1'b0, ~A};     // NOT
                3'b110: result_ext = {1'b0, A << 1}; // SHL
                3'b111: result_ext = {1'b0, A >> 1}; // SHR
                default: result_ext = 5'b00000;
            endcase
        end
    end


    wire [3:0] result = result_ext[3:0];
    wire       carry  = result_ext[4];
    wire       zero   = (result == 4'b0000);

    assign uo_out[3:0] = result;
    assign uo_out[4]   = carry;
    assign uo_out[5]   = zero;
    assign uo_out[7:6] = 2'b00;

endmodule
