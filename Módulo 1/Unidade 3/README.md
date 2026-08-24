# Projeto 3: Data Analytics com Dados da PRF

Este documento detalha o escopo, a metodologia e as técnicas de manipulação e análise de dados aplicadas no arquivo `fap scripts finalizado.sql`. O foco do script foi transformar dados brutos de acidentes de trânsito da Polícia Rodoviária Federal (PRF) em métricas analíticas complexas e estruturadas.

---

## 1. O que foi feito
Foi construída uma esteira completa de Data Analytics via script SQL. O processo iniciou-se com a validação da integridade da base e mapeamento estrutural (`information_schema`). A partir da base bruta, foi criada uma tabela virtual (View) de fundação contendo indicadores binários. Na sequência, foram desenvolvidas dezenas de consultas analíticas (agrupamentos bivariados e multivariados) para investigar o comportamento dos acidentes em relação a geografia, temporalidade, condições climáticas e tipos de pista. Por fim, o processo culminou na geração do indicador estatístico "Lift" e na consolidação de Views projetadas para consumo direto em Dashboards de Business Intelligence.

## 2. O que foi analisado
A análise focou em extrair estatísticas de letalidade e frequência de ocorrências na malha rodoviária. As principais dimensões investigadas foram:
- **Métricas Globais:** Total absoluto de acidentes, de óbitos e a Taxa de Letalidade geral.
- **Análise Geográfica:** Ranqueamento de letalidade por Unidades da Federação (UF) e o mapeamento das 30 rodovias (BRs) mais críticas.
- **Série Temporal:** Evolução do volume de acidentes segregado por ano e mês.
- **Fatores Causais e Contextuais:** Cruzamento da taxa de acidentes fatais com variáveis operacionais: Tipo de Acidente, Causa do Acidente, Fase do Dia, Condição Meteorológica e Tipo de Pista.
- **Análise Multivariada:** Avaliação da combinação de Tipo de Pista com Fase do Dia e sua representatividade perante o total geral.
- **Efeito *Lift*:** Comparação estatística entre a taxa de letalidade de um tipo específico de acidente contra a média geral nacional, demonstrando o peso de risco daquele evento.

## 3. Ferramentas Utilizadas na Análise
* **Linguagem SQL Aplicada (Dialeto Analítico):** O ambiente (como o SQLiteOnline utilizado com sintaxe expandida) foi aproveitado ao máximo como motor analítico de processamento de grandes volumes, dispensando a necessidade de transferir os dados para planilhas. Foram aplicados conceitos de DQL (Consultas), DDL (Criação de Views), CTEs (Expressões de Tabela Comuns) e Funções de Janela (*Window Functions*).

---

## 4. Filtros Aplicados e Motivação

O direcionamento das análises exigiu o uso de filtros precisos para manter a significância estatística:

* **Filtro de Relevância Estatística (`HAVING COUNT(*) >= 100` e `>= 30`)**:
  * *Por que usar:* Em análises de taxa (como a de letalidade por UF ou BR), grupos com pouquíssimas amostras podem distorcer os dados. (Ex: um estado com 1 acidente e 1 morte teria 100% de letalidade). O `HAVING` isolou apenas as regiões com um volume robusto de ocorrências, garantindo que o ranqueamento percentual apresentasse risco real, e não anomalias matemáticas.
* **Filtro Condicional Integrado (`FILTER (WHERE ...)`)**:
  * *Por que usar:* Permite aplicar uma condição dentro de uma função agregadora na mesma consulta. O `COUNT(*) FILTER(WHERE acidente_fatal = 1)` contabilizou os eventos letais simultaneamente ao `COUNT` total, reduzindo drasticamente o custo de processamento por evitar sub-consultas (subqueries).
* **Filtro de Limite e Paginação (`LIMIT 10`, `LIMIT 30`, `LIMIT 100`)**:
  * *Por que usar:* Utilizado para exibir recortes "Top N", otimizando a leitura dos resultados e focando a análise nos maiores ofensores (ex: top 30 BRs com mais mortes).
* **Filtro de Metadados (`WHERE table_name = 'dados_prf'`)**:
  * *Por que usar:* Empregada para buscar a tipagem dos dados no dicionário do banco (`information_schema`), isolando a resposta estritamente à tabela de interesse.

---

## 5. Fórmulas e Funções Utilizadas

As funções aplicadas permitiram a construção de indicadores avançados, desde bandeiras booleanas até estatísticas de mercado (*Market Share/Coverage*):

* **Função Lógica (`CASE WHEN ... THEN ... ELSE ... END`)**:
  * *Por que usar:* Atuou na conversão de um dado contínuo/inteiro (`mortos`) para uma *Flag* Booleana (`acidente_fatal` = 1 ou 0). Centralizar essa lógica em uma View base facilitou todo o restante do projeto, transformando cálculos complexos de ocorrências fatais em simples somatórias (`SUM`).
* **Agregações (`SUM` e `COUNT`)**:
  * *Por que usar:* Utilizadas em conjunto com os agrupamentos (`GROUP BY`) para obter volumes absolutos. Como a coluna *fatal* era composta de 1 e 0, a função `SUM()` resultou exatamente na quantidade de acidentes fatais sem necessitar de lógicas condicionais complexas adicionais.
* **Funções de Extração e *Casting* (`EXTRACT`, `::DATE`, `::NUMERIC`)**:
  * *Por que usar:* O `EXTRACT(YEAR/MONTH)` possibilitou "fatiar" uma data bruta e empilhar a série temporal. Já a conversão `::NUMERIC` (Casting) antes das divisões forçou o banco de dados a realizar divisões com casas decimais, evitando que o SQL arredondasse os cálculos percentuais para zero (comportamento padrão na divisão de dois inteiros).
* **Arredondamento (`ROUND(..., 2)`)**:
  * *Por que usar:* Parametriza a exibição dos indicadores percentuais (como taxas de letalidade e coberturas) para duas casas decimais, essencial para uso em relatórios executivos.
* **Função de Janela / *Window Function* (`OVER()`)**:
  * *Por que usar:* O comando `SUM(COUNT(*)) OVER()` foi crucial na análise de cobertura (Query 15). Ele totalizou todas as ocorrências de todos os grupos simultaneamente, servindo como o denominador mestre. Isso viabilizou o cálculo da representatividade de um agrupamento frente à base integral, sem quebrar o escopo analítico.
* **CTEs / Expressão de Tabela Comum (`WITH ... AS (...)`)**:
  * *Por que usar:* Usada para estruturar o cálculo do "Efeito Lift" em múltiplas etapas. A CTE primeiro computou de forma limpa as taxas locais contra a média geral global, criando uma tabela na memória. A *query* principal pôde, então, apenas ler esses indicadores recém-processados para calcular a razão entre eles, mantendo a arquitetura de código extremamente limpa, legível e otimizada.
