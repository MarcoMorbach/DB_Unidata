-- ============================================================
--  06_transacoes.sql — UniData: Controle de Transações (ACID)
--  Banco de Dados II — Projeto Final
--  Pré-requisito: executar 01_ddl.sql, 02_dml.sql, 04_trigger.sql
-- ============================================================
--
--  Propriedades ACID demonstradas:
--  • Atomicidade  — tudo ou nada: se algo falha, nada é salvo
--  • Consistência — constraints e triggers são respeitados durante a tx
--  • Isolamento   — outra sessão não enxerga dados antes do COMMIT
--  • Durabilidade — após COMMIT os dados persistem mesmo após falha
-- ============================================================


-- ============================================================
-- CENÁRIO 1 — Matrícula com verificação de capacidade
--
--   Parte A → há vaga   → COMMIT   (matrícula confirmada)
--   Parte B → sem vaga  → ROLLBACK (matrícula cancelada)
-- ============================================================

-- Stored Procedure que encapsula a lógica condicional:
-- executa COMMIT se houver vaga ou ROLLBACK se a turma estiver lotada.
DROP PROCEDURE IF EXISTS sp_matricular_com_verificacao;

DELIMITER $$

CREATE PROCEDURE sp_matricular_com_verificacao(
    IN p_id_aluno  INT,
    IN p_id_turma  INT
)
BEGIN
    DECLARE v_vagas INT DEFAULT 0;

    -- 1. Calcular vagas disponíveis na turma
    SELECT (t.capacidade - COUNT(m.id_mat))
      INTO v_vagas
      FROM tb_turma t
      LEFT JOIN tb_matricula m ON m.id_turma = t.id_turma
     WHERE t.id_turma = p_id_turma
     GROUP BY t.id_turma, t.capacidade;

    -- 2. Decisão: vaga disponível?
    IF v_vagas > 0 THEN
        -- ── PARTE A: Há vaga → efetua matrícula ──────────────────
        START TRANSACTION;

            INSERT INTO tb_matricula (id_aluno, id_turma, dt_inscricao)
            VALUES (p_id_aluno, p_id_turma, CURDATE());

        COMMIT;   -- DURABILIDADE: dados persistem após confirmação

        SELECT CONCAT(
            'COMMIT realizado. Aluno ', p_id_aluno,
            ' matriculado na turma ', p_id_turma,
            '. Vagas restantes: ', v_vagas - 1
        ) AS resultado;

    ELSE
        -- ── PARTE B: Turma lotada → cancela ──────────────────────
        START TRANSACTION;
            -- Nenhum INSERT foi executado, mas a transação existe
        ROLLBACK;  -- ATOMICIDADE: nada é salvo

        SELECT CONCAT(
            'ROLLBACK efetuado. Turma ', p_id_turma,
            ' está lotada. Matrícula do aluno ', p_id_aluno,
            ' não foi realizada.'
        ) AS resultado;
    END IF;
END$$

DELIMITER ;

-- ----------------------------------------------------------
-- Executando o Cenário 1 — ajuste os IDs conforme seu DML
-- ----------------------------------------------------------

-- Verificar estado inicial das turmas antes de qualquer operação
SELECT
    t.id_turma,
    d.nome              AS disciplina,
    t.capacidade        AS capacidade_maxima,
    COUNT(m.id_mat)     AS matriculados,
    (t.capacidade - COUNT(m.id_mat)) AS vagas_restantes
FROM tb_turma t
JOIN tb_disciplina   d ON d.id_disc  = t.id_disc
LEFT JOIN tb_matricula m ON m.id_turma = t.id_turma
GROUP BY t.id_turma, d.nome, t.capacidade;

-- Parte A: chama a procedure com um aluno que ainda não está na turma
--          Esperado: COMMIT + mensagem de sucesso
CALL sp_matricular_com_verificacao(8, 1);  -- <<< ajuste os IDs conforme seu DML

-- Verificar que a matrícula foi inserida (DURABILIDADE)
SELECT * FROM tb_matricula WHERE id_aluno = 8 AND id_turma = 1;


-- Parte B: tenta matricular em turma já lotada
--          Esperado: ROLLBACK + mensagem de turma lotada
CALL sp_matricular_com_verificacao(9, 3);  -- <<< ajuste para uma turma sem vaga

-- Verificar que NENHUMA matrícula foi inserida (ATOMICIDADE)
SELECT * FROM tb_matricula WHERE id_aluno = 9 AND id_turma = 3;


-- ============================================================
-- CENÁRIO 2 — Lançamento de notas em lote
--
--   Parte A → atualiza + COMMIT  (dados ficam salvos)
--   Parte B → atualiza + ROLLBACK (dados voltam ao estado anterior)
-- ============================================================

-- ──────────────────────────────────────────────────────────────
-- PARTE A: Lançamento confirmado (COMMIT)
-- ──────────────────────────────────────────────────────────────

-- 1. Estado ANTES das atualizações
SELECT id_mat, id_aluno, id_turma, nota, frequencia, situacao
  FROM tb_matricula
 WHERE id_mat IN (1, 2, 3);   -- <<< ajuste os IDs conforme seu DML

START TRANSACTION;   -- início da unidade atômica de trabalho

    -- 2a. Matrícula 1 → frequência ≥ 75 e nota ≥ 6 → trigger: 'Aprovado'
    UPDATE tb_matricula
       SET nota = 8.5, frequencia = 90.0
     WHERE id_mat = 1;

    -- 2b. Matrícula 2 → frequência ≥ 75 mas nota < 6 → trigger: 'Reprovado por Nota'
    UPDATE tb_matricula
       SET nota = 4.0, frequencia = 80.0
     WHERE id_mat = 2;

    -- 2c. Matrícula 3 → frequência < 75 → trigger: 'Reprovado por Falta'
    UPDATE tb_matricula
       SET nota = 7.5, frequencia = 60.0
     WHERE id_mat = 3;

    -- 3. Verificar situações calculadas PELO TRIGGER antes de confirmar
    --    (ISOLAMENTO: apenas esta sessão enxerga os dados agora)
    SELECT id_mat, id_aluno, nota, frequencia, situacao
      FROM tb_matricula
     WHERE id_mat IN (1, 2, 3);

COMMIT;   -- DURABILIDADE: dados persistem permanentemente

-- 4. Verificação pós-COMMIT (outra sessão já veria os mesmos dados)
SELECT id_mat, id_aluno, nota, frequencia, situacao
  FROM tb_matricula
 WHERE id_mat IN (1, 2, 3);


-- ──────────────────────────────────────────────────────────────
-- PARTE B: Demonstração do ROLLBACK — dados voltam ao original
-- ──────────────────────────────────────────────────────────────

-- 1. Estado ANTES das atualizações
SELECT id_mat, id_aluno, id_turma, nota, frequencia, situacao
  FROM tb_matricula
 WHERE id_mat IN (4, 5, 6);   -- <<< ajuste os IDs conforme seu DML

START TRANSACTION;

    -- 2. Atualiza três matrículas com notas e frequências diferentes
    UPDATE tb_matricula SET nota = 9.0, frequencia = 95.0 WHERE id_mat = 4;
    UPDATE tb_matricula SET nota = 3.5, frequencia = 40.0 WHERE id_mat = 5;
    UPDATE tb_matricula SET nota = 7.0, frequencia = 76.0 WHERE id_mat = 6;

    -- 3. Dentro da transação: trigger já calculou a situação
    --    (CONSISTÊNCIA: regras de negócio da RN11 foram aplicadas)
    SELECT id_mat, nota, frequencia, situacao
      FROM tb_matricula
     WHERE id_mat IN (4, 5, 6);

ROLLBACK;   -- ATOMICIDADE: TODOS os UPDATEs acima são desfeitos

-- 4. Verificação pós-ROLLBACK: dados devem estar idênticos ao passo 1
SELECT id_mat, id_aluno, nota, frequencia, situacao
  FROM tb_matricula
 WHERE id_mat IN (4, 5, 6);

-- Os valores de nota, frequencia e situacao devem ser os mesmos
-- que apareceram no SELECT do passo 1 — evidência do ROLLBACK.
