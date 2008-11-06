/*
 * Villagrán & Quiroz - http://www.villagranquiroz.cl
 * Servicios Informáticos
 */   
/*
 * Drops
 */
DROP TABLE IF EXISTS Media;
DROP TABLE IF EXISTS Preferences;
DROP TABLE IF EXISTS Albums;

/*
 * Media Table
 */

CREATE TABLE Media (
  Path         text 			NOT NULL ON CONFLICT IGNORE UNIQUE ON CONFLICT REPLACE,
  Artist       varchar(50),
  Album        varchar(50),
  Title        varchar(50),
  TrackNumber  int,
  Year         integer,
  Duration     varchar(10),
  Rank         integer
);

/*
 * Preferences Table
 */

CREATE TABLE Preferences (
	MediaPath	TEXT			NULL,
	Shuffle		INT				NULL,
	Repeat		INT				NULL
);
/*
 * Albums Cover Table
 */
CREATE TABLE Albums (
	AlbumName	TEXT			NOT NULL ON CONFLICT IGNORE UNIQUE ON CONFLICT REPLACE,
	CoverArt	blob			NULL
);
/*
 * Default Values
 */
INSERT INTO Preferences VALUES (
	NULL, 	1,	1
);
