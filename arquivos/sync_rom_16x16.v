//------------------------------------------------------------------
// Arquivo   : sync_rom_16x4.v
// Projeto   : Experiencia 3 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x4 (conteúdo pre-programado)
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module sync_rom_16x16 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [15:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 16'b0000000000000001;
            4'b0001: data_out = 16'b0000000000000010;
            4'b0010: data_out = 16'b0000000000000100;
            4'b0011: data_out = 16'b0000000000001000;
            4'b0100: data_out = 16'b0000000000010000;
            4'b0101: data_out = 16'b0000000000100000;
            4'b0110: data_out = 16'b0000000001000000;
            4'b0111: data_out = 16'b0000000010000000;
            4'b1000: data_out = 16'b0000000100000000;
            4'b1001: data_out = 16'b0000001000000000;
            4'b1010: data_out = 16'b0000010000000000;
            4'b1011: data_out = 16'b0000100000000000;
            4'b1100: data_out = 16'b0001000000000000;
            4'b1101: data_out = 16'b0010000000000000;
            4'b1110: data_out = 16'b0100000000000000;
            4'b1111: data_out = 16'b1000000000000000;
        endcase
    end
endmodule

