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

SELECT
    'https://www.example.org/moodle' AS "sourcesystem", -- the source system.
    '1,2,3,45,678,9012' AS "authorizedusers", -- the authorized users
    assign.id AS "assignid", -- the assignment id.
    assign.name AS "assignname", -- the assignment name.
    assign.grade AS "assignmaxgrade", -- the assignment max grade.
    MD5(u.username) AS "userhash", -- the user taking the assignment.
    ag.id AS "assigngradeid", -- the assignment grade id.
    ag.grade AS "assigngrade", -- The grade for the assignment submission.
    ass.attemptnumber, -- the attempt number.,
    ass.latest, -- is it the latest attempt.
    assot.submission, -- online submission id
    assot.onlinetext, -- online submission text
    uid.data AS "userinfodata"
FROM {assign} assign
    LEFT JOIN {assign_submission} ass
    ON ass.assignment = assign.id
    LEFT JOIN {assign_grades} ag
    ON ag.assignment = assign.id AND ass.userid = ag.userid
    LEFT JOIN {assignsubmission_onlinetext} assot
    ON assign.id = assot.assignment AND ass.id = assot.submission
    LEFT JOIN {user} u
    ON ag.userid = u.id AND ag.assignment = assign.id
    LEFT JOIN {course} c
    ON c.id = assign.course
    LEFT JOIN {course_modules} cm
    ON cm.course = c.id AND cm.instance = assign.id
    LEFT JOIN {modules} m
    ON cm.module = m.id AND m.name = 'assign'
    LEFT JOIN {user_info_data} uid
    ON u.id = uid.userid
    LEFT JOIN {user_info_field} uif
    ON uif.id = uid.fieldid AND uif.shortname = 'analytics'
WHERE cm.course=%%COURSEID%% AND cm.id = %%CMID%% AND ((uid.data IS NULL) OR (uid.data !='1'))
