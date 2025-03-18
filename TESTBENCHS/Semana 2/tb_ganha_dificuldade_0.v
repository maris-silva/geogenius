`timescale 1ns/1ns


module tb_ganha_dificuldade_0;
    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    wire        ganhou_out  ;
    wire        perdeu_out  ;
    wire        pronto_out  ;
    wire        timeout_out ;
    wire [7:0]  leds_out    ;
    wire [6:0]  score_out   ;

    wire        db_jogada_igual_memoria_out ;
    wire        db_ultima_jogada_out        ;
    wire        db_fez_jogada_out           ; 
    wire        db_clock_out                ;


    wire [7:0] db_jogada_out;
    wire [6:0] db_estado_out;

	
	//inputs
	reg        clock_in         = 1;
    reg        reset_in         = 0;
    reg        jogar_in         = 0;
    reg  [7:0] botoes_in        = 0;
    reg        dificuldade_in   = 0;
    reg  [7:0] vetor_rom    [7:0] ;
	 



    wire clock;
    assign clock = clock_in;

    parameter clockPeriod = 1_000_000; // in ns, f=1KHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    geogenius dut (
      .clock            ( clock         ),
      .reset            ( reset_in      ),
      .jogar            ( jogar_in      ), 
      .botoes           ( botoes_in     ),
      .dificuldade      ( dificuldade_in), //verificar
      .ganhou           ( ganhou_out    ),
      .perdeu           ( perdeu_out    ),
      .pronto           ( pronto_out    ),
      .timeout          ( timeout_out   ),
      .leds             ( leds_out      ),
      .score            ( score_out     ), //verificar

      .db_jogada_igual_memoria  (db_jogada_igual_memoria_out),
      .db_ultima_jogada         (db_ultima_jogada_out),
      .db_fez_jogada            (db_fez_jogada_out),
      .db_clock                 (db_clock_out),
      .db_jogada                (db_jogada_out),
      .db_estado                (db_estado_out)
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

      vetor_rom[0] = 8'b0000_0001;
      vetor_rom[1] = 8'b0000_0010;
      vetor_rom[2] = 8'b0000_0100;
      vetor_rom[3] = 8'b0000_1000;
      vetor_rom[4] = 8'b0001_0000;
      vetor_rom[5] = 8'b0010_0000;
      vetor_rom[6] = 8'b0100_0000;
      vetor_rom[7] = 8'b1000_0000;




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
        caso = 3 + nivel;

        for (jogada = 0; jogada < 4; jogada = jogada + 1) begin 
            #(2050*clockPeriod);      //delay para mostrar o led do país inicialmente
            @(negedge clock_in);
            botoes_in = vetor_rom[jogada];
            #(10*clockPeriod);
            botoes_in = 4'b0000; 
            #(2050*clockPeriod);   //mostrar se errou ou acertou

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
