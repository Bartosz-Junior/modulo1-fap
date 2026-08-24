# Projeto 2: Análise e Gestão de Banco de Dados - Escola Tech

Este documento detalha o processo de criação, manutenção e análise do banco de dados relacional voltado para a gestão escolar (Escola Tech), implementado no arquivo `SQLite.sql`.

---

## 1. O que foi feito
Foi desenvolvido um script SQL estruturado para simular a rotina de um Analista de Banco de Dados. As operações englobam desde a criação da infraestrutura de tabelas (DDL) e inserção em lote de dados (DML), até a higienização do banco (remoção de duplicidades) e geração de relatórios gerenciais e métricas de desempenho acadêmico.

## 2. O que foi analisado
A análise focou nos dados cadastrais e acadêmicos dos alunos, além da grade de disciplinas. O fluxo de trabalho (estruturado em Ordens de Serviço - OS) contemplou:
- Validação e importação inicial dos dados (OS-002 e OS-003).
- Correção de inconsistências cadastrais, como notas, turmas e idades incorretas (OS-004).
- Inserção de novos registros no sistema (OS-005).
- Limpeza do banco de dados para garantir integridade e unicidade dos registros (OS-006).
- Evolução da estrutura de dados com a adição de novos campos às tabelas (OS-007).
- Extração de relatórios consolidados e classificação dos alunos (OS-008).

## 3. Ferramentas Utilizadas na Análise
* **SQLite / SQL**: Linguagem de Consulta Estruturada utilizada para todas as operações transacionais, de definição e de manipulação de dados. A escolha permitiu que as rotinas de relatórios e limpezas fossem executadas de forma relacional, estruturada e leve.

---

## 4. Filtros Aplicados e Motivação

Durante a manipulação e extração de dados, foram aplicados filtros específicos (cláusulas `WHERE` e `HAVING`) para direcionar a ação do banco:

* **Filtro Nominal (`WHERE nome = '...'`)**: Utilizado nas etapas de correção cadastral (ex: `'Diego Alves'`, `'Felipe Melo'`, `'Ana Souza'`). 
  * *Por que usar:* Garante que os comandos de atualização (`UPDATE`) e verificação (`SELECT`) afetem ou retornem única e exclusivamente o registro do aluno alvo específico, prevenindo atualizações incorretas ou em massa.
* **Filtro de Agrupamento (`HAVING COUNT(*) > 1`)**: Utilizado na etapa de limpeza de banco de dados para identificar disciplinas repetidas.
  * *Por que usar:* A cláusula `WHERE` convencional não processa funções de agregação antes do agrupamento. O `HAVING` é essencial neste caso porque aplica a condição apenas aos grupos (disciplinas) que possuem mais de um registro após a consolidação pelo `GROUP BY`.
* **Filtro de Exclusão com Subquery (`WHERE id NOT IN (...)`)**: Utilizado no processo de deleção de registros duplicados.
  * *Por que usar:* Permitiu excluir o excesso de dados mantendo uma referência segura, poupando os IDs que retornaram da consulta interna (garantindo que o registro mais antigo de cada disciplina ficasse salvo).

---

## 5. Fórmulas e Funções Utilizadas

Para a geração dos relatórios analíticos (OS-008) e manutenções, foram aplicadas as seguintes funções intrínsecas:

* **`COUNT(*)` (Contagem Total)**:
  * *Por que usar:* Utilizada para retornar o volume absoluto de ocorrências, respondendo perguntas como o total geral de alunos matriculados e, em conjunto com o `GROUP BY`, revelando a quantidade exata de alunos em cada turma para identificar a "Maior turma".
* **`AVG(nota)` (Média)**:
  * *Por que usar:* Calcula a média aritmética de todas as notas dos alunos, definindo o parâmetro geral de desempenho da instituição sem a necessidade de somar e dividir os valores manualmente.
* **`MAX(nota)` e `MIN(nota)` (Máximo e Mínimo)**:
  * *Por que usar:* Funções essenciais para mapear os extremos e localizar rapidamente os pontos de destaque. Usadas em relatórios para encontrar diretamente a melhor e a pior nota, trazendo eficiência à auditoria de performance.
* **`MIN(id)`**:
  * *Por que usar:* Aplicado dentro da lógica de deduplicação para capturar de forma inteligente o ID mais antigo (primeiro a ser inserido) de um agrupamento de disciplinas.
* **Fluxo Condicional (`CASE WHEN ... THEN ... END`)**:
  * *Por que usar:* Atua como uma fórmula condicional direta no banco de dados. Foi vital para gerar uma coluna virtual de `situacao`, categorizando automaticamente cada aluno como 'Reprovado', 'Recuperação' ou 'Aprovado' com base na nota. O uso dessa estrutura cria análises qualitativas imediatas, entregando a regra de negócio resolvida na própria extração SQL.
