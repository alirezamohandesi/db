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