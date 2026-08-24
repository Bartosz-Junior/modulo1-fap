<div align="center">

# FAP · Módulo 1 — Análise de Dados

### Um pipeline completo de **Análise de Dados**: Excel → SQL → Analytics → Python

[![GitHub last commit](https://img.shields.io/github/last-commit/Bartosz-Junior/modulo1-fap?color=4F46E5&style=for-the-badge)](https://github.com/Bartosz-Junior/modulo1-fap)
[![GitHub repo size](https://img.shields.io/github/repo-size/Bartosz-Junior/modulo1-fap?color=EC4899&style=for-the-badge)](https://github.com/Bartosz-Junior/modulo1-fap)
[![Licença](https://img.shields.io/badge/licen%C3%A7a-MIT-22D3EE?style=for-the-badge)]()
[![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/pt-br/microsoft-365/excel)
[![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)]()
[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)](https://jupyter.org/)

---

</div>

## <span style="color:#4F46E5">✦ Sobre o projeto</span>

Repositório com os **projetos práticos do Módulo 1 do curso de Análise de Dados (FAP)**, desenvolvidos por **Edvaldo Cosme dos Santos Junior**. Cada unidade cobre uma etapa do **ciclo de vida do dado**, aplicada em um contexto real:

| Unidade | Foco | Ferramenta | Projeto |
|---------|------|------------|---------|
| <span style="color:#22D3EE">**Unidade 1**</span> | Análise e visualização em planilhas | **Excel** | Dados preliminares de acidentes da PRF |
| <span style="color:#A78BFA">**Unidade 2**</span> | Modelagem e manipulação de banco relacional | **SQLite** | Cadastro e relatórios da *Escola Tech* |
| <span style="color:#EC4899">**Unidade 3**</span> | Business Intelligence e análise de dados abertos | **SQL + SQLite** | Acidentes da PRF em **2025** (Data Analytics) |
| <span style="color:#F59E0B">**Unidade 4**</span> | Preparação de dados e engenharia de variáveis | **Python + Pandas** | Base modelável para Machine Learning (CRISP-DM) |

> 💡 **A jornada:** dados brutos em Excel → modelagem SQL → insights analíticos → bases limpas e prontas para modelagem. Exatamente a trilha que um analista percorre no dia a dia.

---

## <span style="color:#22D3EE">📊 Unidade 1 — Excel (PRF)</span>

Primeiro contato com a base de **acidentes de trânsito da Polícia Rodoviária Federal** (PRF), explorada em planilhas:

- Manipulação de dados em <span style="color:#217346"><b>Excel</b></span> com tabelas e dados abertos da PRF;
- Preparação dos arquivos utilizados nas unidades seguintes (`dados prf previa.xlsx` e `modulo_02_excel_prf`).

| Arquivo | Descrição |
|---------|-----------|
| `dados prf previa.xlsx` | Base preliminar dos acidentes para análise exploratória |
| `modulo_02_excel_prf_*.xlsx` | Projeto do Módulo Excel sobre a base da PRF |

---

## <span style="color:#A78BFA">🗄️ Unidade 2 — SQLite (Escola Tech)</span>

Projeto que simula o papel de **Analista de Banco de Dados** de uma escola técnica. Utilizando **SQLite**, o script `SQLite.sql` executa:

- ✅ Criação das tabelas `alunos` e `disciplinas` via `CREATE TABLE`;
- ✅ Inserção de massas de dados com `INSERT`;
- ✅ **Correção de dados cadastrais** com `UPDATE` (contestação e validação após cada alteração);
- ✅ **Limpeza de dados** com remoção de duplicidades (`GROUP BY` + `HAVING COUNT(*)>1` + `DELETE`);
- ✅ Evolução do schema com `ALTER TABLE` (colunas `cidade` e `laboratorio`);
- ✅ **Relatórios gerais**: total de alunos, média geral, maior/menor nota, maior turma e ranking de desempenho;
- ✅ **Classificação dos alunos** com `CASE WHEN` (*Aprovado / Recuperação / Reprovado*).

---

## <span style="color:#EC4899">📈 Unidade 3 — SQL Analytics (Acidentes PRF 2025)</span>

Projeto de **Data Analytics com Dados Abertos** — análise da base de **~72 mil acidentes registrados pela PRF em 2025**. O script `fap scripts finalizado.sql` é uma verdadeira aula de **SQL analítico**:

| # | Análise | Técnica utilizada |
|---|---------|-------------------|
| 1–3 | Integridade e estrutura da base | `SELECT`, `information_schema`, `COUNT` |
| 5 | Criação do *alvo* `acidente_fatal (mortos ≥ 1)` | `CREATE VIEW` + `CASE WHEN` |
| 6 | Métricas gerais e taxa de letalidade | `FILTER` + agregações |
| 7 | Fatalidade por **UF** (top por letalidade) | `GROUP BY` + `HAVING` |
| 8 | Ranking das **30 BRs mais letais** | `ORDER BY` + `LIMIT` |
| 9 | Evolução temporal dos acidentes | `EXTRACT(YEAR/MONTH)` |
| 10–14 | Fatalidade por **tipo de acidente, causa, fase do dia, clima e pista** | Análise bivariada |
| 15 | **Cruzamento pista × fase do dia** | Análise combinatória + cobertura |
| 16 | **Efeito LIFT** (letalidade do tipo ÷ letalidade geral) | CTE + `OVER()` |
| 17–18 | **Views** para dashboard | `vw_indicadores_mensais`, `vw_indicadores_uf_br` |

### 🔍 Principais insights
- ⌊ **Fase do dia é o fator mais perigoso:** `Plena Noite` tem **~2× mais letalidade** que `Pleno dia` (10.18% vs 5.07%) e o `Amanhecer` atinge **11.20%**;
- ⌋ **Pistas simples** concentram o maior risco: letalidade de **9.86%** vs 4.88% em pistas duplas;
- ⌋ **Efeito LIFT:** *Atropelamento de Pedestre* (**4.11×**) e *Colisão Frontal* (**4.10×**) são os tipos mais letais em relação à média geral (7.18%);
- ⌋ **Ranking federal:** BR-101 (760 mortos) e BR-116 (708 mortos) lideram em mortes absolutas;
- ⌋ **Estados com maior fatalidade:** MA (22.27%), PA (20.05%) e RR (19.72%);
- ⌋ **Dezembro** é o mês com mais acidentes do ano (**6.788 registros**).

Todos os resultados foram exportados em **CSV** nas pastas `resultados/` e `Views com resultados consolidados/`.

---

## <span style="color:#F59E0B">🐍 Unidade 4 — Python: Preparação de Dados (CRISP-DM)</span>

Fechamento do módulo com um notebook completo em **Python/Pandas** (`modulo4_preparacao_dados.ipynb`), executando as **41 etapas** da fase de **Preparação dos Dados** do ciclo CRISP-DM:

- 📦 **Ambiente**: criação automática de pastas (`dados_brutos`, `dados_tratados`, `logs`, etc.) e leitura com *fallback de encoding*;
- 🔍 **Diagnóstico de qualidade**: tipos de dados, valores ausentes, duplicidades e cardinalidade;
- 🛠️ **Transformações e variáveis derivadas**: conversão numérica, datas, turno, faixa horária, padronização de textos e tratamento de nulos;
- 🎯 **Variável-alvo** `acidente_fatal` (`1` quando `mortos ≥ 1`) com validação lógica;
- 🧼 **Anti *data leakage***: a base modelável **exclui** `mortos`, `feridos`, `total_vitimas` e `indice_gravidade`;
- 📦 **Entregáveis**:
  - `base_analitica_prf_2025.csv` → EDA e Power BI;
  - `base_modelavel_prf_2025.csv` → modelagem preditiva;
  - `dicionario_variaveis_modulo4.csv` → dicionário de variáveis;
  - `logs/decisoes_tratamento_modulo4.md` → documentação das decisões.

---

## <span style="color:#10B981">📁 Estrutura do repositório</span>

```
FAP/
├── Módulo 1/
│   ├── Unidade 1/                  # Excel — base PRF preliminar
│   │   ├── README.md               # Detalhamento da análise e fórmulas do Excel
│   │   ├── dados prf previa.xlsx
│   │   └── modulo_02_excel_prf_Edvaldo_Cosme_01.xlsx
│   ├── Unidade 2/                  # SQLite — Escola Tech
│   │   ├── README.md               # Detalhamento da estrutura SQL, filtros e operações
│   │   └── SQLite.sql
│   ├── Unidade 3/                  # SQL Analytics — Acidentes PRF 2025
│   │   ├── README.md               # Detalhamento analítico e métricas avançadas
│   │   ├── fap scripts finalizado.sql
│   │   ├── resultados/             # CSVs com os insights gerados
│   │   └── Views com resultados consolidados/
│   └── Unidade 4/                  # Python — Preparação de dados
│       ├── README.md               # Detalhamento da engenharia de features e CRISP-DM
│       ├── Modulo4_Python_Preparacao_Dados-20260812T181908Z-1-001.zip
│       └── extracted/Modulo4_Python_Preparacao_Dados/  # notebook + bases tratadas
└── README.md
```

---

## <span style="color:#22D3EE">🚀 Como executar</span>

<details>
<summary><b>Unidade 2 e 3 — SQL/SQLite</b></summary>

1. Abra o arquivo `.sql` em qualquer cliente SQLite (ex.: [SQLite Online](https://sqliteonline.com/), DB Browser ou VS Code);
2. Na **Unidade 3**, importe previamente a base `dados_prf` (CSV de acidentes da PRF 2025);
3. Execute os scripts em ordem.
</details>

<details>
<summary><b>Unidade 4 — Python</b></summary>

```bash
# 1. Instale as dependências
pip install pandas numpy matplotlib seaborn

# 2. Abra o notebook
jupyter notebook modulo4_preparacao_dados.ipynb
```

> Coloque o CSV da PRF na mesma pasta do notebook. Ele é detectado automaticamente e copiado para `dados_brutos/`.
</details>

---

## <span style="color:#4F46E5">🎨 Paleta de cores do projeto</span>

| Cor | Hex | Uso no curso |
|-----|-----|--------------|
| <span style="color:#4F46E5">Indigo</span> | `#4F46E5` | Títulos e identidade do curso |
| <span style="color:#22D3EE">Ciano</span> | `#22D3EE` | Análise exploratória e ações |
| <span style="color:#A78BFA">Violeta</span> | `#A78BFA` | Banco de dados e SQL |
| <span style="color:#EC4899">Rosa</span> | `#EC4899` | Business Intelligence e insights |
| <span style="color:#F59E0B">Âmbar</span> | `#F59E0B` | Preparação e Python |
| <span style="color:#10B981">Esmeralda</span> | `#10B981` | Documentação e entregáveis |

---

<div align="center">

## <span style="color:#EC4899">💜</span> Conecte-se

Feito com <span style="color:#EC4899">❤</span> por **Edvaldo Cosme dos Santos Junior** durante o curso **FAP — Análise de Dados**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)]()
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Bartosz-Junior)

*📚 Conteúdo educacional — desenvolvimento contínuo ao longo do curso.*

</div>