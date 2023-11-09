/* 
 * 2023 Luca Bösch luca.boesch@bfh.ch
 * 
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU General
 * Public License as published by the Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
 * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program. If not, see
 * https://www.gnu.org/licenses/.
 */
 
-- CREATE USER SQL. MAKE SURE TO REPLACE <<passwd>> BY A REAL PASSWORD!
CREATE USER MONITORING IDENTIFIED BY <<passwd>>;
CREATE USER STAGING IDENTIFIED BY <<passwd>>;
CREATE USER CLEANSING IDENTIFIED BY <<passwd>>;
CREATE USER CORE IDENTIFIED BY <<passwd>>;
CREATE USER MART IDENTIFIED BY <<passwd>>;


-- ADD ROLES
GRANT CONNECT TO MONITORING;
GRANT CONSOLE_DEVELOPER TO MONITORING;
GRANT GRAPH_DEVELOPER TO MONITORING;
GRANT RESOURCE TO MONITORING;
ALTER USER MONITORING DEFAULT ROLE CONSOLE_DEVELOPER,GRAPH_DEVELOPER;

GRANT CONNECT TO STAGING;
GRANT CONSOLE_DEVELOPER TO STAGING;
GRANT GRAPH_DEVELOPER TO STAGING;
GRANT RESOURCE TO STAGING;
ALTER USER STAGING DEFAULT ROLE CONSOLE_DEVELOPER,GRAPH_DEVELOPER;

GRANT CONNECT TO CLEANSING;
GRANT CONSOLE_DEVELOPER TO CLEANSING;
GRANT GRAPH_DEVELOPER TO CLEANSING;
GRANT RESOURCE TO CLEANSING;
ALTER USER CLEANSING DEFAULT ROLE CONSOLE_DEVELOPER,GRAPH_DEVELOPER;

GRANT CONNECT TO CORE;
GRANT CONSOLE_DEVELOPER TO CORE;
GRANT GRAPH_DEVELOPER TO CORE;
GRANT RESOURCE TO CORE;
ALTER USER CORE DEFAULT ROLE CONSOLE_DEVELOPER,GRAPH_DEVELOPER;

GRANT CONNECT TO MART;
GRANT CONSOLE_DEVELOPER TO MART;
GRANT GRAPH_DEVELOPER TO MART;
GRANT RESOURCE TO MART;
ALTER USER MART DEFAULT ROLE CONSOLE_DEVELOPER,GRAPH_DEVELOPER;

-- REST ENABLE
BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema => 'MONITORING',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'monitoring',
        p_auto_rest_auth=> TRUE
    );
    -- ENABLE DATA SHARING
    C##ADP$SERVICE.DBMS_SHARE.ENABLE_SCHEMA(
            SCHEMA_NAME => 'MONITORING',
            ENABLED => TRUE
    );
    commit;
END;
/

BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema => 'STAGING',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'staging',
        p_auto_rest_auth=> TRUE
    );
    -- ENABLE DATA SHARING
    C##ADP$SERVICE.DBMS_SHARE.ENABLE_SCHEMA(
            SCHEMA_NAME => 'STAGING',
            ENABLED => TRUE
    );
    commit;
END;
/

BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema => 'CLEANSING',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'cleansing',
        p_auto_rest_auth=> TRUE
    );
    -- ENABLE DATA SHARING
    C##ADP$SERVICE.DBMS_SHARE.ENABLE_SCHEMA(
            SCHEMA_NAME => 'CLEANSING',
            ENABLED => TRUE
    );
    commit;
END;
/

BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema => 'CORE',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'core',
        p_auto_rest_auth=> TRUE
    );
    -- ENABLE DATA SHARING
    C##ADP$SERVICE.DBMS_SHARE.ENABLE_SCHEMA(
            SCHEMA_NAME => 'CORE',
            ENABLED => TRUE
    );
    commit;
END;
/

BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema => 'MART',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'mart',
        p_auto_rest_auth=> TRUE
    );
    -- ENABLE DATA SHARING
    C##ADP$SERVICE.DBMS_SHARE.ENABLE_SCHEMA(
            SCHEMA_NAME => 'MART',
            ENABLED => TRUE
    );
    commit;
END;
/

-- ENABLE GRAPH
ALTER USER MONITORING GRANT CONNECT THROUGH GRAPH$PROXY_USER;
ALTER USER STAGING GRANT CONNECT THROUGH GRAPH$PROXY_USER;
ALTER USER CLEANSING GRANT CONNECT THROUGH GRAPH$PROXY_USER;
ALTER USER CORE GRANT CONNECT THROUGH GRAPH$PROXY_USER;
ALTER USER MART GRANT CONNECT THROUGH GRAPH$PROXY_USER;

-- QUOTA
ALTER USER MONITORING QUOTA UNLIMITED ON DATA;
ALTER USER STAGING QUOTA UNLIMITED ON DATA;
ALTER USER CLEANSING QUOTA UNLIMITED ON DATA;
ALTER USER CORE QUOTA UNLIMITED ON DATA;
ALTER USER MART QUOTA UNLIMITED ON DATA;

-- ADDITIONAL GRANTS
GRANT DWROLE, OML_DEVELOPER, CREATE TABLE, CREATE VIEW TO STAGING;
GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO STAGING;
GRANT EXECUTE ON DBMS_CLOUD TO STAGING;
ALTER USER STAGING QUOTA UNLIMITED ON DATA;

