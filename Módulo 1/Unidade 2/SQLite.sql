--Projeto 2
--Analista de Banco de Dados da Escola Tech

--Criando as tabelas de acordo com os arquivos CSV alunos
CREATE TABLE IF NOT EXISTS alunos(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome VARCHAR(100) NOT NULL,
  idade INTEGER,
  turma VARCHAR(100),
  nota REAL
  );
  
--Inserindo alunos do arquivo CSV
INSERT INTO alunos(nome, idade, turma, nota)
VALUES
('Ana Souza', 19, 'Info A', 8.5),
('Bruno Lima', 20, 'Administração A', 7),
('Carla Santos', 18, 'Info A', 9.2),
('Diego Alves', 22, 'Redes A', 6.8),
('Elisa Rocha', 21, 'Administração A', 8.9),
('Felipe Melo', 20, 'Redes A', 5.7),
('Gabriela Costa', 19, 'Info A', 9.7),
('Henrique Silva', 23, 'Redes A', 7.5),
('Igor Martins', 18, 'Info B', 8.1),
('Joana Ferreira', 19, 'Redes A', 7.8),
('Lucas Pereira', 21, 'Administração A', 6.5),
('Mariana Lopes', 20, 'Info A', 9.4),
('Nicolas Gomes', 22, 'Redes A', 3.8),
('Olívia Ramos', 18, 'Info A', 8.3),
('Paulo Mendes', 20, 'Redes A', 7.1),
('Renata Lima', 19, 'Administração A', 9),
('Samuel Barros', 21, 'Info B', 4.9),
('Tatiana Nunes', 22, 'Administração B', 6.2),
('Vinícius Araújo', 20, 'Redes B', 8.8),
('Wesley Cardoso', 19, 'Info B', 5.4),
('Aline Monteiro', 18, 'Administração B', 7.6),
('Beatriz Cavalcanti', 20, 'Info A', 9.1),
('Caio Dantas', 23, 'Redes B', 4.3),
('Daniela Freitas', 21, 'Administração A', 8),
('Eduardo Tavares', 19, 'Info B', 6.9),
('Fernanda Queiroz', 18, 'Redes A', 7.9),
('Gustavo Moura', 22, 'Administração B', 5.8),
('Helena Paiva', 20, 'Info A', 9.6),
('Isabela Castro', 19, 'Redes B', 8.4),
('José Roberto', 24, 'Administração A', 6),
('Karen Albuquerque', 18, 'Info B', 7.3),
('Leandro Farias', 21, 'Redes A', 2.9),
('Mônica Ribeiro', 20, 'Administração B', 8.7),
('Natália Pires', 19, 'Info A', 5.1),
('Otávio Correia', 22, 'Redes B', 7.7),
('Priscila Andrade', 21, 'Administração A', 9.3),
('Rafael Batista', 20, 'Info B', 6.7),
('Sabrina Oliveira', 18, 'Redes A', 8.2),
('Thiago Moreira', 23, 'Administração B', 4.7),
('Vitória Fernandes', 19, 'Info A', 9.8);

 --Criando as tabelas de acordo com os arquivos CSV disciplinas
 --PORQUE NÃO FOI IMPORTADO O CSV? PORQUE GERA UM PROBLEMA COM A COLUNA ID AO ADD NOVOS REGISTROS.
CREATE TABLE IF NOT EXISTS disciplinas(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  disciplina VARCHAR(100) NOT NULL,
  professor VARCHAR(100),
  carga_horaria INTEGER
  );
  
--Inserindo discidisciplinas de acordo com o arquivo CSV
INSERT INTO disciplinas (disciplina, professor, carga_horaria)
VALUES
('Banco de Dados', 'Marcos Lima', 80),
('Programação Web', 'Juliana Alves', 80),
('Redes de Computadores', 'Carlos Souza', 60),
('Lógica de Programação', 'Patrícia Gomes', 80),
('Engenharia de Software', 'Rafael Melo', 60),
('Segurança da Informação', 'André Barros', 60),
('Sistemas Operacionais', 'Luciana Freire', 60),
('Empreendedorismo', 'Renato Vasconcelos', 40),
('Fundamentos de Administração', 'Camila Torres', 60),
('Projeto Integrador', 'Fernanda Oliveira', 100);

--Seleciona a tabela disciplinas para checkin de Importação dos dados(OS-002)
SELECT * from alunos;
SELECT * FROM disciplinas;

--Seleciona a tabela Alunos para checkin de Importação dos dados(OS-003)
SELECT * from alunos;
SELECT nome FROM alunos;
SELECT nota FROM alunos;
SELECT professor from disciplinas;

--Correção de dados cadastrais(OS-004)
SELECT * from alunos WHERE nome = 'Diego Alves';

--Correção do dado Visualizado(OS-004)
UPDATE alunos set turma = 'Info B' WHERE nome = 'Diego Alves';

--Verifica se foi atualizado(OS-004)
SELECT * from alunos WHERE nome = 'Diego Alves';

UPDATE alunos set nota = 7.2 WHERE nome = 'Felipe Melo';

SELECT nome, nota from alunos WHERE nome = 'Felipe Melo';

UPDATE alunos set nota = 9 WHERE nome = 'Ana Souza';

SELECT nome, nota from alunos WHERE nome = 'Ana Souza';

UPDATE alunos set idade = 20 WHERE nome = 'Ana Souza';

SELECT nome, nota, idade from alunos WHERE nome = 'Ana Souza';

--Cadastro de novos alunos(OS-005)

INSERT into alunos (nome, idade, turma, nota)
VALUES 
('Igor Martins', 18, 'Info B', 8.1),
('Joana Ferreira', 19, 'Redes A', 7.8),
('Lucas Pereira', 21, 'Administração A', 6.5),
('Mariana Lopes', 20, 'Info A', 9.4),
('Nicolas Gomes', 22, 'Redes A', 4.8),
('Olívia Ramos', 18, 'Info A', 8.3),
('Paulo Mendes', 20, 'Redes A', 7.1),
('Renata Lima', 19, 'Administração A', 9.0);

SELECT * FROM alunos ORDER BY id ;

--Limpeza de banco de dados (OS-006)
SELECT disciplina, COUNT(*) AS quantidade
FROM disciplinas
GROUP BY disciplina
HAVING COUNT(*) > 1;

DELETE FROM disciplinas
WHERE id NOT IN (
    SELECT MIN(id)
    FROM disciplinas
    GROUP BY disciplina
);

--Adicionando novos campos as tabelas alunos e disciplinas(OS-007)

ALTER TABLE alunos add COLUMN cidade VARCHAR(50);
ALTER TABLE disciplinas add COLUMN laboratorio VARCHAR(10);

--Relatórios gerais(OS-008)
	--Total de alunos
SELECT COUNT(*) AS total_alunos FROM alunos;

	--Média geral
SELECT AVG(nota) AS media_geral FROM alunos;

	--Maior nota geral
SELECT nome, MAX(nota) AS maior_nota from alunos;

	--Menor nota geral
SELECT nome, MIN(nota) AS menor_nota FROM alunos;

	--Maior turma
SELECT turma, COUNT(*) AS total_alunos
FROM alunos
GROUP BY turma
ORDER BY total_alunos DESC
LIMIT 1;

	--Melhores estudantes por ranking de notas maior -- menor
SELECT nome, nota from alunos ORDER by nota DESC;

--Classificcação dos alunos(Considerando a nota de aprovação 6, recuperação entre 5 e 5.9 e menor que 5 reprovado)
SELECT 
    nome,
    nota,
    CASE 
        WHEN nota < 5 THEN 'Reprovado'
        WHEN nota BETWEEN 5 AND 5.9 THEN 'Recuperação'
        ELSE 'Aprovado'
    END AS situacao
FROM alunos
ORDER BY nota DESC;

DROP TABLE alunos;