import streamlit as st
import pandas as pd
import plotly.express as px

df_resultados = pd.read_csv('resultados.csv')
df_pontuacao = pd.read_csv('pontuacoes.csv')

df_resultados['tempo_jogada'] = df_resultados['tempo_jogada'].astype(str).str.replace(",", ".").astype(float)

# group by dos paises para calcular o tempo
df_tempo_medio = df_resultados.groupby('pais')['tempo_jogada'].mean().reset_index()
df_tempo_medio.rename(columns={'tempo_jogada': 'tempo_medio_de_jogada'}, inplace=True)

df_pais = df_resultados.groupby(['pais', 'resultado']).size().reset_index(name='contagem')
df_pivot = df_pais.pivot(index='pais', columns='resultado', values='contagem').reset_index()
df_pivot = df_pivot.fillna(0)

# calculo do percentual de acerto por pais
df_pivot['total'] = df_pivot['Acerto'] + df_pivot['Erro']
df_pivot['percentual_acertos'] = df_pivot['Acerto'] / df_pivot['total'] * 100
df_pivot['percentual_erros'] = df_pivot['Erro'] / df_pivot['total'] * 100

df_pivot = df_pivot.merge(df_tempo_medio, on='pais', how='left')

# Criar gráfico de mapa
mapa = px.choropleth(df_pivot,
                     locations='pais',
                     locationmode='country names',
                     color='percentual_acertos',  
                     hover_name='pais',
                     color_continuous_scale='YlGnBu',
                     labels={'percentual_acertos': 'Percentual de Acertos (%)'},
                     title='Mapa de Percentual de Acertos por País')

df_pontuacao['tempo_medio'] = df_pontuacao['tempo_total'].apply(lambda x: x / 8)
def gerar_graficos_por_dificuldade(dificuldade):
    df_dificuldade = df_pontuacao[df_pontuacao['dificuldade'] == dificuldade]
    
    df_score = df_dificuldade['pontuacao_final'].value_counts().reset_index()
    df_score.columns = ['pontuacao_final', 'contagem']
    grafico_score = px.bar(df_score, x='pontuacao_final', y='contagem',
                           labels={'pontuacao_final': 'Pontuação Final', 'contagem': 'Frequência'},
                           title=f'Frequência de Pontuações - Dificuldade {dificuldade}')
    
    df_tempo = df_dificuldade[['jogo_id', 'tempo_medio']]
    grafico_tempo = px.line(df_tempo, x='jogo_id', y='tempo_medio',
                            labels={'jogo_id': 'Jogo', 'tempo_medio': 'Tempo médio por jogada'},
                            title=f'Tempo Médio por Jogada - Dificuldade {dificuldade}')
    return grafico_score, grafico_tempo

grafico_score_0, grafico_tempo_0 = gerar_graficos_por_dificuldade(0)
grafico_score_1, grafico_tempo_1 = gerar_graficos_por_dificuldade(1)


# estatisticas gerais
pontuacao_media = df_pontuacao['pontuacao_final'].mean()
desvio_padrao_pontuacao = df_pontuacao['pontuacao_final'].std()
desvio_padrao_tempo = df_pontuacao['tempo_medio'].std()
pontuacao_max = df_pontuacao['pontuacao_final'].max()
pontuacao_min = df_pontuacao['pontuacao_final'].min()
tempo_max = df_pontuacao['tempo_medio'].max()
tempo_min = df_pontuacao['tempo_medio'].min()

# chamadas dos elementos
st.image("geogenius.png", width=300)
st.title('Geogenius Dashboard')

st.subheader('Estatísticas Gerais')
col1, col2 = st.columns(2)
with col1:
    st.write(f"**Pontuação Média:** {pontuacao_media:.2f}")
    st.write(f"**Desvio Padrão da Pontuação:** {desvio_padrao_pontuacao:.2f}")
    st.write(f"**Pontuação Máxima:** {pontuacao_max}")
    st.write(f"**Pontuação Mínima:** {pontuacao_min}")

with col2:
    st.write(f"**Desvio Padrão do Tempo Médio de Jogada:** {desvio_padrao_tempo:.2f}")
    st.write(f"**Tempo Máximo por Jogada:** {tempo_max:.2f} segundos")
    st.write(f"**Tempo Mínimo por Jogada:** {tempo_min:.2f} segundos")

st.subheader('Gráficos dos Jogos por Dificuldade')
col1, col2 = st.columns(2)
with col1:
    st.plotly_chart(grafico_score_0)
    st.plotly_chart(grafico_score_1)
with col2:
    st.plotly_chart(grafico_tempo_0)
    st.plotly_chart(grafico_tempo_1)

# tempo medio e jogada separados por dificuldade
col1, col2 = st.columns(2)
with col1:
    st.plotly_chart(mapa)
with col2:
    tabela = df_pivot[['pais', 'percentual_acertos', 'tempo_medio_de_jogada']].rename(columns={
        'pais': 'País',
        'percentual_acertos': 'Percentual de Acertos (%)',
        'tempo_medio_de_jogada': 'Tempo médio de jogada'
    })
    st.write(tabela, index=False)

st.subheader('Estatísticas por jogo')

id_jogo_selecionado = st.selectbox("Selecione o jogo", df_resultados['jogo_id'].unique())
df_filtrado = df_resultados[df_resultados['jogo_id'] == id_jogo_selecionado]
# calculo das estatisticas por id de jogo
df_agrupado = df_filtrado.groupby(['pais', 'resultado'])['tempo_jogada'].sum().reset_index()

# grafico de estatistica por jogo
grafico_por_jogo = px.bar(df_agrupado, 
                            x='pais', 
                            y='tempo_jogada', 
                            color='resultado', 
                            title=f"Tempo de Jogo por País - Jogo ID {id_jogo_selecionado}",
                            labels={'pais': 'País', 'tempo_jogada': 'Tempo Total da Jogada (s)', 'resultado': 'Resultado'},
                            color_discrete_map={'Acerto': 'green', 'Erro': 'red'})  

st.plotly_chart(grafico_por_jogo)
