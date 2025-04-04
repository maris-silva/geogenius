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
    output [7:0] leds, 
    output [6:0] score, 

    //leds de saida para o tempo medio
    output [6:0] display_tempo_de_jogo_0,
    output [6:0] display_tempo_de_jogo_1,
    output [6:0] display_tempo_de_jogo_2,
    output [6:0] display_tempo_de_jogo_3,
	 
	 //saidas analog discovery
	 output AD_jogar,
	 output AD_reset,
	 output AD_aguarda_jogada,
	 output AD_acertou,
	 output AD_errou,
	 output AD_timeout,
	 output AD_dificuldade,


    // saidas depuracao
	 output db_jogada_igual_memoria,
    output db_ultima_jogada, 
    output db_fez_jogada, 
    output db_clock,
    output [6:0] db_estado,
	 output [7:0] botoes_out
    
);
assign botoes_out = botoes;

//assigns externos para o analogdiscovery fazer a analsie de dados
assign AD_jogar = jogar;
assign AD_reset = reset;
assign AD_aguarda_jogada = fio_conta_timeout;
assign AD_acertou = acertou;
assign AD_errou = errou;
assign AD_timeout = timeout;
assign AD_dificuldade = dificuldade;

// saidas da unidade de controle
wire 	fio_zera_contador_jogada,
      fio_zera_contador_score,
      fio_zera_timer_resultado,
	    fio_zera_timeout,	
		  fio_zeraR,
      fio_conta_score, 
      fio_conta_jogada, 
      fio_conta_timer_resultado,
      fio_conta_timeout,
      fio_liga_led,
      fio_registraR;

// sinais de condição do fluxo de dados
wire      fio_fim_timer_resultado,
      fio_deu_timeout,
      fio_jogada_igual_memoria, 
      fio_ultima_jogada, 
      fio_fez_jogada; 

wire [3:0]  fio_db_estado;
wire [3:0]  fio_score;

//tempo de jogo
wire fio_zera_tempo_de_jogo;
wire [15:0] fio_tempo_de_jogo_shiftado;

fluxo_de_dados FD(
    .clock ( clock ),
    .botoes ( botoes ),
    .dificuldade ( dificuldade ),
    .zera_contador_jogada ( fio_zera_contador_jogada ),
    .zera_contador_score(fio_zera_contador_score),
    .zera_timer_resultado ( fio_zera_timer_resultado ),
    .zera_timeout ( fio_zera_timeout ),
    .zeraR ( fio_zeraR ),
    .conta_score ( fio_conta_score ),
    .conta_jogada ( fio_conta_jogada ),
    .conta_timer_resultado ( fio_conta_timer_resultado ),
    .conta_timeout ( fio_conta_timeout ),
    .liga_led ( fio_liga_led ),
    .registraR ( fio_registraR ),
    .fim_timer_resultado ( fio_fim_timer_resultado ),
	  .deu_timeout( fio_deu_timeout ),
    .jogada_igual_memoria ( fio_jogada_igual_memoria ),
    .ultima_jogada ( fio_ultima_jogada ),
    .fez_jogada ( fio_fez_jogada),
    .score ( fio_score ),
    .zera_tempo_de_jogo (fio_zera_tempo_de_jogo),
    .tempo_de_jogo_shiftado(fio_tempo_de_jogo_shiftado),
    .mostra_tempo_de_jogo (fio_mostra_tempo_de_jogo),
    .leds ( leds )
);
wire fio_mostra_tempo_de_jogo;

unidade_de_controle UC (
    .clock ( clock ),
    .reset ( reset ),
    .iniciar ( jogar ),
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
    .zera_timer_resultado ( fio_zera_timer_resultado ),
    .zera_timeout ( fio_zera_timeout ),
    .zeraR ( fio_zeraR ),
    .conta_score ( fio_conta_score ),
    .conta_jogada ( fio_conta_jogada ),
    .conta_timer_resultado ( fio_conta_timer_resultado ),
    .conta_timeout ( fio_conta_timeout ),
    .liga_led ( fio_liga_led ),
    .registraR ( fio_registraR ),
    .zera_tempo_de_jogo (fio_zera_tempo_de_jogo),
    .mostra_tempo_de_jogo (fio_mostra_tempo_de_jogo),
    .db_estado ( fio_db_estado )
);


hexa7seg display_score (
   .hexa( fio_score ),
   .display( score )
);

hexa7seg display_estado (
   .hexa( fio_db_estado ),
   .display( db_estado )
);

//saida de tempo de jogo shiftada
wire [16:0] saida_tempo_de_jogo_BCD;
bin2bcd conversor_BCD (
    .bin(fio_tempo_de_jogo_shiftado),
    .bcd(saida_tempo_de_jogo_BCD)
);

hexa7seg displayer_tempo_de_jogo_0(
   .hexa(  saida_tempo_de_jogo_BCD[3:0] ),
   .display(display_tempo_de_jogo_0 )
);

hexa7seg displayer_tempo_de_jogo_1(
   .hexa(  saida_tempo_de_jogo_BCD[7:4] ),
   .display( display_tempo_de_jogo_1 )
);

hexa7seg displayer_tempo_de_jogo_2(
   .hexa(  saida_tempo_de_jogo_BCD[11:8] ),
   .display( display_tempo_de_jogo_2 )
);

hexa7seg displayer_tempo_de_jogo_3(
   .hexa(  saida_tempo_de_jogo_BCD[15:12] ),
   .display( display_tempo_de_jogo_3 )
);

assign db_clock = clock; 
assign db_jogada_igual_memoria = fio_jogada_igual_memoria;
assign db_fez_jogada = fio_fez_jogada;
assign db_ultima_jogada = fio_ultima_jogada;

endmodule 