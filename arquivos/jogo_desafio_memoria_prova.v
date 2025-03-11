module jogo_desafio_memoria_prova (
    input clock,
    input reset,
    input jogar,
    input [15:0] botoes,
	 input dificuldade,
	 input memoria,
	 
  //   output ganhou,
	//  output perdeu, 
    output pronto,
    output [3:0] leds,
	 output timeout,


    // saidas depuracao
	 output db_jogada_igual_memoria,
    output db_endereco_igual_limite,
    output db_ultimo_nivel, 
    output db_fez_jogada, 
    output db_clock,
    output [6:0] db_nivel,
    output [15:0] db_jogada,
    output [6:0] db_estado,

    output [3:0] score
);

// saidas da unidade de controle
wire 	fio_zera_contador_nivel, 
		fio_zera_contador_jogada,
	   fio_zera_timeout,	
		fio_zeraR,
	   fio_zera_contador_led,
	   fio_zera_timer_led,	
		fio_conta_nivel, 
		fio_conta_jogada, 
		fio_conta_timeout,
		fio_conta_led,
		fio_conta_timer_led,
		fio_liga_led,
		fio_registraR;

// sinais de condição do fluxo de dados
wire  fio_jogada_igual_memoria, 
		fio_endereco_igual_limite, 
		fio_ultimo_nivel, 
		fio_fez_jogada; 

// saidas de dados do fluxo de dados
wire [3:0]  fio_db_jogada, 
				fio_db_nivel, 
				fio_db_estado, 
				fio_db_memoria;
		
wire 	fio_deu_timeout,
		fio_meio_timer_led,
		fio_fim_timer_led,
		fio_led_igual_nivel;

wire fio_zera_contador_score, fio_conta_score;

fluxo_de_dados_prova FD(
    .clock ( clock ),
    .botoes ( botoes ),
    .zera_contador_nivel ( fio_zera_contador_nivel ) ,
    .zera_contador_jogada ( fio_zera_contador_jogada ),
    .conta_nivel ( fio_conta_nivel ),
    .conta_jogada ( fio_conta_jogada ),
    .zeraR ( fio_zeraR ),
    .registraR ( fio_registraR ),
	 .dificuldade( dificuldade ),
    .jogada_igual_memoria ( fio_jogada_igual_memoria ),
    .endereco_igual_limite ( fio_endereco_igual_limite ),
    .ultimo_nivel ( fio_ultimo_nivel ),
    .fez_jogada ( fio_fez_jogada),
    .db_jogada (fio_db_jogada),
    .db_nivel (fio_db_nivel),
    .db_memoria (fio_db_memoria),
	 .deu_timeout( fio_deu_timeout ),
	 .conta_timeout ( fio_conta_timeout ),
	 .zera_timeout(fio_zera_timeout),
   .zera_contador_score(fio_zera_contador_score),
   .conta_score(fio_conta_score),
    .score ( score )
    //  .zera_contador_led(fio_zera_contador_led), 
    //  .contar_led(fio_conta_led),
    //  .liga_led(fio_liga_led), 
    //  .saida_led_igual_nivel(fio_led_igual_nivel), 
    //  .leds(leds), 
    //  .zera_timer_led(fio_zera_timer_led),  
    //  .conta_timer_led(fio_conta_timer_led),
    //  .meio_timer_led(fio_meio_timer_led), 
    //  .fim_timer_led(fio_fim_timer_led),
	  // .memoria(memoria)
);



unidade_controle_prova UC (
    .clock ( clock ),
    .reset ( reset ),
    .iniciar ( jogar ),
    .ultimo_nivel ( fio_ultimo_nivel ),
    .fez_jogada ( fio_fez_jogada ),
    .jogada_igual_memoria ( fio_jogada_igual_memoria ),
    // .endereco_igual_limite ( fio_endereco_igual_limite ),
    .zera_contador_nivel ( fio_zera_contador_nivel ),
    .zera_contador_jogada ( fio_zera_contador_jogada ),
    .conta_nivel ( fio_conta_nivel ),
    .conta_jogada ( fio_conta_jogada ),
    .zeraR ( fio_zeraR ),
    .registraR ( fio_registraR ),
    // .acertou ( ganhou ),
    // .errou ( perdeu ),
    .pronto ( pronto ),
    .db_estado ( fio_db_estado ),

	.timeout( timeout ),
	.conta_timeout (fio_conta_timeout ),
	.deu_timeout ( fio_deu_timeout ),
	.zera_timeout(fio_zera_timeout),

    // .meio_timer_led(fio_meio_timer_led),
    // .fim_timer_led(fio_fim_timer_led),
    // .led_igual_nivel(fio_led_igual_nivel),
    // .zera_contador_led(fio_zera_contador_led),
    // .contar_led(fio_conta_led),
    // .liga_led(fio_liga_led),

    // .zera_timer_led(fio_zera_timer_led),
    // .conta_timer_led(fio_conta_timer_led),

    .zera_contador_score(fio_zera_contador_score),
    .conta_score(fio_conta_score)
);




hexa7seg display_contagem_nivel (
   .hexa( fio_db_nivel ),
   .display( db_nivel )
);


hexa7seg display_estado (
   .hexa( fio_db_estado ),
   .display( db_estado )
);


assign db_clock = clock; 
assign db_jogada_igual_memoria = fio_jogada_igual_memoria;
assign db_endereco_igual_limite = fio_endereco_igual_limite;
assign db_ultimo_nivel = fio_ultimo_nivel; 
assign db_fez_jogada = fio_fez_jogada;
assign db_jogada = fio_db_jogada;

endmodule 