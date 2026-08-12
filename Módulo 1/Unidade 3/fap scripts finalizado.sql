--Módulo 3 - SQL com SQLite (Adaptado para SQLiteOnline)
--Projeto: Data Analytics com Dados Abertos da PRF
--Base: Acidentes 2025 agrupados por ocorrência
-- Edvaldo Cosme dos Santos Junior

--1 Select na base de dados importada para verificação da integridade dos dados
select * from dados_prf limit 10;

--2 Query para descrever a estrutura da tabela importada
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'dados_prf';

--3 Contar o total de registros e ocorrencias da base
select count(id) as total_registros from dados_prf;

--4 Excluir a view base
DROP VIEW IF EXISTS view_base;

--5 Criar a view base com a flag 'acidente_fatal' (1 para mortos >= 1, senão 0)
CREATE VIEW acidente_fatal AS
SELECT 
    *,
    CASE 
        WHEN mortos >= 1 THEN 1
        ELSE 0
    END AS acidente_fatal 
FROM dados_prf;

SELECT * FROM acidente_fatal;

--6 Calcular métricas gerais: total de acidentes, total de fatais e o % de letalidade
select 
	count(id) as total_acidentes,
	count(*) filter(where acidente_fatal = 1) as total_acidentes_fatais,
	round(
		(count(*) filter (where acidente_fatal = 1)::numeric / count(id)) * 100, 2 
	) as taxa_fatalidade
from acidente_fatal;

--7 Agregar acidentes, mortos e % de fatais por Estado (UF), filtrando os com ao menos 100 casos
SELECT 
    uf,
    COUNT(*) AS total_acidentes_por_uf,
    SUM(mortos) AS total_mortos_por_uf,
    ROUND(
    (SUM(mortos)::NUMERIC / COUNT(*)) * 100, 2 ) AS percentual_fatalidade_por_uf
FROM 
    dados_prf dp 
GROUP BY 
    uf
HAVING 
    COUNT(*) >= 100
ORDER BY 
    percentual_fatalidade_por_uf  desc
LIMIT 100;

--8 Listar as 30 rodovias (BRs) mais letais em número absoluto de mortos
SELECT
	br,
	count(*) as total_acidentes_por_br,
	sum(mortos) as total_mortos_por_br
FROM 
	dados_prf dp 
GROUP BY
	br
HAVING
	count(*) >=30
ORDER BY 
	total_mortos_por_br desc 
LIMIT 30;

--9 Agrupar a evolução temporal dos acidentes por Ano e Mês (extraídos da data)
SELECT 
    EXTRACT(YEAR FROM data_inversa::DATE) AS ano,
    EXTRACT(MONTH FROM data_inversa::DATE) AS mes,
    COUNT(*) AS total_acidentes
FROM 
    dados_prf
GROUP BY 
    EXTRACT(YEAR FROM data_inversa::DATE),
    EXTRACT(MONTH FROM data_inversa::DATE)
ORDER BY 
    ano ASC, 
    mes ASC;

--10 Analisar a relação bivariada entre o Tipo de Acidente e o % de ocorrências fatais
SELECT 
    tipo_acidente,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) * 100, 
        2
    ) AS percentual_fatais
FROM 
    acidente_fatal
GROUP BY 
    tipo_acidente
ORDER BY 
    percentual_fatais DESC;

--11 Analisar as 30 Principais Causas de Acidentes ordenadas pela maior taxa de letalidade
SELECT 
    causa_acidente, -- Substitua pelo nome exato da sua coluna de causa
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    -- Calcula a taxa de letalidade (porcentagem de acidentes fatais)
    ROUND(
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) * 100, 
        2
    ) AS taxa_letalidade
FROM 
    acidente_fatal
GROUP BY 
    causa_acidente
ORDER BY 
    taxa_letalidade DESC
LIMIT 30;

--12 Comparar a gravidade dos acidentes de acordo com a Fase do Dia (noite, pleno dia, etc.)
SELECT 
    fase_dia, -- Substitua pelo nome exato da sua coluna (ex: fase_dia, condicao_luz)
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    -- Calcula a taxa de letalidade por fase do dia
    ROUND(
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) * 100, 
        2
    ) AS taxa_letalidade
FROM 
    acidente_fatal
GROUP BY 
    fase_dia
ORDER BY 
    acidentes_fatais DESC;

--13 Avaliar a influência da Condição Meteorológica no % de acidentes fatais
SELECT 
    condicao_metereologica, -- Substitua pelo nome exato da sua coluna (ex: condicao_metereologica, clima)
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    -- Calcula o percentual de acidentes fatais para cada clima
    ROUND(
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) * 100, 
        2
    ) AS percentual_fatais
FROM 
    acidente_fatal
GROUP BY 
    condicao_metereologica
ORDER BY 
    acidentes_fatais DESC;

--14 Comparar a letalidade do acidente de acordo com o Tipo de Pista (simples, dupla, múltipla)
SELECT 
    tipo_pista, -- Substitua pelo nome exato da sua coluna
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    -- Calcula a taxa de letalidade para cada tipo de pista
    ROUND(
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) * 100, 
        2
    ) AS taxa_letalidade
FROM 
    acidente_fatal
GROUP BY 
    tipo_pista
ORDER BY 
    taxa_letalidade DESC;

--15 Analisar a combinação de dois fatores (Pista + Fase do Dia) e a cobertura em relação ao total
SELECT 
    tipo_pista,
    fase_dia,
    COUNT(*) AS total_combinacao,
    -- Calcula a cobertura (%) em relação ao TOTAL GERAL da base de dados
    ROUND(
        (COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER()) * 100, 
        2
    ) AS percentual_cobertura_total
FROM 
    acidente_fatal
GROUP BY 
    tipo_pista,
    fase_dia
ORDER BY 
    total_combinacao DESC;

--16 Calcular o efeito 'Lift' (razão entre a taxa de letalidade do tipo e a (taxa média geral)
WITH metricas_por_tipo AS (
    SELECT 
        tipo_acidente,
        COUNT(*) AS total_acidentes,
        SUM(acidente_fatal) AS acidentes_fatais,
        -- 1. Taxa de letalidade do tipo específico
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) AS taxa_tipo,
        -- 2. Taxa de letalidade MÉDIA GERAL (de todo o Brasil)
        (SUM(SUM(acidente_fatal)) OVER()::NUMERIC / SUM(COUNT(*)) OVER()) AS taxa_geral
    FROM 
        acidente_fatal
    GROUP BY 
        tipo_acidente
)
SELECT 
    tipo_acidente,
    total_acidentes,
    acidentes_fatais,
    ROUND(taxa_tipo * 100, 2) AS taxa_letalidade_tipo_pct,
    ROUND(taxa_geral * 100, 2) AS taxa_letalidade_geral_pct,
    -- 3. Cálculo do LIFT (Razão entre as duas taxas)
    ROUND((taxa_tipo / taxa_geral), 2) AS efeito_lift
FROM 
    metricas_por_tipo
ORDER BY 
    efeito_lift DESC;

--17 Criar a view 'vw_indicadores_mensais' para facilitar relatórios temporais
CREATE OR REPLACE VIEW vw_indicadores_mensais AS
SELECT 
    -- Extrai o ano e o mês da coluna de texto convertida para data
    EXTRACT(YEAR FROM data_inversa::DATE) AS ano,
    EXTRACT(MONTH FROM data_inversa::DATE) AS mes,
    
    -- Indicadores principais
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS total_acidentes_fatais,
    
    -- Calcula a taxa de letalidade mensal (%)
    ROUND(
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) * 100, 
        2
    ) AS taxa_letalidade_mensal
FROM 
    acidente_fatal
GROUP BY 
    EXTRACT(YEAR FROM data_inversa::DATE),
    EXTRACT(MONTH FROM data_inversa::DATE)
ORDER BY 
    ano ASC, 
    mes ASC;

SELECT * FROM vw_indicadores_mensais;

--18 Criar a view 'vw_indicadores_uf_br' consolidadas por localização para uso em Dashboards.
CREATE OR REPLACE VIEW vw_indicadores_uf_br AS
SELECT 
    uf,
    br,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS total_acidentes_fatais,
    -- Calcula a taxa de letalidade daquela rodovia naquele estado
    ROUND(
        (SUM(acidente_fatal)::NUMERIC / COUNT(*)) * 100, 
        2
    ) AS taxa_letalidade
FROM 
    acidente_fatal
GROUP BY 
    uf,
    br
ORDER BY 
    uf ASC, 
    total_acidentes DESC;

SELECT * FROM vw_indicadores_uf_br;

