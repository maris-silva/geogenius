from WF_SDK import device, static, supplies 
from time import sleep, time
import os
import pandas as pd

DEVICE_NAME = "Analog Discovery 2"
CSV_RESULTADOS = 'resultados.csv'
CSV_PONTUACOES = 'pontuacoes.csv'
SLEEP_DELAY = 0.1

# ARRUMAR AQUI PARA COLOCAR OS PAISES inveitei da minha cabeca kk
POSSIVEIS_RESPOSTAS = ["Australia", "EUA", "Japao", "Africa do Sul", "Argentina", "Russia", "Australia", "Franca"]

# ARRUMAR OS PINOS DIO COM 
DIO_START = 10  
DIO_RESET = 11
DIO_TIMEOUT = 12 
DIO_ACERTOU = 13 
DIO_ERRO = 14 

class AnalogGameReader:
    def __init__(self):
        self.device_name = DEVICE_NAME
        self.jogo_id = self.get_next_game_id()
        self.inicializar_csvs()
        self.read_game_results()

    def get_next_game_id(self):
        if os.path.exists(CSV_PONTUACOES):
            df = pd.read_csv(CSV_PONTUACOES)
            if not df.empty:
                return df["jogo_id"].max() + 1
        return 1

    def inicializar_csvs(self):
        if not os.path.exists(CSV_RESULTADOS):
            df = pd.DataFrame(columns=["jogo_id", "pais", "resultado"])
            df.to_csv(CSV_RESULTADOS, index=False)

        if not os.path.exists(CSV_PONTUACOES):
            df = pd.DataFrame(columns=["jogo_id", "pontuacao_final", "tempo_total"])
            df.to_csv(CSV_PONTUACOES, index=False)

    def read_game_results(self):
        device_data = device.open()
        device_data.name = self.device_name

        supplies_data = supplies.data()
        supplies_data.master_state = True
        supplies_data.state = True
        supplies_data.voltage = 3.3
        supplies.switch(device_data, supplies_data)

        for index in range(16):
            static.set_mode(device_data, index, False)

        try:
            while True: 
                while not static.get_state(device_data, DIO_START): 
                    sleep(SLEEP_DELAY) # espera dar o start pra comecar 

                print("Jogo iniciado")
                # quando inicia um novo jogo reseta as variaveis
                index_pergunta = 0
                pontuacao = 0
                tempo_total = 0
                tempo_inicio = None

                while index_pergunta < len(POSSIVEIS_RESPOSTAS):
                    conta_tempo = static.get_state(device_data, DIO_TIMEOUT) 
                    acertou = static.get_state(device_data, DIO_ACERTOU) 
                    errou = static.get_state(device_data, DIO_ERRO) 
                    reset = static.get_state(device_data, DIO_RESET) 

                    if reset: # adicionei aqui para se der o botao do reset 
                        print("Jogo resetado")
                        break  
                    if conta_tempo:
                        if tempo_inicio is None:
                            tempo_inicio = time()  
                    else:
                        if tempo_inicio is not None:
                            tempo_total += time() - tempo_inicio
                            tempo_inicio = None

                    if acertou or errou:
                        resultado = "Acerto" if acertou else "Erro"
                        if acertou:
                            pontuacao += 1

                        df_resultados = pd.read_csv(CSV_RESULTADOS)
                        novo_resultado = pd.DataFrame([{ 
                            "jogo_id": self.jogo_id, 
                            "pais": POSSIVEIS_RESPOSTAS[index_pergunta], 
                            "resultado": resultado
                        }])
                        df_resultados = pd.concat([df_resultados, novo_resultado], ignore_index=True)
                        df_resultados.to_csv(CSV_RESULTADOS, index=False)

                        index_pergunta += 1

                    sleep(SLEEP_DELAY)

              # salvar pontuacao e tempo de jogada 
                df_pontuacoes = pd.read_csv(CSV_PONTUACOES)
                df_pontuacoes = pd.concat([df_pontuacoes, pd.DataFrame([{ 
                    "jogo_id": self.jogo_id, 
                    "pontuacao_final": pontuacao,
                    "tempo_total": round(tempo_total, 3)
                }])], ignore_index=True)
                df_pontuacoes.to_csv(CSV_PONTUACOES, index=False)

                self.jogo_id += 1  # incrementa o id do jogo e finaliza

        except KeyboardInterrupt:
            print("Interrompido pelo usuário.")
        finally:
            print("Encerrando...")
            static.close(device_data)
            supplies_data.master_state = False
            supplies.switch(device_data, supplies_data)
            supplies.close(device_data)
            device.close(device_data)

if __name__ == "__main__":
    AnalogGameReader()
