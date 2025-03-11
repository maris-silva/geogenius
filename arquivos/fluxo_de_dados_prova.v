module fluxo_de_dados_prova (
    input        clock,
    input  [3:0] botoes,
    input        zera_contador_nivel,
    input        zera_contador_jogada,
    input        conta_nivel,
    input        conta_jogada,
    input        zeraR,
    input        registraR,
	 input 		  dificuldade,
	 input        zera_contador_led,
    input        contar_led,
    input        liga_led,
	 input        zera_timer_led,
    input        conta_timer_led,
	 input        conta_timeout,
    input        zera_timeout,
	 input        memoria,
	 
	 
    output       jogada_igual_memoria,
    output       endereco_igual_limite,
    output       ultimo_nivel,
    output       fez_jogada,
    output [3:0] db_jogada,
    output [3:0] db_memoria,
    output [3:0] db_nivel,


    output saida_led_igual_nivel,
    output [3:0] leds,
    output meio_timer_led,
    output fim_timer_led,
    output deu_timeout
    );



    wire wideOr0;
    assign wideOr0 = botoes[3] || botoes[2] || botoes[1] || botoes[0];
	 
	 wire [3:0] db_memoria0, db_memoria1;
	 assign db_memoria = memoria ? db_memoria1 : db_memoria0;
	 
	 wire [3:0] valor_rom_led;
	 wire [3:0] valor_rom_led0, valor_rom_led1;
	 wire [3:0] saida_contador_led;
	 
	 wire [3:0] fio_contador_jogada;

	 
	 assign valor_rom_led = memoria ? valor_rom_led1 : valor_rom_led0;
	 assign leds = liga_led ? valor_rom_led : 4'b0000;

		
    contador_163 contador_led (
        .clock( clock ),
        .clr  ( ~zera_contador_led ),  
        .ld   ( 1'b1 ), 
        .ent  ( 1'b1 ),
        .enp  ( contar_led ), 
        .D    ( 4'b0 ),
        .Q    ( saida_contador_led ), 
        .rco  ( )
    );

    comparador_85 comparador_led_igual_nivel (
      .A   ( db_nivel ),
      .B   ( saida_contador_led ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo(), 
      .AGBo(),
      .AEBo( saida_led_igual_nivel ) 
    );
	 
	 	 
	 
    sync_rom_16x4_0 rom_leds0 (
        .clock (clock),
        .address ( saida_contador_led ), 
        .data_out ( valor_rom_led0 ) 
    );
	 
	 sync_rom_16x4_1 rom_leds1 (
        .clock (clock),
        .address ( saida_contador_led ), 
        .data_out ( valor_rom_led1 ) 
    );

    contador_m #(1000, 10) timer_led (
        .clock( clock ),
        .zera_as  ( zera_timer_led ), 
        .zera_s   ( 1'b0 ), 
        .conta  (  conta_timer_led ), 
        .Q  ( ),
        .fim    ( fim_timer_led ),
        .meio    (meio_timer_led)
	  );

	
    contador_m #(5000, 13) contador_timeout (
        .clock( clock ),
        .zera_as  ( zera_timeout ), 
        .zera_s   ( 1'b0 ), 
        .conta  (  conta_timeout ),
        .Q  ( ),
        .fim    ( deu_timeout ),
        .meio    ( )
	  );

    //CONTADOR DE NÍVEL
    wire fio_nivel_15, fio__nivel_7;
    assign ultimo_nivel = (dificuldade == 1'b1) ? fio_nivel_15 : fio__nivel_7;
    contador_m #(16,4) contador_nivel (
        .clock( clock ),
        .zera_as  ( 1'b0 ), 
        .zera_s   ( zera_contador_nivel ), 
        .conta  (  conta_nivel ),
        .Q  ( db_nivel ),
        .fim    ( fio_nivel_15 ),
        .meio    ( fio__nivel_7 )
	  );   
    
	 // COMPARADOR ENTRE JOGADA E NIVEL
    comparador_85 comparador_endereco_limite (
      .A   ( db_nivel ),
      .B   ( fio_contador_jogada ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo(), 
      .AGBo(),
      .AEBo( endereco_igual_limite )
    );
	 
    // CONTADOR DE JOGADA
    contador_163 contador_jogada (
        .clock( clock ),
        .clr  ( ~zera_contador_jogada ), 
        .ld   ( 1'b1 ), 
        .ent  ( 1'b1 ),
        .enp  ( conta_jogada ),
        .D    ( 4'b0 ),
        .Q    ( fio_contador_jogada ),
        .rco  ( )
    );
	 
    // COMPARADOR JOGADA IGUAL MEMORIA
    comparador_85 comparador_jogada_memoria (
      .A   ( db_memoria ),
      .B   ( db_jogada ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo(), 
      .AGBo(),
      .AEBo( jogada_igual_memoria )
    );
	 
    //ROM DA JOGADA0
    sync_rom_16x4_0 rom_jogada0 (
        .clock (clock),
        .address ( fio_contador_jogada ),
        .data_out ( db_memoria0 )
    );
	 
	 //ROM DA JOGADA1
    sync_rom_16x4_1 rom_jogada1 (
        .clock (clock),
        .address ( fio_contador_jogada ),
        .data_out ( db_memoria1 )
    );
	 
	 
	 
    //REGISTRADOR DE BOTAO
    registrador_4 registrador_jogada (
        .clock( clock ),
        .clear( zeraR ),
        .enable( registraR ),
        .D( botoes ),
        .Q( db_jogada )
    );

    edge_detector detector (
        .clock( clock ),
        .reset( ~wideOr0 ),
        .sinal( wideOr0 ),
        .pulso( fez_jogada )
    );
endmodule
