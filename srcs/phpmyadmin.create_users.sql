CREATE USER 'pma'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'localhost';
ALTER USER 'pma'@'localhost' IDENTIFIED WITH mysql_native_password by 'pmapass';
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' by '';
