module fluxo_de_dados (
    input        clock,
    input  [7:0] botoes,
    input 		   dificuldade,

    input        zera_contador_jogada,
    input        zera_contador_score,
    input        zera_timer_resultado,
    input        zera_timeout,
    input        zeraR,

    input        conta_score,
    input        conta_jogada,
    input        conta_timer_resultado,
    input        conta_timeout,
    
    input        registraR,
    input        liga_led,

    output [2:0] score,
    output [7:0] leds, 

    //TEMPO DE JOGO
    input zera_tempo_de_jogo,
    output [15:0] tempo_de_jogo_shiftado,
    input mostra_tempo_de_jogo,

    output       fim_timer_resultado,
    output       deu_timeout,
    output       jogada_igual_memoria,
    output       ultima_jogada,
    output       fez_jogada
    );

	 wire [7:0] fio_botoes;
	 assign fio_botoes = ~botoes;
    wire wideOr0;
    assign wideOr0 = |fio_botoes;
	 
		  wire [2:0] fio_contador_jogada;
    wire [7:0] fio_db_memoria;
    assign leds = liga_led ? fio_db_memoria : 8'b00000000;


	 wire [7:0] fio_db_jogada;

    // CONTADOR DE TIMEOUT POR DIFFICULDADE
    wire deu_timeout_0, deu_timeout_1;
    assign deu_timeout = (dificuldade == 1'b1) ? deu_timeout_1 : deu_timeout_0;
	 
    contador_m #(8000, 13) contador_timeout_dificuldade_0 (
        .clock( clock ),
        .zera_as  ( zera_timeout ), 
        .zera_s   ( 1'b0 ), 
        .conta  (  conta_timeout ),
        .Q  ( ),
        .fim    ( deu_timeout_0 ),
        .meio    ( )
	  );

    contador_m #(5000, 13) contador_timeout_dificuldade_1 (
        .clock( clock ),
        .zera_as  ( zera_timeout ), 
        .zera_s   ( 1'b0 ), 
        .conta  (  conta_timeout ),
        .Q  ( ),
        .fim    ( deu_timeout_1 ),
        .meio    ( )
	  );
//TEMPO DE JOGO
wire [15:0] fio_tempo_de_jogo,fio_tempo_de_jogo_shiftado;
assign tempo_de_jogo_shiftado = (mostra_tempo_de_jogo == 1'b1) ? fio_tempo_de_jogo_shiftado : 0;
      contador_tempo_de_jogo #(64000,16,3) contador_tempo_de_jogo(
        .clock( clock ),
        .zera_as  ( zera_tempo_de_jogo ), 
        .zera_s   ( 1'b0 ), 
        .conta  (  conta_timeout ),
        .Q      (fio_tempo_de_jogo ), 
        .Qshift (fio_tempo_de_jogo_shiftado), 
        .fim     ( ),
        .meio    ( )
      );

    //CONTADOR DE JOGADA
    wire fio_fim_dif_1, fio_fim_dif_0;
    assign ultima_jogada = (dificuldade == 1'b1) ? fio_fim_dif_1 : fio_fim_dif_0;
    contador_m #(8,3) contador_jogada (
        .clock( clock ),
        .zera_as  ( 1'b0 ), 
        .zera_s   ( zera_contador_jogada ), 
        .conta  (  conta_jogada ),
        .Q  ( fio_contador_jogada ),
        .fim    ( fio_fim_dif_1 ),
        .meio    ( fio_fim_dif_0 )
	  );   

    // CONTADOR DE SCORE
    contador_m #(8,3) contador_score (
        .clock( clock ),
        .zera_as  ( 1'b0 ), 
        .zera_s   ( zera_contador_score ), 
        .conta  (  conta_score ),
        .Q  ( score ),
        .fim    (  ),
        .meio    (  )
	  );   
     
    // COMPARADOR JOGADA IGUAL MEMORIA
    comparador_85 comparador_jogada_memoria (
      .A   ( fio_db_memoria ),
      .B   ( fio_db_jogada ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo(), 
      .AGBo(),
      .AEBo( jogada_igual_memoria )
    );
	 
    //ROM DA JOGADA
    sync_rom_8x8 rom (
        .clock (clock),
        .address ( fio_contador_jogada ),
        .data_out ( fio_db_memoria )
    );
	 
    //REGISTRADOR DE BOTAO
    registrador_8 registrador_jogada (
        .clock( clock ),
        .clear( zeraR ),
        .enable( registraR ),
        .D( fio_botoes ),
        .Q( fio_db_jogada  )
    );

    edge_detector detector (
        .clock( clock ),
        .reset( ~wideOr0 ),
        .sinal( wideOr0 ),
        .pulso( fez_jogada )
    );

    // TEMPORIZADOR DO LED DE RESULTADO
    contador_m #(2000,12) temporizador_led_resultado ( 
        .clock( clock ),
        .zera_as  ( 1'b0 ), 
        .zera_s   ( zera_timer_resultado ), 
        .conta  (  conta_timer_resultado ),
        .Q  (  ),
        .fim    ( fim_timer_resultado ),
        .meio    (  )
	  );   

endmodule
