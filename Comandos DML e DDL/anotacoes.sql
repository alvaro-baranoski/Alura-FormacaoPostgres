CREATE SCHEMA academico;

CREATE TABLE IF NOT EXISTS academico.aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS academico.categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS academico.curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES academico.categoria(id)
);

CREATE TABLE IF NOT EXISTS academico.aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES academico.aluno(id),
	curso_id INTEGER NOT NULL REFERENCES academico.curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

CREATE TEMPORARY TABLE a (
	coluna VARCHAR(255) NOT NULL CHECK(coluna <> '')
);

ALTER TABLE a RENAME TO teste;
SELECT * FROM teste;

ALTER TABLE teste RENAME coluna TO obs;
SELECT * FROM teste;

-- Inclusão de dados
CREATE TEMPORARY TABLE cursos_programacao (
	id_curso INTEGER PRIMARY KEY,
	nome_curso VARCHAR(255) NOT NULL
);

INSERT INTO cursos_programacao
SELECT academico.curso.id, academico.curso.nome
FROM academico.curso
WHERE categoria_id = 2;

SELECT * FROM cursos_programacao;
