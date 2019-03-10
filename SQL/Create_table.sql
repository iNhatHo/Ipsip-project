Create table alert (
	ID int not null auto_increment,
    name varchar(50),
    host varchar(50),
    tooltouse varchar(150),
	urgency varchar(15),
    primary key (ID)
);
Create table alerttrigger (
	ID int not null auto_increment,
    name varchar(50),
    host varchar(50),
	urgency varchar(15),
    type varchar(15),
    ttime datetime,
    rtime datetime,
    htime varchar(5),
    primary key (ID)
);
Create table alertinfo (
	ID int not null auto_increment,
    name varchar(50),
    host varchar(50),
    info varchar(150),
    timein datetime,
    person varchar(20),
    type varchar(15),
    primary key (ID)
);
Create table  team (
	ID int not null auto_increment,
    name varchar(50),
    primary key(ID)
);
Create table urgencytype (
	ID int not null auto_increment,
    urgency varchar(20),
    primary key (ID)
);
Create table alertype (
	Atype varchar(50),
    primary key (Atype)
);

Create index UT_urgency on urgencytype (urgency);
Create index A_name_host on alert (name,host);
Create index T_person_name on team (name);

ALTER TABLE alert add constraint FK_alert_urgencytype foreign key (urgency) references urgencytype (urgency);
ALTER TABLE alerttrigger add constraint FK_alerttrigger_alert_name foreign key (name,host) references alert (name,host);
ALTER TABLE alerttrigger add constraint FK_alerttrigger_alert_urgency foreign key (urgency) references alert (urgency);
ALTER TABLE alertinfo add constraint FK_alertinfo_alert foreign key (name,host) references alert (name,host);
ALTER TABLE alertinfo add constraint FK_alertinfo_team foreign key (person) references team (name);
ALTER TABLE alertinfo add constraint FK_alertinfo_alerttype foreign key (type) references alerttype (Atype)