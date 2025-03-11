`timescale 1ns/1ns

// acertar tudo na memoria 0 na dificuldade 0 

module tb_template_ganha;
    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    wire       ganhou_out;
    wire       perdeu_out  ;
    wire       pronto_out ;
    wire [3:0] leds_out   ;

    wire        db_jogada_igual_memoria_out;
    wire        db_endereco_igual_limite_out;
    wire        db_ultimo_nivel_out; 
    wire        db_fez_jogada_out;
    wire        db_clock_out;


    wire [6:0] db_nivel_out;
    wire [3:0] db_jogada_out;
    wire [6:0] db_estado_out;
	 wire timeout_out;
	 
	 reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in = 0;
    reg  [3:0] botoes_in  = 4'b0000;
    reg  [3:0]  vetor_rom[15:0];
	 
    
    reg dificuldade_in = 1;
	 reg memoria = 0;



    wire clock;
    assign clock = clock_in;

    parameter clockPeriod = 1_000_000; // in ns, f=1KHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    jogo_desafio_memoria_desafio dut (
      .clock          ( clock    ),
      .reset          ( reset_in    ),
      .jogar          ( jogar_in  ), 
      .botoes         ( botoes_in   ),
      .ganhou         ( ganhou_out ),
      .perdeu         ( perdeu_out   ),
      .pronto         ( pronto_out  ),
      .leds           ( leds_out    ),

      .db_jogada_igual_memoria (db_jogada_igual_memoria_out),
      .db_endereco_igual_limite (db_endereco_igual_limite_out),
      .db_ultimo_nivel    (db_ultimo_nivel_out), 
      .db_fez_jogada      (db_fez_jogada_out), 
      .db_clock         (db_clock_out),
      
      .db_nivel       ( db_nivel_out ),
      .db_jogada      ( db_jogada_out ),
      .db_estado      ( db_estado_out ), 

      .dificuldade( dificuldade_in), 
      .timeout( timeout_out),
      .memoria(memoria)


    );
    integer nivel;
    integer jogada; 
    integer loop_led;
    integer i;

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      jogar_in = 0;
      botoes_in  = 4'b0000;
      #clockPeriod;

      vetor_rom[0] = 4'b0001;
      vetor_rom[1] = 4'b0010;
      vetor_rom[2] = 4'b0100;
      vetor_rom[3] = 4'b1000;
      vetor_rom[4] = 4'b0100;
      vetor_rom[5] = 4'b0010;
      vetor_rom[6] = 4'b0001;
      vetor_rom[7] = 4'b0001;
      vetor_rom[8] = 4'b0010;
      vetor_rom[9] = 4'b0010;
      vetor_rom[10] = 4'b0100;
      vetor_rom[11] = 4'b0100;
      vetor_rom[12] = 4'b1000;
      vetor_rom[13] = 4'b1000;
      vetor_rom[14] = 4'b0001;
      vetor_rom[15] = 4'b0100;



      // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;

      // espera
      #(10*clockPeriod);

      // Teste 2. iniciar=1 por 5 periodos de clock, passando do estado inicial para o de preparacao 
      caso = 2;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;

      // espera
      #(10*clockPeriod);

      // Inicio do loop 
      for(nivel = 0; nivel < 9; nivel = nivel + 1) begin
        caso = 3 + nivel;
        for (loop_led = 0; loop_led <= nivel; loop_led = loop_led + 1) begin
            #(1050*clockPeriod);
        end        
        for (jogada = 0; jogada < nivel + 1; jogada = jogada + 1) begin 
            @(negedge clock_in);
            botoes_in = vetor_rom[jogada];
            #(10*clockPeriod);
            botoes_in = 4'b0000; 
            #(10*clockPeriod);   
        end 
      end 
    
    
    // for de espera dos leds
      
      // for (i = 0; i <= 9; i = i + 1) // substituir nivel
      //     #(1050*clockPeriod);
      
      
    //   jogada na mão

      // botoes_in = vetor_rom[0];
      // #(10*clockPeriod);
      // botoes_in = 4'b0000;
      // #(10*clockPeriod);


    // timeout
      // for (i = 0; i <= 5; i = i + 1) // for de timeout
      //     #(1050*clockPeriod);


      caso = 99;
      
      #(10*clockPeriod)  
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
