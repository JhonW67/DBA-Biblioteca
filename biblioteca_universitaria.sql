CREATE DATABASE biblioteca_universitaria;
USE biblioteca_universitaria;
CREATE TABLE alunos (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY
    ,nome VARCHAR(100) NOT NULL
    ,curso VARCHAR(100)
    ,data_matricula DATE NOT NULL
);
CREATE TABLE livros (
    id_livro INT AUTO_INCREMENT PRIMARY KEY
    ,titulo VARCHAR(200) NOT NULL
    ,autor VARCHAR(100) NOT NULL
    ,quantidade_estoque INT NOT NULL CHECK (quantidade_estoque >= 0)
);
CREATE TABLE emprestimos (
    id_emprestimo INT AUTO_INCREMENT PRIMARY KEY
    ,id_aluno INT
    ,id_livro INT
    ,data_emprestimo DATE NOT NULL
    ,data_devolucao DATE DEFAULT NULL 
); 
CREATE TABLE penalidades (
    id_penalidade INT AUTO_INCREMENT PRIMARY KEY
    ,id_aluno INT
    ,descricao TEXT NOT NULL
    ,data_penalidade DATE NOT NULL
);

ALTER TABLE emprestimos ADD CONSTRAINT FK_emprestimos_X_PK_livros
FOREIGN KEY (id_livro) REFERENCES livros (id_livro);

ALTER TABLE emprestimos ADD CONSTRAINT FK_emprestimosXPK_alunos
FOREIGN KEY (id_aluno) REFERENCES alunos (id_aluno);
