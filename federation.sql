CREATE TABLE person (
    NationalIDOrPassport VARCHAR(20) NOT NULL,
    Nationality VARCHAR(20) NOT NULL,
    FirstNameAndLastName_English VARCHAR(50) NOT NULL,
    FirstNameAndLastName_Persian VARCHAR(50) NOT NULL,
    UNIQUE (NationalIDOrPassport , Nationality) ,
    PRIMARY KEY (NationalIDOrPassport , Nationality)
)