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

/* AS MONITORING, GRANT THE NEEDED RIGHTS TO STAGING, CLEANSING, AND CORE */

GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO STAGING;
GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO CLEANSING;
GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO CORE;

