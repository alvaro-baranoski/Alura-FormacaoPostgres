-- Triggers
CREATE TABLE log_instrutores (
	id SERIAL PRIMARY KEY,
	log VARCHAR(255),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP FUNCTION cria_instrutor()
CREATE OR REPLACE FUNCTION cria_instrutor () RETURNS TRIGGER AS $$
	DECLARE
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		instrutores_total INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL (5, 2);
		cursor_salarios refcursor;
	BEGIN
		
		SELECT AVG(instrutor.salario) FROM instrutor WHERE id <> NEW.id INTO media_salarial;
		
		IF NEW.salario > media_salarial THEN
			INSERT INTO log_instrutores (log) VALUES (NEW.nome || 'Recebe acima da média');
		END IF;
		
		SELECT instrutores_internos(NEW.id) INTO cursor_salarios;
		LOOP
			FETCH cursor_salarios INTO salario;
			EXIT WHEN NOT FOUND;
			instrutores_total := instrutores_total + 1;
			
			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		
		percentual = instrutores_recebem_menos::DECIMAL / instrutores_total::DECIMAL * 100;
		ASSERT percentual < 100::DECIMAL, 'Erro em regra de negócio!';
		
		INSERT INTO log_instrutores (log)
			VALUES (NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

DROP TRIGGER cria_log_instrutores ON instrutor;
CREATE TRIGGER cria_log_instrutores BEFORE INSERT ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();

SELECT * FROM instrutor;
SELECT * FROM log_instrutores;
SELECT cria_instrutor('Cristiane Paz', 2000);
SELECT cria_instrutor('Cristiane Outra', 400);

INSERT INTO instrutor (nome, salario) VALUES ('Daniela Gomes', 10000);

-- Cursores
CREATE OR REPLACE FUNCTION instrutores_internos(id_instrutor INTEGER) RETURNS refcursor AS $$
	DECLARE
		cursor_salario refcursor;
	BEGIN
		-- Very big query
		OPEN cursor_salario FOR SELECT instrutor.salario 
			FROM instrutor WHERE id <> id_instrutor AND salario > 0;
			
		RETURN cursor_salario;
	END;
$$ LANGUAGE plpgsql;