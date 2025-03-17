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
module sync_rom_16x8 (clock, address, data_out);
    input            clock;
    input      [2:0] address;
    output reg [7:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            3'b000: data_out = 8'b00000001;
            3'b001: data_out = 8'b00000010;
            3'b010: data_out = 8'b00000100;
            3'b011: data_out = 8'b00001000;
            3'b100: data_out = 8'b00010000;
            3'b101: data_out = 8'b00100000;
            3'b110: data_out = 8'b01000000;
            3'b111: data_out = 8'b10000000;
        endcase
    end
endmodule

