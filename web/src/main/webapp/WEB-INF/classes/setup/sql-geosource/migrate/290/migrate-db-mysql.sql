CREATE TABLE Services
  (
    id         int,
    name       varchar(64)   not null,
	class       varchar(1048)   not null,
    description       varchar(1048),
        
    primary key(id)
  );
  
CREATE TABLE ServiceParameters
  (
    id         int,
    service	 	int,
    name       varchar(64)   not null,
    value       varchar(1048)   not null,
    
    primary key(id),
        
    foreign key(service) references Services(id)
  );
  
  UPDATE Settings SET value='2.9.0' WHERE name='version';