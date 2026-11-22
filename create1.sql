CREATE TABLE Ciclista (
    CiclistaID      INTEGER PRIMARY KEY,
    nome            TEXT NOT NULL,
    nacionalidade   TEXT NOT NULL,
    dataNascimento  TEXT NOT NULL
);

CREATE TABLE Equipa (
    sigla           TEXT PRIMARY KEY,
    nome            TEXT NOT NULL,
    país            TEXT NOT NULL,
    patrocinador    TEXT NOT NULL
);

CREATE TABLE Edição (
    EdiçãoID        INTEGER PRIMARY KEY,
    dataInício      TEXT NOT NULL,
    dataFim         TEXT NOT NULL,
    CHECK (dataFim >= dataInício)
);

CREATE TABLE Inscrição (
    EdiçãoID        INTEGER NOT NULL,
    dorsal          INTEGER NOT NULL,
    CiclistaID      INTEGER NOT NULL,
    sigla           TEXT NOT NULL,
    UNIQUE (EdiçãoID, CiclistaID),
    PRIMARY KEY (EdiçãoID, dorsal),
    FOREIGN KEY (EdiçãoID) REFERENCES Edição(EdiçãoID),
    FOREIGN KEY (CiclistaID) REFERENCES Ciclista(CiclistaID),
    FOREIGN KEY (sigla) REFERENCES Equipa(sigla)
);

CREATE TABLE Etapa (
    EdiçãoID        INTEGER NOT NULL,
    número          INTEGER NOT NULL,
    partida         TEXT NOT NULL,
    chegada         TEXT NOT NULL,
    distância       INTEGER NOT NULL,
    data            TEXT NOT NULL,
    PRIMARY KEY (EdiçãoID, número),
    FOREIGN KEY (EdiçãoID) REFERENCES Edição(EdiçãoID)
);

CREATE TABLE Comissário (
    numLicença      INTEGER PRIMARY KEY,
    nome            TEXT NOT NULL
);

CREATE TABLE EdiçãoComissário (
    EdiçãoID        INTEGER NOT NULL,
    numLicença      INTEGER NOT NULL,
    PRIMARY KEY (EdiçãoID, numLicença),
    FOREIGN KEY (EdiçãoID) REFERENCES Edição(EdiçãoID),
    FOREIGN KEY (numLicença) REFERENCES Comissário(numLicença)
);

CREATE TABLE EtapaContrarrelógio (
    EdiçãoID            INTEGER NOT NULL,
    número              INTEGER NOT NULL,
    tipo                TEXT NOT NULL,
    intervaloPartida   TEXT NOT NULL,
    PRIMARY KEY (EdiçãoID, número),
    FOREIGN KEY (EdiçãoID, número) REFERENCES Etapa(EdiçãoID, número)
);

CREATE TABLE EtapaMontanha (
    EdiçãoID            INTEGER NOT NULL,
    número              INTEGER NOT NULL,
    ganhoElevação       INTEGER NOT NULL,
    altitudeMáxima      INTEGER NOT NULL,
    PRIMARY KEY (EdiçãoID, número),
    FOREIGN KEY (EdiçãoID, número) REFERENCES Etapa(EdiçãoID, número)
);

CREATE TABLE Percurso (
    EdiçãoID INTEGER NOT NULL,
    número INTEGER NOT NULL,
    local TEXT NOT NULL,
    PRIMARY KEY (EdiçãoID, número, local),
    FOREIGN KEY (EdiçãoID, número) REFERENCES Etapa(EdiçãoID, número)
);

CREATE TABLE PontoIntermédio (
    PontoIntermédioID INTEGER PRIMARY KEY,
    EdiçãoID INTEGER NOT NULL,
    número INTEGER NOT NULL,
    quilómetro INTEGER NOT NULL,
    FOREIGN KEY (EdiçãoID, número) REFERENCES Etapa(EdiçãoID, número)
);

CREATE TABLE Sprint (
    PontoIntermédioID INTEGER PRIMARY KEY,
    tempoBonificação INTEGER NOT NULL,
    FOREIGN KEY (PontoIntermédioID) REFERENCES PontoIntermédio(PontoIntermédioID)
);

CREATE TABLE PontoMontanha (
    PontoIntermédioID INTEGER PRIMARY KEY,
    categoria TEXT NOT NULL,
    FOREIGN KEY (PontoIntermédioID) REFERENCES PontoIntermédio(PontoIntermédioID)
);

CREATE TABLE Participação (
    EdiçãoID        INTEGER NOT NULL,
    dorsal          INTEGER NOT NULL,
    número          INTEGER NOT NULL,
    posição         INTEGER NOT NULL,
    tempoBruto      TEXT NOT NULL,
    UNIQUE (EdiçãoID, número, posição),
    PRIMARY KEY (EdiçãoID, dorsal, número),
    FOREIGN KEY (EdiçãoID, dorsal) REFERENCES Inscrição(EdiçãoID, dorsal),
    FOREIGN KEY (EdiçãoID, número) REFERENCES Etapa(EdiçãoID, número)
);

CREATE TABLE Penalização (
    PenalizaçãoID   INTEGER PRIMARY KEY,
    EdiçãoID        INTEGER NOT NULL,
    dorsal          INTEGER NOT NULL,
    número          INTEGER NOT NULL,
    motivo          TEXT NOT NULL,
    tempoAdicionado TEXT NOT NULL,
    FOREIGN KEY (EdiçãoID, dorsal, número) REFERENCES Participação(EdiçãoID, dorsal, número)
);

CREATE TABLE Incidente (
    IncidenteID     INTEGER PRIMARY KEY,
    EdiçãoID        INTEGER NOT NULL,
    dorsal          INTEGER NOT NULL,
    número          INTEGER NOT NULL,
    quilómetro      INTEGER NOT NULL,
    tipo            TEXT NOT NULL,
    FOREIGN KEY (EdiçãoID, dorsal, número) REFERENCES Participação(EdiçãoID, dorsal, número)
);

CREATE TABLE Bonificação (
    BonificaçãoID       INTEGER PRIMARY KEY,
    EdiçãoID            INTEGER NOT NULL,
    dorsal              INTEGER NOT NULL,
    número              INTEGER NOT NULL,
    PontoIntermédioID   INTEGER,
    tempoDescontado     TEXT NOT NULL,
    FOREIGN KEY (EdiçãoID, dorsal, número) REFERENCES Participação(EdiçãoID, dorsal, número),
    FOREIGN KEY (PontoIntermédioID) REFERENCES PontoIntermédio(PontoIntermédioID)
);