/* QUERY 1 */
SELECT
    a.nome AS aluno,
    c.nome AS curso,
    COUNT(m.id_mat) AS total_disciplinas_cursadas
FROM tb_aluno a
	JOIN      tb_curso c ON c.id_curso = a.fk_curso
	LEFT JOIN tb_matricula m ON m.fk_aluno = a.id_aluno
GROUP BY a.id_aluno, a.nome, c.nome
ORDER BY a.nome;


/* QUERY 2 */
SELECT
    p.nome AS professor,
    p.titulacao,
    COUNT(t.id_turma) AS total_turmas_ano_atual
FROM tb_professor p
	JOIN tb_turma t ON t.fk_prof = p.id_prof
	WHERE t.ano = YEAR(CURDATE())
GROUP BY p.id_prof, p.nome, p.titulacao
HAVING COUNT(t.id_turma) > 2
ORDER BY total_turmas_ano_atual DESC;


/* QUERY 3 */
SELECT
    d.nome AS disciplina,
    COUNT(m.id_mat) AS total_matriculas,
    SUM(CASE WHEN m.situacao = 'Aprovado' THEN 1 ELSE 0 END) AS aprovados,
    ROUND(
        SUM(CASE WHEN m.situacao = 'Aprovado' THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(m.id_mat), 0), 2
    ) AS taxa_aprovacao
FROM tb_disciplina d
	JOIN tb_turma t ON t.fk_disc  = d.id_disc
	JOIN tb_matricula m ON m.fk_turma = t.id_turma
GROUP BY d.id_disc, d.nome
ORDER BY taxa_aprovacao DESC;


/* QUERY 4 */
SELECT
    a.nome AS aluno,
    d.nome AS disciplina,
    m.nota AS nota_aluno,
    ROUND(
        (
            SELECT AVG(m2.nota)
            FROM   tb_matricula m2
            JOIN   tb_turma t2 ON t2.id_turma = m2.fk_turma
            WHERE  t2.fk_disc = t.fk_disc
              AND  m2.nota IS NOT NULL
        ), 2
    ) AS media_da_disciplina
FROM tb_matricula  m
	JOIN tb_aluno a ON a.id_aluno = m.fk_aluno
	JOIN tb_turma t ON t.id_turma = m.fk_turma
	JOIN tb_disciplina d ON d.id_disc  = t.fk_disc
WHERE m.nota IS NOT NULL
  AND m.nota > (
          SELECT AVG(m2.nota)
          FROM   tb_matricula m2
          JOIN   tb_turma t2 ON t2.id_turma = m2.fk_turma
          WHERE  t2.fk_disc = t.fk_disc
            AND  m2.nota IS NOT NULL
      )
ORDER BY d.nome, m.nota DESC;


/* QUERY 5 */
SELECT
    d.id_disc,
    d.nome AS disciplina,
    d.creditos
FROM tb_disciplina d
	LEFT JOIN tb_turma     t ON t.fk_disc  = d.id_disc
	LEFT JOIN tb_matricula m ON m.fk_turma = t.id_turma
WHERE m.id_mat IS NULL
GROUP BY d.id_disc, d.nome, d.creditos
ORDER BY d.nome;


/* QUERY 6 */
SELECT
    a.nome AS aluno,
    c.nome AS curso,
    SUM(d.creditos) AS total_creditos_cursados,
    ROUND(
        SUM(m.nota * d.creditos) / NULLIF(SUM(d.creditos), 0),
        2
    ) AS media_ponderada
FROM tb_aluno a
	JOIN tb_curso c ON c.id_curso = a.fk_curso
	JOIN tb_matricula  m ON m.fk_aluno = a.id_aluno
	JOIN tb_turma t ON t.id_turma = m.fk_turma
	JOIN tb_disciplina d ON d.id_disc = t.fk_disc
WHERE m.nota IS NOT NULL
GROUP BY a.id_aluno, a.nome, c.nome
ORDER BY media_ponderada DESC;



/* QUERY 7 */
SELECT
    d_p.nome AS disciplina,
    d_pr.nome AS pre_requisito_exigido
FROM tb_pre_requisito pr
	JOIN tb_disciplina d_p ON d_p.id_disc = pr.fk_disc
	JOIN tb_disciplina d_pr  ON d_pr.id_disc    = pr.id_pre_req
ORDER BY d_p.nome;


/* QUERY 8 */
SELECT
    c.nome AS curso,
    c.tipo,
    COUNT(DISTINCT a.id_aluno) AS alunos_com_nota,
    ROUND(AVG(m.nota), 2) AS media_notas_curso
FROM tb_curso c
	JOIN tb_aluno a ON a.fk_curso = c.id_curso
	JOIN tb_matricula m ON m.fk_aluno = a.id_aluno
WHERE m.nota IS NOT NULL
GROUP BY c.id_curso, c.nome, c.tipo
HAVING AVG(m.nota) < 7.0
ORDER BY media_notas_curso;


/* QUERY 9 */
SELECT
    Aluno,
    Curso,
    Disciplina,
    Período,
    Professor,
    Nota,
    Frequência,
    Situaçao
FROM vw_historico_academico
WHERE Aluno = 'Ana Silva'
ORDER BY Período, Disciplina;



/* QUERY 10 */
SELECT
    p.nome AS professor,
    p.titulacao,
    p.email
FROM tb_professor p
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_turma t
		JOIN   tb_matricula m ON m.fk_turma = t.id_turma
		WHERE  t.fk_prof = p.id_prof
		AND  m.situacao IN ('Reprovado por Nota', 'Reprovado por Falta')
)
ORDER BY p.nome;
