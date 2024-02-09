SET AUTOCOMMIT =on;
use realestatelisting;
CREATE TABLE user (
    username VARCHAR(20),
    fullname VARCHAR(20) NOT NULL,
    phonenumber BIGINT CHECK (CHAR_LENGTH(phonenumber)=10 ) NOT NULL UNIQUE,
    password VARCHAR(30) CHECK(CHAR_LENGTH(password) > 6) NOT NULL,
    userimage blob,
    primary key(username)
);
ALTER TABLE user
DROP COLUMN createdate;


select * from user;

INSERT INTO user (username, fullname, phonenumber, password)
VALUES ('newuser', 'New User', 1234567890, 'password123');
INSERT INTO user (username, fullname, phonenumber, password, userimage)
VALUES ('newuser', 'New User', 1234567890, 'password123');


DELIMITER //
CREATE TRIGGER before_insert_user
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
  SET NEW.createdate = SYSDATE();
END;
//
DELIMITER ;



select * from propertytype;
DROP FUNCTION IF EXISTS realestatelisting.alreadychecker;
select * from propertytype;
ALTER TABLE user
MODIFY COLUMN userimage LONGBLOB;
CREATE TABLE propertyType (
    propertyTypeID int,
    typename VARCHAR(20) NOT NULL,
    PRIMARY KEY (propertyTypeID)
);
CREATE TABLE cities (
    cityID INT PRIMARY KEY,
    cityname VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE propertybackup (
    propertyID INT ,
    cityID INT,
    propertyTypeId INT,
    username VARCHAR(20),
    title VARCHAR(50) NOT NULL,
    descripation VARCHAR(500) NOT NULL CHECK (LENGTH(descripation) < 500),
    bedrooms INT DEFAULT 1,
    bathrooms INT DEFAULT 1,
    area DOUBLE NOT NULL CHECK (area > 0),
    price DOUBLE NOT NULL CHECK (price > 0),
    isInstallmentAvailable BOOL NOT NULL,
    dateposted DATE NOT NULL,
    PRIMARY KEY (propertyID),
    
);


CREATE TABLE propertyImages (
    imageID INT AUTO_INCREMENT,
    propertyID INT,
    imageurl Longblob NOT NULL,
    PRIMARY KEY (imageID),
    FOREIGN KEY (propertyID)REFERENCES property (propertyID)
);
CREATE TABLE finnace (
    finnaceID INT AUTO_INCREMENT,
    propertyID INT,
    downpayment DOUBLE NOT NULL CHECK (downpayment > 0),
    installmentAmount DOUBLE NOT NULL CHECK (installmentAmount > 0),
    noOfInstallments INT NOT NULL CHECK (noOfInstallments > 0),
    PRIMARY KEY (finnaceID),
    FOREIGN KEY (propertyID)
        REFERENCES property (propertyid)
);
ALTER TABLE finnace
DROP FOREIGN KEY finnace_ibfk_1;
ALTER TABLE finnace
ADD CONSTRAINT finnace_ibfk_1
FOREIGN KEY (propertyID)
REFERENCES property (propertyID)
ON DELETE CASCADE
select * from property;

drop trigger before_insert_user

select * from user;
drop table propertybackup;
drop trigger beforedelete;