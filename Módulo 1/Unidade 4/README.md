# Projeto 4: Preparação de Dados e Engenharia de Features (CRISP-DM)

Este documento detalha as etapas, lógicas e ferramentas aplicadas no arquivo Python na preparação de dados para análise de acidentes de trânsito. O projeto consistiu no tratamento avançado de dados utilizando a linguagem Python, focado especificamente na fase de *Data Preparation* (Preparação de Dados) da metodologia CRISP-DM.

---

## 1. O que foi feito
A execução partiu da extração de um pacote de projeto estruturado contendo um Jupyter Notebook (`modulo4_preparacao_dados.ipynb`) e a base bruta de acidentes de 2025 (`dados_abertos_prf-datatran2025.csv`). O trabalho englobou:
- Estruturação de diretórios (dados_brutos, dados_tratados, logs, sql, etc).
- Padronização e normalização de cabeçalhos e verificação rigorosa de codificação (*encoding*) do CSV original.
- Engenharia de Recursos (*Feature Engineering*), onde novas métricas foram criadas para enriquecer a base.
- Prevenção ativa de *Data Leakage* (Vazamento de Dados). O notebook gerou propositalmente duas bases distintas:
  - **Base Analítica**: Focada em Análise Exploratória (EDA) e Business Intelligence (Power BI), mantendo todas as métricas originais e derivadas.
  - **Base Modelável**: Estritamente higienizada para Algoritmos de Machine Learning, onde todas as variáveis que representam consequências do acidente (ex: mortos, feridos) foram removidas para evitar que o modelo "preveja o passado".

## 2. O que foi analisado
A análise varreu um *DataFrame* composto inicialmente por mais de 72.000 ocorrências e 30 colunas. O fluxo diagnóstico levantou:
- **Integridade Estrutural**: Checagem proativa das dimensões matriciais e existência das colunas oficiais para evitar quebra do pipeline.
- **Ranking Categórico**: Levantamento das 10 principais Causas e Tipos de acidente antes de consolidar os dados.
- **Consistência de Valores Nulos**: A base passou por um escaneamento completo identificando vazios em colunas categóricas e numéricas para viabilizar as imputações sem perda de dados.
- **Avaliação de Taxas**: Cruzamento exploratório validando matematicamente o comportamento da variável alvo com agrupamentos estatisticamente significativos.

## 3. Ferramentas Utilizadas na Análise
* **Python**: Linguagem âncora de todo o projeto de manipulação de dados (*Data Wrangling*).
* **Pandas**: Biblioteca base de processamento, responsável pela ingestão, vetorização, filtragem, criação de colunas calculadas e exportação otimizada dos dados tabulares.
* **Jupyter Notebook**: Ambiente de desenvolvimento iterativo no qual todo o código, lógicas de tratamento e resultados preliminares foram documentados de forma linear e transparente.
* **Matplotlib / Numpy**: Bibliotecas de suporte para renderização rápida do comportamento visual (distribuição) da variável dependente e cálculo matricial.

---

## 4. Filtros Aplicados e Motivação

Filtros programáticos foram utilizados ao longo do script para blindar a integridade metodológica do projeto de dados:

* **Filtro de Relevância Estatística (`qtd_acidentes >= 30`)**:
  * *Por que usar:* No cálculo exploratório da taxa fatal por categoria (`taxa_fatal_por_categoria`), grupos muito pequenos (ex: 1 acidente, 1 morte = 100% letalidade) geram enviesamento (outliers). O corte para no mínimo 30 registros estabeleceu um patamar de confiança antes das conclusões.
* **Filtro Reverso contra *Data Leakage* (`[c for c in proibidas if c in base.columns]`)**:
  * *Por que usar:* Foi essencial aplicar uma checagem restritiva antes da exportação da base modelável. O filtro identifica instantaneamente se qualquer variável proibida ou posterior ao evento (como `feridos_graves`) passou por engano para a tabela de machine learning, disparando um bloqueio.
* **Filtro Lógico de Imputação de Nulos (`if df[coluna].dtype == "object"`)**:
  * *Por que usar:* Modelos algorítmicos falham ao ler nulos (`NaN`). Este condicional filtra e separa as colunas por tipagem de dado. Onde é texto/string, o nulo é preenchido com a string constante `"IGNORADO"`. Onde é métrica/numérico, o nulo é preenchido com `-1`, entregando um *dataset* livre de quebras na etapa de treino.

---

## 5. Fórmulas e Lógicas Vetorizadas Utilizadas

O *Pandas* foi empregado para aplicar lógicas sem uso de laços repetitivos, maximizando a performance da máquina:

* **Variável Target (`acidente_fatal = 1 se mortos >= 1, senão 0`)**:
  * *Por que usar:* Converte a base de um cenário matemático de regressão (quantos mortos houve?) para um paradigma de classificação binária (o evento foi fatal ou não?). Esta *flag* norteou todas as divisões subsequentes.
* **Métrica Agregadora (`indice_gravidade = mortos*3 + feridos_graves*2 + feridos_leves`)**:
  * *Por que usar:* Variável de negócio (*Business Rule*) criada para a Base Analítica. Ao dar um peso 3 para óbitos, 2 para gravidade extrema e 1 para lesões superficiais, gerou-se uma única pontuação unificada (*score*). Isso possibilita ao analista do Power BI encontrar "pontos críticos" na rodovia que talvez não tenham tantas mortes absolutas, mas possuam uma altíssima gravidade geral cumulativa.
* **Chave Composta (`chave_localidade = uf + "_" + municipio + "_" + br_formatada`)**:
  * *Por que usar:* Fórmula de concatenação textual que atua como uma Chave Primária Artificial (Hash). Sem ela, relatórios geográficos ficam confusos. Com ela, permite-se o rastreio e agrupamento exato de um trecho da rodovia cruzado com seu contexto municipal e estadual.
* **Fórmulas Matemáticas Implícitas (`.sum()` e `.mean()` na variável binária)**:
  * *Por que usar:* Ao invocar a soma sobre a coluna de zeros e uns do `acidente_fatal`, o Python retorna diretamente a Contagem Absoluta de Vítimas Fatais. Igualmente genial foi aplicar a média (`.mean()`); como a variável é binária (0 e 1), a média entrega automaticamente a exata **Taxa de Letalidade Percentual** sem necessitar de lógicas divisionárias manuais.
