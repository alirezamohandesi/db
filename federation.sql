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
    UNIQUE ( national_id_or_passport , nationality),
    FOREIGN KEY (national_id_or_passport,nationality) REFERENCES person(national_id_or_passport,nationality) ON DELETE CASCADE ,
    PRIMARY KEY (player_id)
);
CREATE TABLE staff (
    staff_id SERIAL,
    national_id_or_passport VARCHAR(20) NOT NULL,
    nationality VARCHAR(20) NOT NULL,
    post VARCHAR(20) NOT NULL ,
    UNIQUE ( national_id_or_passport , nationality),
    FOREIGN KEY (national_id_or_passport,nationality) REFERENCES person(national_id_or_passport,nationality) ON DELETE CASCADE ,
    PRIMARY KEY (staff_id,post)
);
CREATE TABLE referee (
    referee_id SERIAL,
    national_id_or_passport VARCHAR(20) NOT NULL,
    nationality VARCHAR(20) NOT NULL,
    UNIQUE (national_id_or_passport , nationality),
    level referee_level NOT NULL ,
    FOREIGN KEY (national_id_or_passport,nationality) REFERENCES person(national_id_or_passport,nationality) ON DELETE CASCADE ,
    PRIMARY KEY (referee_id)
);

CREATE TABLE team (
    team_id SERIAL,
    name VARCHAR(20) NOT NULL,
    date_of_foundation DATE NOT NULL,
    city VARCHAR(50) NOT NULL,
    PRIMARY KEY (team_id)
);

CREATE TABLE stadium
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
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE CASCADE ,
    FOREIGN KEY (season_id) REFERENCES season(season_id) ON DELETE CASCADE ,
    PRIMARY KEY (team_season_id)
);

CREATE TABLE referee_committee (
    committee_id SERIAL,
    members TEXT ,
    period INT NOT NULL CHECK (period > 0),
    season_id INT NOT NULL REFERENCES season(season_id) ON DELETE CASCADE,
    PRIMARY KEY (committee_id)
);
CREATE TABLE foreign_transfer(
    foreign_team_name VARCHAR(20) NOT NULL,
    foreign_team_country VARCHAR(20) NOT NULL,
    internal_team_id INT NOT NULL,
    player_id INT NOT NULL,
    player_monthly_wage INT NOT NULL,
    type transfer_type NOT NULL,
    FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE CASCADE ,
    FOREIGN KEY (internal_team_id) REFERENCES team_season(team_season_id) ON DELETE CASCADE ,
    PRIMARY KEY (foreign_team_name,foreign_team_country,internal_team_id,player_id)
);


CREATE TABLE internal_transfer(
    seller_id INT NOT NULL,
    buyer_id INT NOT NULL,
    player_id INT NOT NULL,
    player_monthly_wage INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE CASCADE ,
    FOREIGN KEY (seller_id) REFERENCES team_season(team_season_id) ON DELETE CASCADE ,
    FOREIGN KEY (buyer_id) REFERENCES team_season(team_season_id)  ON DELETE CASCADE ,
    PRIMARY KEY (seller_id,buyer_id,player_id)
);

CREATE TABLE termination_contract (
    team_season_id INT NOT NULL,
    player_id INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE CASCADE ,
    FOREIGN KEY (team_season_id) REFERENCES team_season(team_season_id) ON DELETE CASCADE ,
    PRIMARY KEY (team_season_id,player_id)
);

CREATE TABLE buy_free_player (
    team_season_id INT NOT NULL,
    player_id INT NOT NULL,
    player_monthly_wage INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE CASCADE ,
    FOREIGN KEY (team_season_id) REFERENCES team_season(team_season_id) ON DELETE CASCADE ,
    PRIMARY KEY (team_season_id,player_id)
);

CREATE TABLE contract (
    contract_id SERIAL,
    team_season_id INT NOT NULL,
    player_id INT NOT NULL,
    player_monthly_wage INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES player(player_id) ON DELETE CASCADE ,
    FOREIGN KEY (team_season_id) REFERENCES team_season(team_season_id) ON DELETE CASCADE ,
    PRIMARY KEY (contract_id)
);

CREATE TABLE team_game (
    team_game_id SERIAL,
    team_season_id INT NOT NULL REFERENCES team_season(team_season_id) ON DELETE CASCADE,
    offside_number INT NOT NULL DEFAULT  0 CHECK ( offside_number>= 0 ),
    dangerous_free_kick_number INT NOT NULL DEFAULT 0 CHECK ( offside_number>=0 ),
    free_kick_number INT NOT NULL DEFAULT 0 CHECK ( successful_pass>=0 ),
    successful_pass INT NOT NULL  DEFAULT 0 CHECK (successful_pass >= 0),
    possession_percentage INT NOT NULL  CHECK (possession_percentage >= 0 AND possession_percentage <= 100),
    pass_number INT NOT NULL DEFAULT 0 CHECK (pass_number >= 0),
    corner_number INT NOT NULL DEFAULT 0 CHECK (corner_number >= 0)
);

CREATE TABLE game (
    game_id SERIAL,
    home_team_game_id INT NOT NULL REFERENCES team_game(team_game_id) ON DELETE RESTRICT ,
    away_team_game_id INT NOT NULL REFERENCES team_game(team_game_id) ON DELETE RESTRICT ,
    stadium_id INT NOT NULL REFERENCES stadium(stadium_id) ON DELETE NO ACTION ,
    week_id INT NOT NULL REFERENCES week(week_id) ON DELETE CASCADE,
    game_date DATE NOT NULL,
    result VARCHAR(20) NOT NULL CHECK ( result LIKE '[0-9]{1,2}:[0-9]{1,2}' ),
    PRIMARY KEY (game_id)
);

CREATE TABLE player_game (
    player_game_id SERIAL,
    team_game_id INT NOT NULL,
    contract_id INT NOT NULL,
    type player_game_type NOT NULL,
    FOREIGN KEY (team_game_id) REFERENCES team_game(team_game_id) ON DELETE CASCADE ,
    FOREIGN KEY (contract_id) REFERENCES contract(contract_id) ON DELETE CASCADE ,
    PRIMARY KEY (player_game_id)
);

CREATE TABLE event(
    event_id SERIAL,
    game_id INT NOT NULL,
    minute VARCHAR(2) NOT NULL CHECK (minute LIKE '[0-9]{1,2}'),
    FOREIGN KEY (game_id) REFERENCES game(game_id) ON DELETE CASCADE ,
    PRIMARY KEY (event_id)
);

CREATE TABLE staff_membership(
    staff_membership_id SERIAL,
    staff_id INT NOT NULL REFERENCES staff(staff_id) ON DELETE CASCADE,
    team_game_id INT NOT NULL REFERENCES team_game(team_game_id) ON DELETE CASCADE,
    post VARCHAR(20) NOT NULL,
    PRIMARY KEY (staff_membership_id)
);

CREATE TABLE referee_team(
    referee_team_id SERIAL,
    game_id INT NOT NULL REFERENCES game(game_id) ON DELETE CASCADE ,
    first_referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE RESTRICT ,
    second_referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE RESTRICT ,
    third_referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE RESTRICT ,
    forth_referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE RESTRICT ,
    observer_referee_id INT NOT NULL REFERENCES referee(referee_id) ON DELETE RESTRICT ,
    first_referee_score INT ,
    second_referee_score INT ,
    third_referee_score INT ,
    forth_referee_score INT
);

CREATE TABLE staff_red_card(
    event_id INT REFERENCES event(event_id) ON DELETE CASCADE ,
    staff_membership_id INT NOT NULL REFERENCES staff_membership(staff_membership_id) ON DELETE NO ACTION ,
    is_second_yellow_card BOOL NOT NULL DEFAULT false
);

CREATE TABLE staff_yellow_card(
    event_id INT REFERENCES event(event_id) ON DELETE CASCADE ,
   staff_membership_id INT NOT NULL REFERENCES staff_membership(staff_membership_id) ON DELETE NO ACTION
);

CREATE TABLE player_red_card(
    event_id INT REFERENCES event(event_id) ON DELETE CASCADE ,
    player_game_id INT NOT NULL REFERENCES player_game(player_game_id) ON DELETE NO ACTION ,
    is_second_yellow_card BOOL NOT NULL DEFAULT false
);

CREATE TABLE player_yellow_card(
    event_id INT REFERENCES  event(event_id) ON DELETE CASCADE ,
    player_game_id INT NOT NULL REFERENCES player_game(player_game_id) ON DELETE NO ACTION
);
CREATE TABLE foul (
    event_id INT NOT NULL,
    fouler_id INT NOT NULL,
    fouled_id INT , -- may be hand foul
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE ,
    FOREIGN KEY (fouler_id) REFERENCES player_game(player_game_id) ON DELETE NO ACTION ,
    FOREIGN KEY (fouled_id) REFERENCES player_game(player_game_id) ON DELETE NO ACTION ,
    PRIMARY KEY (event_id)
);

CREATE TABLE goal_score (
    event_id INT NOT NULL,
    goal_scorer_id INT NOT NULL,
    penalty BOOL NOT NULL,
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE ,
    FOREIGN KEY (goal_scorer_id) REFERENCES player_game(player_game_id) ON DELETE NO ACTION ,
    PRIMARY KEY (event_id)
);

CREATE TABLE substitution (
    event_id INT NOT NULL,
    player_in_id INT NOT NULL,
    player_out_id INT NOT NULL,
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE ,
    FOREIGN KEY (player_in_id) REFERENCES player_game(player_game_id)  ON DELETE NO ACTION ,
    FOREIGN KEY (player_out_id) REFERENCES player_game(player_game_id) ON DELETE NO ACTION ,
    PRIMARY KEY (event_id)
);


CREATE TYPE stadium_level AS ENUM ('international' , 'local' , 'regional' , 'national');
CREATE TYPE player_game_type AS ENUM ('substitute' , 'in-game');
CREATE TYPE transfer_type AS ENUM ('buy' , 'sell');
CREATE TYPE referee_level AS ENUM ('international' , 'local' , 'regional' , 'national');