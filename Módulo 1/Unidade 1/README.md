# Análise de Dados: Acidentes PRF

Este documento descreve a análise estrutural e metodológica realizada no arquivo `modulo_02_excel_prf_Edvaldo_Cosme_01 (1).xlsx`, referente aos dados de acidentes registrados pela Polícia Rodoviária Federal (PRF).

---

## 1. O que foi feito
Foi feita uma varredura programática e estrutural no arquivo Excel para compreender sua arquitetura, as lógicas de negócios implementadas e como os dados brutos foram transformados em informações e painéis gerenciais (Dashboards). Essa análise mapeou as abas existentes, as fórmulas utilizadas para criação de métricas e os filtros aplicados para a visualização dos dados.

## 2. O que foi analisado
O arquivo é composto por **11 planilhas (abas)**, organizadas de forma lógica e sequencial para um projeto de Data Analytics no Excel:

1. **`tb_acidentes_prf`**: A base de dados bruta com os registros de cada acidente.
2. **`Dicionário Resumido`**: Metadados que explicam o significado de cada coluna da base principal.
3. **`TD_Dia_Da_Semana`, `TD_Tipo_E_Mortos`, `TD_Mortos_Por_BR`, `TD_Causas_Frequentes`, `TD_Fatais_Por_Mes`, `TD_Acidentes_Por_UF`**: Conjunto de Tabelas Dinâmicas (identificadas pelo prefixo TD) criadas para sumarizar e agrupar os dados por diferentes dimensões (Tempo, Localidade e Causa).
4. **`Dashboards`**: Painel visual que consome as Tabelas Dinâmicas para exibição de gráficos e indicadores.
5. **`Síntese Interpretativa`**: Aba dedicada às conclusões, insights e narrativas (storytelling) baseadas nos dados.
6. **`Observações`**: Aba de apoio para análises específicas, cálculos extras e detalhamentos através de fórmulas avançadas.

## 3. Quais ferramentas foram usadas na análise
* **Microsoft Excel**: Ferramenta nativa em que o arquivo foi construído, utilizando recursos como *Tabelas Dinâmicas*, *Gráficos* e *Fórmulas Lógicas e Estatísticas*.

---

## 4. Filtros Identificados e Motivação

Durante a análise, identificou-se a presença de um filtro ativo (`AutoFilter`) na seguinte aba:

* **Aba `TD_Acidentes_Por_UF` (Intervalo `$A$1:$B$30`)**:
  * **O porquê do seu uso**: Em relatórios e tabelas dinâmicas que envolvem unidades federativas (estados), os filtros são aplicados geralmente para realizar **ranqueamentos** (como ordenar os estados do maior para o menor número de acidentes), para **remover valores nulos ou vazios** (estados sem ocorrências ou linhas em branco que sujam o gráfico), ou para **focar em uma região específica** (ex: analisar apenas a região Sul). O intervalo até a linha 30 sugere que acomoda perfeitamente os 27 estados da federação mais cabeçalhos e totais.

---

## 5. Fórmulas Utilizadas e Seus Objetivos

Diversas fórmulas foram implementadas no projeto para tratar os dados e criar novas métricas (indicadores). Abaixo detalhamos cada tipo encontrado e a sua finalidade técnica:

### Na aba `tb_acidentes_prf` (Base de Dados):
* **Fórmula `IF` (Função SE):**
  * *Exemplo*: `=IF(S2>=1,1,0)` (Coluna AE)
  * *Motivo*: Esta fórmula cria uma **Variável Dummy (ou Flag)** chamada `acidente_fatal`. Ela verifica se a coluna S (provavelmente a coluna que contém o número de mortos) é maior ou igual a 1. Se for, retorna `1` (Verdadeiro/Fatal); se não for, retorna `0` (Falso/Não Fatal). Isso facilita imensamente a contagem posterior de acidentes com óbitos sem precisar somar o número total de mortos.
* **Fórmula `COUNTIF` (CONT.SE) e `COUNTA` (CONT.VALORES):**
  * *Exemplo*: `=(COUNTIF(tb_acidentes_prf[acidente_fatal],1)/COUNTA(tb_acidentes_prf[id]))`
  * *Motivo*: Utilizada para calcular a **Taxa de Letalidade Geral**. O `COUNTIF` conta quantos acidentes receberam a flag `1` (fatal) e divide isso pelo `COUNTA`, que conta o número total de registros (ID) na tabela. A fórmula adjacente (`=1-AF2`) calcula a taxa complementar, ou seja, a proporção de acidentes *sem* vítimas fatais.

### Na aba `Observações`:
* **Fórmula `COUNTIFS` (Função CONT.SES):**
  * *Exemplo*: `=COUNTIFS(tb_acidentes_prf[uf],E2,tb_acidentes_prf[acidente_fatal],1)`
  * *Motivo*: A função `COUNTIFS` (com "S" no final) permite fazer contagens considerando **múltiplos critérios simultaneamente**. O analista usou essa fórmula para cruzar as categorias. No exemplo acima, ela está contando "Quantos acidentes aconteceram na UF indicada pela célula E2 **E** que também foram acidentes fatais (flag = 1)". 
  * Essa estrutura foi replicada nas colunas F, I, L, O e R dessa aba para cruzar os *Acidentes Fatais* com as dimensões de *UF, BR (Rodovia), Causa do Acidente, Tipo do Acidente e Condição Meteorológica*. Isso permite análises granulares precisas que às vezes são mais complexas de se personalizar em uma Tabela Dinâmica convencional.
