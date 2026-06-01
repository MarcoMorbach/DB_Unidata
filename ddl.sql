CREATE DATABASE UniData;
USE UniData;

CREATE TABLE Tb_curso(
id_curso INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(120) NOT NULL,
ch_total INT NOT NULL,
tipo ENUM('Graduacao','Pos-Graduacao') NOT NULL,
CONSTRAINT chk_ch_curso CHECK (ch_total > 0)
);

CREATE TABLE Tb_disciplina(
id_disc INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(120) NOT NULL,
ch INT NOT NULL,
creditos INT NOT NULL,
ementa TEXT DEFAULT NULL,
CONSTRAINT chk_ch_disc CHECK (ch > 0),
CONSTRAINT chk_cred_disc CHECK (creditos > 0)
);

CREATE TABLE Tb_pre_requisito(
fk_disc INT NOT NULL,
id_pre_req INT NOT NULL,
PRIMARY KEY(fk_disc,id_pre_req),
FOREIGN KEY(fk_disc) REFERENCES Tb_disciplina(id_disc),
FOREIGN KEY(id_pre_req) REFERENCES Tb_disciplina(id_disc),
CONSTRAINT chk_no_self_req CHECK (fk_disc != id_pre_req)
);

CREATE TABLE Tb_curso_disciplina(
fk_curso INT NOT NULL,
fk_disc INT NOT NULL,
obrigatoria ENUM('obrigatoria', 'optativa') DEFAULT 'obrigatoria',
PRIMARY KEY(fk_curso,fk_disc),
FOREIGN KEY(fk_curso) REFERENCES Tb_curso(id_curso),
FOREIGN KEY(fk_disc) REFERENCES Tb_disciplina(id_disc)
);

CREATE TABLE Tb_professor(
id_prof INT AUTO_INCREMENT,
nome VARCHAR(120) NOT NULL,
cpf CHAR(11) NOT NULL,
email VARCHAR(150) NOT NULL,
titulacao ENUM('Mestre','Doutor','Pos-Doutor') NOT NULL,
fk_curso_coord INT DEFAULT NULL,
PRIMARY KEY(id_prof),
FOREIGN KEY(fk_curso_coord) REFERENCES Tb_curso(id_curso),
CONSTRAINT uq_cpf_prof UNIQUE(cpf),
CONSTRAINT uq_email_prof UNIQUE (email)
);

CREATE TABLE Tb_turma(
id_turma INT AUTO_INCREMENT PRIMARY KEY,
fk_disc INT NOT NULL,
fk_proF INT NOT NULL,
semestre TINYINT NOT NULL,
ano YEAR NOT NULL,
capacidade INT NOT NULL,
FOREIGN KEY(fk_disc) REFERENCES Tb_disciplina(id_disc),
FOREIGN KEY(fk_prof) REFERENCES Tb_professor(id_prof),
CONSTRAINT chk_semestre CHECK (semestre IN (1,2)), 
CONSTRAINT chk_ano CHECK (ano >= 2000),
CONSTRAINT chk_cap CHECK (capacidade > 0) 
);

CREATE TABLE Tb_Aluno(
id_aluno INT AUTO_INCREMENT,
nome VARCHAR(120) NOT NULL,
cpf CHAR(11) NOT NULL,
email VARCHAR(150) NOT NULL,
dt_nasc DATE NOT NULL,
fk_curso INT NOT NULL,
PRIMARY KEY(id_aluno),
FOREIGN KEY(fk_curso) REFERENCES Tb_curso(id_curso),
CONSTRAINT uq_cpf_aluno UNIQUE (cpf),
CONSTRAINT uq_email_aluno UNIQUE (email)
); 

CREATE TABLE Tb_matricula(
id_mat INT AUTO_INCREMENT PRIMARY KEY,
fk_aluno INT NOT NULL,
fk_turma INT NOT NULL,
dt_inscricao DATE NOT NULL DEFAULT (CURRENT_DATE),
nota DECIMAL (4,1) DEFAULT NULL,
frequencia DECIMAL (5,2) DEFAULT NULL,
situacao ENUM ('Em Curso', 'Aprovado', 'Reprovado por nota', 'Reprovado pro falta') NOT NULL,
FOREIGN KEY (fk_aluno) REFERENCES Tb_aluno(id_aluno),
FOREIGN KEY (fk_turma) REFERENCES Tb_turma(id_turma) ON DELETE CASCADE,
CONSTRAINT uq_aluno_turma UNIQUE (fk_aluno, fk_turma),
CONSTRAINT chk_nota CHECK (0 <= nota <= 10) ,
CONSTRAINT chk_freq CHECK (0 <= frequencia <= 100)
);




