SELECT
    'http://localhost/mdk/stable_401' AS "sourcesystem", -- the source system.
    '1,2,3,45,678,9012' AS "authorizedusers", -- the authorized users
    assign.id AS "assignid", -- the assignment id.
    assign.name AS "assignname", -- the assignment name.
    assign.grade AS "assignmaxgrade", -- the assignment max grade.
    MD5(u.username) AS "userhash", -- the user taking the assignment.
    ag.grade AS "assigngrade",
    ass.attemptnumber, -- the attempt number.,
    ass.latest, -- is it the latest attempt.
    assot.submission, -- online submission id
    assot.onlinetext, -- online submission text
    uid.data AS "userinfodata"
FROM {assign assign
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
WHERE cm.course=11 AND cm.id = 107 AND ((uid.data IS NULL) OR (uid.data !='1'))