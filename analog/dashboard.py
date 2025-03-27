import streamlit as st
import pandas as pd
import plotly.express as px

df_resultados = pd.read_csv('resultados.csv')
df_pontuacao = pd.read_csv('pontuacoes.csv')

# separar os resultados por pais
df_pais = df_resultados = pd.read_csv('resultados.csv').groupby(['pais', 'resultado']).size().reset_index(name='contagem')
df_pivot = df_pais.pivot(index='pais', columns='resultado', values='contagem').reset_index()
df_pivot = df_pivot.fillna(0)

df_pivot['total'] = df_pivot['Acerto'] + df_pivot['Erro']
df_pivot['percentual_acertos'] = df_pivot['Acerto'] / df_pivot['total'] * 100
df_pivot['percentual_erros'] = df_pivot['Erro'] / df_pivot['total'] * 100

# criar grafico de mapa
mapa = px.choropleth(df_pivot,
                     locations='pais',
                     locationmode='country names',
                     color='percentual_acertos',  
                     hover_name='pais',
                     color_continuous_scale='YlGnBu',
                     labels={'percentual_acertos': 'Percentual de Acertos (%)'},
                     title='Mapa de Percentual de Acertos por País')



# tempo médio por jogada (tempo_total / 8)
df_pontuacao['tempo_medio'] = df_pontuacao['tempo_total'].apply(lambda x: float(x.replace(",", ".")) / 8)
df_pontuacao_contagem = df_pontuacao['pontuacao_final'].value_counts().reset_index()
df_pontuacao_contagem.columns = ['pontuacao_final', 'contagem']

# gráfico de barras com a pontuação 
grafico_score = px.bar(df_pontuacao_contagem, 
                        x='pontuacao_final', 
                        y='contagem', 
                        labels={'pontuacao_final': 'Pontuação Final', 'contagem': 'Frequência'},
                        title='Frequência de pontuações obtidas nos jogos')

grafico_score.update_layout(
    xaxis=dict(
        tickmode='linear', 
        dtick=1        
    )
) 
# Gráfico de linha para o tempo médio por jogada
grafico_tempo = px.line(df_pontuacao, 
                         x='jogo_id', 
                         y='tempo_medio', 
                         labels={'jogo_id': 'Jogo', 'tempo_medio': 'Tempo médio por jogada'},
                         title='Tempo médio por jogada')
grafico_tempo.update_layout(
    xaxis=dict(
        tickmode='linear', 
        dtick=1        
    )
) 

# estatísticas
pontuacao_media = df_pontuacao['pontuacao_final'].mean()
desvio_padrao_pontuacao = df_pontuacao['pontuacao_final'].std()
desvio_padrao_tempo = df_pontuacao['tempo_medio'].std()
pontuacao_max = df_pontuacao['pontuacao_final'].max()
pontuacao_min = df_pontuacao['pontuacao_final'].min()
tempo_max = df_pontuacao['tempo_medio'].max()
tempo_min = df_pontuacao['tempo_medio'].min()



# chamada dos elementos
st.image("geogenius.png", width=300)

st.title('Geogenius Dashboard')

st.subheader('Estatísticas do Jogo')
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

st.subheader('Gráficos do Jogo')
# graficos de score e tempo
col1, col2 = st.columns(2)
with col1:
    st.plotly_chart(grafico_score)
with col2:
    st.plotly_chart(grafico_tempo)

# grafico e tabela dos paises
col1, col2 = st.columns(2)
with col1:
    st.plotly_chart(mapa)
with col2:
    tabela = df_pivot[['pais', 'percentual_acertos']].rename(columns={
        'pais': 'País',
        'percentual_acertos': 'Percentual de Acertos (%)'
    })
    st.write(tabela, index=False)
