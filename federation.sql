CREATE TABLE person (
    national_id_or_passport VARCHAR(20) NOT NULL,
    nationality VARCHAR(20) NOT NULL,
    firstname_and_lastName_english VARCHAR(50) NOT NULL,
    firstname_and_lastname_persian VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    PRIMARY KEY (national_id_or_passport , nationality)
);
CREATE TABLE player (
    player_id SERIAL,
    national_id_or_passport VARCHAR(20) NOT NULL,
    nationality VARCHAR(20) NOT NULL,
    free BOOL NOT NULL ,
    FOREIGN KEY (national_id_or_passport,nationality) REFERENCES person(national_id_or_passport,nationality),
    PRIMARY KEY (player_id)
);
CREATE TABLE staff (
    staff_id SERIAL,
    national_id_or_passport VARCHAR(20) NOT NULL,
    nationality VARCHAR(20) NOT NULL,
    post VARCHAR(20) NOT NULL ,
    FOREIGN KEY (national_id_or_passport,nationality) REFERENCES person(national_id_or_passport,nationality),
    PRIMARY KEY (staff_id,post)
);
CREATE TABLE referee (
    referee_id SERIAL,
    national_id_or_passport VARCHAR(20) NOT NULL,
    nationality VARCHAR(20) NOT NULL,
    level VARCHAR(20) NOT NULL ,
    FOREIGN KEY (national_id_or_passport,nationality) REFERENCES person(national_id_or_passport,nationality),
    PRIMARY KEY (referee_id)
);

CREATE TABLE team (
    team_id SERIAL,
    name VARCHAR(20) NOT NULL,
    date_of_foundation DATE NOT NULL,
    city VARCHAR(50) NOT NULL,
    PRIMARY KEY (team_id)
);

CREATE TABLE STADIUM
(
    stadium_id       SERIAL,
    ticket_price     INT           NOT NULL,
    stadium_city     VARCHAR(20)   NOT NULL,
    stadium_name     VARCHAR(20)   NOT NULL,
    stadium_level    stadium_level NOT NULL,
    stadium_capacity INT           NOT NULL,
    stadium_address  VARCHAR(50)   NOT NULL,
    stadium_features TEXT          NOT NULL,
    PRIMARY KEY (stadium_id)
);

CREATE TABLE league
(
    league_name VARCHAR(20) NOT NULL,
    PRIMARY KEY (league_name)
);

CREATE TABLE season
(
    season_id     SERIAL,
    season_number INT         NOT NULL CHECK (season_number > 0),
    league_name   VARCHAR(20) NOT NULL REFERENCES league (league_name) ON DELETE CASCADE,
    PRIMARY KEY (season_id)
);

CREATE TABLE week
(
    week_id     SERIAL,
    week_number INT  NOT NULL CHECK (week_number > 0),
    season_id   INT  NOT NULL REFERENCES season (season_id) ON DELETE CASCADE,
    start_date  DATE NOT NULL,
    end_date    DATE NOT NULL,
    PRIMARY KEY (week_id)
);

CREATE TABLE team_season (
    team_season_id SERIAL,
    season_id INT NOT NULL,
    team_id INT NOT NULL,
    point SMALLINT NOT NULL DEFAULT 0,
    rank SMALLINT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES team(team_id),
    FOREIGN KEY (season_id) REFERENCES season(season_id),
    PRIMARY KEY (team_season_id)
);


CREATE TYPE stadium_level AS ENUM ('international' , 'local' , 'regional' , 'national');