module geogenius (
    input clock,
    input reset,
    input jogar,
    input [7:0] botoes, 
	 input dificuldade,
 
    output acertou,
	 output errou, 
    output pronto,
	 output timeout,
    output [7:0] leds, //leds na placa
    output [6:0] score, //display hexadecimal 


    // saidas depuracao
	 output db_jogada_igual_memoria,
    output db_ultima_jogada, 
    output db_fez_jogada, 
    output db_clock,
    output [6:0] db_estado
);

// saidas da unidade de controle
wire 	fio_zera_contador_jogada,
      fio_zera_contador_score,
	    // fio_zera_timer_led,	
      fio_zera_timer_resultado,
	    fio_zera_timeout,	
		  fio_zeraR,
      fio_conta_score, 
      fio_conta_jogada, 
    //   fio_conta_timer_led,
      fio_conta_timer_resultado,
      fio_conta_timeout,
      fio_liga_led,
      fio_registraR;

// sinais de condição do fluxo de dados
//wire  fio_fim_timer_led,
wire      fio_fim_timer_resultado,
      fio_deu_timeout,
      fio_jogada_igual_memoria, 
      fio_ultima_jogada, 
      fio_fez_jogada; 

wire [3:0]  fio_db_estado;
wire [2:0]  fio_score;


fluxo_de_dados FD(
    .clock ( clock ),
    .botoes ( botoes ),
    .dificuldade ( dificuldade ),
    .zera_contador_jogada ( fio_zera_contador_jogada ),
    .zera_contador_score(fio_zera_contador_score),
    // .zera_timer_led ( fio_zera_timer_led ),
    .zera_timer_resultado ( fio_zera_timer_resultado ),
    .zera_timeout ( fio_zera_timeout ),
    .zeraR ( fio_zeraR ),
    .conta_score ( fio_conta_score ),
    .conta_jogada ( fio_conta_jogada ),
    // .conta_timer_led ( fio_conta_timer_led ),
    .conta_timer_resultado ( fio_conta_timer_resultado ),
    .conta_timeout ( fio_conta_timeout ),
    .liga_led ( fio_liga_led ),
    .registraR ( fio_registraR ),
    // .fim_timer_led ( fio_fim_timer_led ),
    .fim_timer_resultado ( fio_fim_timer_resultado ),
	  .deu_timeout( fio_deu_timeout ),
    .jogada_igual_memoria ( fio_jogada_igual_memoria ),
    .ultima_jogada ( fio_ultima_jogada ),
    .fez_jogada ( fio_fez_jogada),
    .score ( fio_score ),
    .leds ( leds )
);

unidade_de_controle UC (
    .clock ( clock ),
    .reset ( reset ),
    .iniciar ( jogar ),
    // .fim_timer_led ( fio_fim_timer_led ),
    .fim_timer_resultado ( fio_fim_timer_resultado ),
    .deu_timeout ( fio_deu_timeout ),
    .jogada_igual_memoria ( fio_jogada_igual_memoria ),
    .ultima_jogada ( fio_ultima_jogada ),
    .fez_jogada ( fio_fez_jogada ),
    .pronto ( pronto ),
    .acertou ( acertou ),
    .errou ( errou ),
    .timeout ( timeout ),
    .zera_contador_jogada ( fio_zera_contador_jogada ),
    .zera_contador_score ( fio_zera_contador_score ),
    // .zera_timer_led ( fio_zera_timer_led ),
    .zera_timer_resultado ( fio_zera_timer_resultado ),
    .zera_timeout ( fio_zera_timeout ),
    .zeraR ( fio_zeraR ),
    .conta_score ( fio_conta_score ),
    .conta_jogada ( fio_conta_jogada ),
    // .conta_timer_led ( fio_conta_timer_led ),
    .conta_timer_resultado ( fio_conta_timer_resultado ),
    .conta_timeout ( fio_conta_timeout ),
    .liga_led ( fio_liga_led ),
    .registraR ( fio_registraR ),
    .db_estado ( fio_db_estado )
);

// falta display score - tem q alterar o módulo de display pra receber entrada de 3b e saída em base decimal, nn hexa.

hexa7seg display_score (
   .hexa( {1'b0, fio_score} ),
   .display( score )
);

hexa7seg display_estado (
   .hexa( fio_db_estado ),
   .display( db_estado )
);

assign db_clock = clock; 
assign db_jogada_igual_memoria = fio_jogada_igual_memoria;
assign db_fez_jogada = fio_fez_jogada;
assign db_ultima_jogada = fio_ultima_jogada;

endmodule 