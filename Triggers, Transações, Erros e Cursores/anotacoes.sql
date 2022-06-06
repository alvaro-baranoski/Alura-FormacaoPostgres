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
	BEGIN
		
		SELECT AVG(instrutor.salario) FROM instrutor WHERE id <> NEW.id INTO media_salarial;
		
		IF NEW.salario > media_salarial THEN
			INSERT INTO log_instrutores (log) VALUES (NEW.nome || 'Recebe acima da média');
		END IF;
		
		FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> NEW.id LOOP
			instrutores_total := instrutores_total + 1;
			
			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		
		percentual = instrutores_recebem_menos::DECIMAL / instrutores_total::DECIMAL * 100;
		
		INSERT INTO log_instrutores (log)
			VALUES (NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cria_log_instrutores AFTER INSERT ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();

SELECT * FROM instrutor;
SELECT * FROM log_instrutores;
SELECT cria_instrutor('Cristiane Paz', 1000);
SELECT cria_instrutor('Cristiane Outra', 400);

INSERT INTO instrutor (nome, salario) VALUES ('Daniela Gomes', 600);