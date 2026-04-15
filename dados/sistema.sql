-- ==========================================================
-- 1. CRIAÇÃO DOS BANCOS DE DADOS (SCHEMAS)
-- ==========================================
CREATE DATABASE IF NOT EXISTS seguranca;
CREATE DATABASE IF NOT EXISTS academico;

-- ==========================================================
-- 2. ESTRUTURA DAS TABELAS (DDL)
-- ==========================================================

-- Tabela de Usuários (Schema Seguranca)
CREATE TABLE IF NOT EXISTS seguranca.usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    endereco VARCHAR(255),
    data_ingresso DATE,
    ativo TINYINT(1) DEFAULT 1 -- Governança: Soft Delete
);

-- Tabela de Disciplinas (Schema Academico)
CREATE TABLE IF NOT EXISTS academico.disciplinas (
    cod_servico VARCHAR(20) PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    carga_h INT NOT NULL
);

-- Tabela de Docentes (Schema Academico)
CREATE TABLE IF NOT EXISTS academico.docentes (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nome_docente VARCHAR(100) NOT NULL
);

-- Tabela de Matrículas (Schema Academico)
CREATE TABLE IF NOT EXISTS academico.matriculas (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    cod_disciplina VARCHAR(20),
    id_docente INT,
    ciclo VARCHAR(10) NOT NULL,
    score_final DECIMAL(4,2),
    situacao_ativa TINYINT(1) DEFAULT 1, -- Governança: Soft Delete
    FOREIGN KEY (id_aluno) REFERENCES seguranca.usuarios(id_usuario),
    FOREIGN KEY (cod_disciplina) REFERENCES academico.disciplinas(cod_servico),
    FOREIGN KEY (id_docente) REFERENCES academico.docentes(id_docente)
);

-- ==========================================================
-- 3. POPULAÇÃO DE DADOS (DML)
-- ==========================================================

INSERT INTO seguranca.usuarios (nome, email, endereco, data_ingresso) VALUES 
('Ana Beatriz Lima', 'ana.lima@aluno.edu.br', 'Braganca Paulista/SP', '2026-01-20'),
('Bruno Henrique Souza', 'bruno.souza@aluno.edu.br', 'Atibaia/SP', '2026-01-21'),
('Camila Ferreira', 'camila.ferreira@aluno.edu.br', 'Jundiai/SP', '2026-01-22'),
('Diego Martins', 'diego.martins@aluno.edu.br', 'Campinas/SP', '2026-01-23');

INSERT INTO academico.disciplinas (cod_servico, nome_disciplina, carga_h) VALUES 
('ADS101', 'Banco de Dados', 80),
('ADS102', 'Engenharia de Software', 80),
('ADS103', 'Algoritmos', 60),
('ADS104', 'Redes de Computadores', 60);

INSERT INTO academico.docentes (nome_docente) VALUES 
('Prof. Carlos Mendes'),
('Profa. Juliana Castro'),
('Prof. Renato Alves'),
('Profa. Marina Lopes');

INSERT INTO academico.matriculas (id_aluno, cod_disciplina, id_docente, ciclo, score_final) VALUES 
(1, 'ADS101', 1, '2026/1', 9.1),
(1, 'ADS102', 2, '2026/1', 8.4),
(2, 'ADS101', 1, '2026/1', 7.3),
(3, 'ADS101', 1, '2026/1', 5.9),
(4, 'ADS103', 3, '2026/1', 4.7);

-- ==========================================================
-- 4. CONSULTAS E RELATÓRIOS (DML)
-- ==========================================================

-- A) Listagem de Matriculados (Ciclo 2026/1)
SELECT u.nome AS Nome_Aluno, d.nome_disciplina, m.ciclo
FROM academico.matriculas m
JOIN seguranca.usuarios u ON m.id_aluno = u.id_usuario
JOIN academico.disciplinas d ON m.cod_disciplina = d.cod_servico
WHERE m.ciclo = '2026/1';

-- B) Baixo Desempenho (Média < 6.0)
SELECT d.nome_disciplina, AVG(m.score_final) AS Media_Geral
FROM academico.matriculas m 
JOIN academico.disciplinas d ON m.cod_disciplina = d.cod_servico
GROUP BY d.nome_disciplina
HAVING AVG(m.score_final) < 6.0;

-- C) Alocação de Docentes (LEFT JOIN)
SELECT doc.nome_docente, d.nome_disciplina
FROM academico.docentes doc
LEFT JOIN academico.matriculas m ON doc.id_docente = m.id_docente
LEFT JOIN academico.disciplinas d ON m.cod_disciplina = d.cod_servico;

-- D) Destaque Acadêmico (Maior nota em Banco de Dados)
SELECT u.nome, m.score_final
FROM academico.matriculas m
JOIN seguranca.usuarios u ON m.id_aluno = u.id_usuario
WHERE m.cod_disciplina = 'ADS101' 
AND m.score_final = (SELECT MAX(score_final) FROM academico.matriculas WHERE cod_disciplina = 'ADS101');

-- ==========================================================
-- 5. SEGURANÇA E GOVERNANÇA (DCL)
-- ==========================================================

CREATE ROLE IF NOT EXISTS 'professor_role';
GRANT UPDATE (score_final) ON academico.matriculas TO 'professor_role';

CREATE ROLE IF NOT EXISTS 'coordenador_role';
GRANT ALL PRIVILEGES ON academico.* TO 'coordenador_role';
GRANT ALL PRIVILEGES ON seguranca.* TO 'coordenador_role';