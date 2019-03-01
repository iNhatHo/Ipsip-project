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
)
