//------------------------------------------------------------------
// Arquivo   : unidade_controle.v
// Projeto   : Experiencia 6 
//------------------------------------------------------------------
// Descricao : Unidade de controle
//
// usar este codigo como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     08/02/2024  1.0     João Victor, Isabela pera e mari sol zá,   versao inicial
//------------------------------------------------------------------
//
module unidade_de_controle (
    input      clock,
    input      reset,
    input      iniciar,

    // sinais de condicao
    //input      fim_timer_led,
    input      fim_timer_resultado,
	  input      deu_timeout,
	  input 	   jogada_igual_memoria, 
    input      ultima_jogada,
    input      fez_jogada, 
    
    // 4 leds no tabuleiro
    output reg pronto,
    output reg acertou,
    output reg errou,
    output reg timeout,

    // sinais de controle e depuracao
    output reg zera_contador_jogada,
    output reg zera_contador_score,
    //output reg zera_timer_led,
    output reg zera_timer_resultado,
    output reg zera_timeout,
    output reg zeraR,

	  output reg conta_score,
    output reg conta_jogada,
    //output reg conta_timer_led,
    output reg conta_timer_resultado,
    output reg conta_timeout,

    //Tempo de jogo
    output reg zera_tempo_de_jogo,
    output reg mostra_tempo_de_jogo,

    output reg registraR,
    output reg liga_led,

    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial               = 4'b0000;  // 0
    parameter preparacao            = 4'b0001;  // 1
    parameter liga_led_estado       = 4'b0010;  // 2
    parameter desliga_led_estado    = 4'b0011;  // 3
    parameter avanca_led_estado     = 4'b0100;  // 4
    parameter aguarda_jogada        = 4'b0101;  // 5
    parameter registra              = 4'b0110;  // 6
    parameter comparacao            = 4'b0111;  // 7
    parameter proxima_jogada        = 4'b1000;  // 8
    parameter conta_estado		    = 4'b1001;	// 9
	parameter acertou_estado        = 4'b1100;  // C
    parameter timeout_estado        = 4'b1101;  // D
    parameter errou_estado          = 4'b1110;  // E
    parameter fim_estado            = 4'b1111;  // F
    
    // Variaveis de estado
    reg [3:0] Eatual, Eprox;
	 
    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:                Eprox <= iniciar ? preparacao : inicial;
            preparacao:             Eprox <= aguarda_jogada;
            aguarda_jogada:         Eprox <= deu_timeout ? timeout_estado : (fez_jogada ? registra : aguarda_jogada);
            registra:               Eprox <= comparacao;
            comparacao:             Eprox <= jogada_igual_memoria ? conta_estado : errou_estado;
				conta_estado:				Eprox <= acertou_estado;
				acertou_estado:         Eprox <= fim_timer_resultado ? (ultima_jogada ? fim_estado : proxima_jogada ) : acertou_estado;
            errou_estado:           Eprox <= fim_timer_resultado ? (ultima_jogada ? fim_estado : proxima_jogada ) : errou_estado;
				proxima_jogada:         Eprox <= aguarda_jogada;
            fim_estado: 		      Eprox <= iniciar ? inicial : fim_estado;
            // timeout_estado:			Eprox <= iniciar ? inicial : timeout_estado;
            timeout_estado:			Eprox <= proxima_jogada;
				default:                Eprox <= inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zera_contador_jogada        = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        conta_jogada                = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        registraR                   = (Eatual == registra) ? 1'b1 : 1'b0;
        zera_timeout 					= (Eatual == preparacao || Eatual == inicial || Eatual == registra) ? 1'b1 : 1'b0;
        conta_timeout               = (Eatual == aguarda_jogada) ? 1'b1 : 1'b0;
        liga_led                    = (Eatual == aguarda_jogada) ? 1'b1 : 1'b0;
        //zera_timer_led              = (Eatual == preparacao || Eatual == avanca_led_estado) ? 1'b1 : 1'b0;
        //conta_timer_led             = (Eatual == liga_led_estado) ? 1'b1 : 1'b0;
        zeraR                       = (Eatual == inicial || Eatual == preparacao 
													          || Eatual == proxima_jogada 
													          || Eatual == acertou_estado || Eatual == errou_estado) ? 1'b1 : 1'b0; 					
        zera_contador_score         = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        conta_score                 = (Eatual == conta_estado) ? 1'b1 : 1'b0;
        zera_timer_resultado        = (Eatual == preparacao || Eatual == inicial || Eatual == registra) ? 1'b1 : 1'b0;
        conta_timer_resultado       = (Eatual == acertou_estado || Eatual == errou_estado) ? 1'b1 : 1'b0;
        pronto                      = (Eatual == fim_estado) ? 1'b1 : 1'b0; // nao fica mais ativo no timeout
        errou 	                     = (Eatual == errou_estado) ? 1'b1 : 1'b0;
        acertou                     = (Eatual == acertou_estado) ? 1'b1 : 1'b0;
        timeout                     = (Eatual == timeout_estado) ? 1'b1 : 1'b0;
        //tempo de jogo
        zera_tempo_de_jogo          = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        mostra_tempo_de_jogo        = (Eatual == fim_estado) 1'b1 : 1'b0;
        // Saida de depuracao (estado)
        case (Eatual)
            inicial:               db_estado <= inicial;             // 0
            preparacao:            db_estado <= preparacao;          // 1
            //liga_led_estado:       db_estado <= liga_led_estado;     // 2
            //desliga_led_estado:    db_estado <= desliga_led_estado;  // 3
            //avanca_led_estado:     db_estado <= avanca_led_estado;   // 4
            aguarda_jogada:        db_estado <= aguarda_jogada;      // 5
            registra:              db_estado <= registra;            // 6
            comparacao:            db_estado <= comparacao;          // 7
            proxima_jogada:        db_estado <= proxima_jogada;      // 8
				conta_estado:	    db_estado <= conta_estado;
            acertou_estado:        db_estado <= acertou_estado;      // C
            timeout_estado: 	     db_estado <= timeout_estado;      // D
            errou_estado:          db_estado <= errou_estado;        // E    
            fim_estado:            db_estado <= fim_estado;          // F
				default: 	        db_estado <= 4'b1011;             // B
        endcase
		end
endmodule
