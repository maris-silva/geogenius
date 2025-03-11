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
module unidade_controle_prova(
    input      clock,
    input      reset,
    input      iniciar,
    input      ultimo_nivel,
    input      fez_jogada, //verifica se chaves !=0000
	  input 	   jogada_igual_memoria, //compara os valores da jogada com a ROM
    // input      endereco_igual_limite, //verifica se o contador atingiu o limite daquela nivel
	  input      deu_timeout,
	  // input      meio_timer_led,
    // input      fim_timer_led,
    // input      led_igual_nivel,
    
	 output reg zera_contador_nivel,
    output reg zera_contador_jogada,
    output reg zera_contador_score,
	 output reg conta_score,
    output reg conta_nivel, //responsável por aumentar o contador que dita as nivels 
    output reg conta_jogada,//responsável pelo contador que dita a posicao da memoria em cada jogada
    output reg zeraR,
    output reg registraR,
    output reg pronto,
	//  output reg acertou,
	//  output reg errou,

	output reg timeout,
	output reg conta_timeout,
	output reg zera_timeout,

    // output reg zera_contador_led,
    // output reg contar_led,
    // output reg liga_led,

    // output reg zera_timer_led,
    // output reg conta_timer_led,

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
    parameter acertou_estado               = 4'b1000;  // 8
    parameter errou_estado                 = 4'b1001;  // 9
    parameter proxima_jogada        = 4'b1010;  // A
    parameter fim_estado            = 4'b1011;  // B
    parameter timeout_estado 	    = 4'b1101;  // D
    
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
            // liga_led_estado:        Eprox <= meio_timer_led ? desliga_led_estado : liga_led_estado;
            // desliga_led_estado:     begin
            //     if (fim_timer_led) Eprox <= avanca_led_estado;
            //     else Eprox <= desliga_led_estado;
            // end
            // avanca_led_estado:      Eprox <= liga_led_estado;
            aguarda_jogada:         Eprox <= deu_timeout ? timeout_estado : (fez_jogada ? registra : aguarda_jogada);
            registra:               Eprox <= comparacao;
            comparacao:             begin
                if (jogada_igual_memoria == 1'b1) Eprox <= acertou_estado;
                else Eprox <= errou_estado;
            end
            acertou_estado:         Eprox <= ultimo_nivel ? fim_estado : proxima_jogada;
            errou_estado:           Eprox <= ultimo_nivel ? fim_estado : proxima_jogada;
            proxima_jogada:         Eprox <= aguarda_jogada;
           // proximo_nivel:          Eprox <= liga_led_estado;
            fim_estado: 		    Eprox <= iniciar ? inicial : fim_estado;
          //  acertou_estado:         Eprox <= iniciar ? inicial : acertou_estado;
            timeout_estado:			Eprox <= iniciar ? inicial : timeout_estado;
				default:            Eprox <= inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zera_contador_jogada        = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zera_contador_nivel         = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        conta_nivel                 = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        conta_jogada                = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        registraR                   = (Eatual == registra) ? 1'b1 : 1'b0;
        pronto                      = (Eatual == acertou_estado || Eatual == errou_estado || Eatual == timeout_estado) ? 1'b1 : 1'b0;
        // errou 	                  = (Eatual == errou_estado) ? 1'b1 : 1'b0;
        // acertou                  = (Eatual == acertou_estado) ? 1'b1 : 1'b0;
        zera_timeout 					= (Eatual == preparacao || Eatual ==inicial ||Eatual == registra);
        timeout                     = (Eatual == timeout_estado) ? 1'b1 : 1'b0;
        conta_timeout               = (Eatual == aguarda_jogada) ? 1'b1 : 1'b0;
        // zera_contador_led        = (Eatual == preparacao || Eatual == proximo_nivel) ? 1'b1 : 1'b0;
        // contar_led               = (Eatual == avanca_led_estado) ? 1'b1 : 1'b0;
        // liga_led                 = (Eatual == liga_led_estado) ? 1'b1 : 1'b0;
        // zera_timer_led           = (Eatual == preparacao || Eatual == avanca_led_estado || Eatual == proximo_nivel) ? 1'b1 : 1'b0;
        // conta_timer_led          = (Eatual == liga_led_estado || Eatual == desliga_led_estado) ? 1'b1 : 1'b0;
        zeraR                       = (Eatual == inicial || Eatual == preparacao 
													  || Eatual == proxima_jogada 
													  || Eatual == acertou_estado || Eatual == errou_estado) ? 1'b1 : 1'b0; 					
        zera_contador_score = (Eatual == timeout_estado || Eatual == fim_estado) ? 1'b1 : 1'b0;
        conta_score = (Eatual == acertou_estado) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:               db_estado <= inicial;             // 0
            preparacao:            db_estado <= preparacao;          // 1
            liga_led_estado:       db_estado <= liga_led_estado;     // 2
            desliga_led_estado:    db_estado <= desliga_led_estado;  // 3
            avanca_led_estado:     db_estado <= avanca_led_estado;   // 4
            aguarda_jogada:        db_estado <= aguarda_jogada;      // 5
            registra:              db_estado <= registra;            // 6
            comparacao:            db_estado <= comparacao;          // 7
            acertou_estado:        db_estado <= acertou_estado;  // 8
            errou_estado:          db_estado <= errou_estado;  // 9    
            proxima_jogada:        db_estado <= proxima_jogada;      // A
            fim_estado:            db_estado <= fim_estado;        // E
            timeout_estado: 	     db_estado <= timeout_estado;      // D
				default: 	           db_estado <= 4'b1011;             // B
        endcase
		end
endmodule
