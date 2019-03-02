Create table testalert (
	ID int not null auto_increment,
    name varchar(50),
    host varchar(50),
    urgency varchar(15),
    type varchar(15),
    ttime datetime,
    rtime datetime,
    htime varchar(5),
    primary key (ID),
    INDEX name_host (name,host),
    CONSTRAINT testalert_testalertname_name FOREIGN KEY (name) REFERENCES testalertname (name),
    CONSTRAINT testalert_testalertname_host FOREIGN KEY (host) REFERENCES testalertname (host)
);
Create table testperson (
	ID int not null auto_increment,
    name varchar(20),
    primary key (ID),
    Index name (name)
);
Create table testalertname (
	ID int not null auto_increment,
    name varchar(50),
    host varchar(50),
    normalinfo varchar(150),
    newinfo varchar(150),
    timein datetime,
    timeout datetime,
    personname varchar(20),
    primary key (ID),
    INDEX name_host (name,host),
    CONSTRAINT testperson_testalertname FOREIGN KEY (personname) REFERENCES testperson (name)
    )
