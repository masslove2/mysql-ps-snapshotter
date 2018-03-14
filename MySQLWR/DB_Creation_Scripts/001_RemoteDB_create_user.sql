
create user 'dbuser' identified by 'dbuser';
grant select on performance_schema.* to dbuser;
grant select on mysql.* to dbuser;