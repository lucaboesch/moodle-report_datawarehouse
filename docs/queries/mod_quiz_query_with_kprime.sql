/* 
 * 2024 Luca Bösch luca.boesch@bfh.ch
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
    qn.id AS "questionid", -- the question id.
    qn.parent AS "questionparent", -- the parent question id, given it has one.
    qn.name AS "questionname", -- the question name.
    qn.questiontext, -- the question text.
    qn.questiontextformat, qn.generalfeedback, qn.generalfeedbackformat,
    qn.defaultmark,
    qn.penalty, qn.qtype, qn.length, qn.stamp AS "questionstamp", qn.timecreated AS "qntimecreated", -- when this question was created.
    lpad(EXTRACT(DAY FROM to_timestamp(qn.timecreated+3600))::text, 2, '0') || '.' || lpad(EXTRACT(MONTH FROM to_timestamp(qn.timecreated+3600))::text, 2, '0') || '.' || EXTRACT(YEAR FROM
                                                                                                                                                                                  to_timestamp(qn.timecreated+3600)) || ' ' || lpad(EXTRACT(HOUR FROM to_timestamp(qn.timecreated+3600))::text, 2, '0') || ':' || lpad(EXTRACT(MINUTE FROM to_timestamp(qn.timecreated+3600))::text, 2,
                                                                                                                                                                                                                                                                                                                       '0') || ':' || lpad(EXTRACT(SECOND FROM to_timestamp(qn.timecreated+3600))::text, 2, '0') "qntimecreatedstring", -- when this question was created.
    qn.timemodified AS "qntimemodified", -- when this question was modified.
    lpad(EXTRACT(DAY FROM to_timestamp(qn.timemodified+3600))::text, 2, '0') || '.' || lpad(EXTRACT(MONTH FROM to_timestamp(qn.timemodified+3600))::text, 2, '0') || '.' || EXTRACT(YEAR FROM
                                                                                                                                                                                    to_timestamp(qn.timemodified+3600)) || ' ' || lpad(EXTRACT(HOUR FROM to_timestamp(qn.timemodified+3600))::text, 2, '0') || ':' || lpad(EXTRACT(MINUTE FROM to_timestamp(qn.timemodified+3600))::text, 2,
                                                                                                                                                                                                                                                                                                                           '0') || ':' || lpad(EXTRACT(SECOND FROM to_timestamp(qn.timemodified+3600))::text, 2, '0') "qntimemodifiedstring", -- when this question was modified.
    qn.createdby AS "qncreatedby", -- by whom this question was created.
    qn.modifiedby AS "qnmodifiedby", -- by whom this question was modified.
    qna.id AS "questionanswersid", qna.answer, qna.answerformat,
    qtkprimer.optiontext "kprime option text",
    qtkprimer.number "kprime option row number",
    qtkprimec.responsetext "kprime option responsetext",
    qtkprimew.weight "kprime option weight",
    qna.fraction, qna.feedback, qna.feedbackformat,
    qnv.id AS "questionversionid", qnv.questionbankentryid, qnv.version, qnv.questionid, qnv.status,
    qbe.questioncategoryid, qbe.idnumber as "questionbankentryidnumber", qbe.ownerid AS "ownerid",
    qnr.id AS "questionreferencesid", qnr.usingcontextid, qnr.component, qnr.questionarea, qnr.itemid, qnr.version as "questionreferencesversion",
    qc.id AS "questioncategoriesid", qc.name AS "questioncategoryname", qc.contextid AS "questioncategorycontextid", qc.info, qc.infoformat, qc.stamp AS "questioncategorystamp", qc.parent AS
        "questioncategoryparent", qc.sortorder, qc.idnumber as "questioncategoryidnumber",
    qs.slot,
    qs.effectiveweight,
    qs.discriminationindex,
    qs.discriminativeefficiency,
    qs.sd,
    qs.facility,
    qs.randomguessscore, -- An estimate of the score a student would get by guessing randomly.
-- u.id AS "userid",
    MD5(u.username) "qbeusername",
    ctx.id AS "contextid", ctx.path,
    qnat.id AS "questionattemptsid", qnat.timemodified AS "qatimemodified",
    lpad(EXTRACT(DAY FROM to_timestamp(qnat.timemodified+3600))::text, 2, '0') || '.' || lpad(EXTRACT(MONTH FROM to_timestamp(qnat.timemodified+3600))::text, 2, '0') || '.' || EXTRACT(YEAR FROM
                                                                                                                                                                                        to_timestamp(qnat.timemodified+3600)) || ' ' || lpad(EXTRACT(HOUR FROM to_timestamp(qnat.timemodified+3600))::text, 2, '0') || ':' || lpad(EXTRACT(MINUTE FROM
                                                                                                                                                                                                                                                                                                                                           to_timestamp(qnat.timemodified+3600))::text, 2, '0') || ':' || lpad(EXTRACT(SECOND FROM to_timestamp(qnat.timemodified+3600))::text, 2, '0') "qatimemodifiedstring",
    qas.id AS "qastepid",
    qas.timecreated AS "qastepcreated",
    lpad(EXTRACT(DAY FROM to_timestamp(qas.timecreated+3600))::text, 2, '0') || '.' || lpad(EXTRACT(MONTH FROM to_timestamp(qas.timecreated+3600))::text, 2, '0') || '.' || EXTRACT(YEAR FROM
                                                                                                                                                                                    to_timestamp(qas.timecreated+3600)) || ' ' || lpad(EXTRACT(HOUR FROM to_timestamp(qas.timecreated+3600))::text, 2, '0') || ':' || lpad(EXTRACT(MINUTE FROM to_timestamp(qas.timecreated+3600))::text, 2,
                                                                                                                                                                                                                                                                                                                           '0') || ':' || lpad(EXTRACT(SECOND FROM to_timestamp(qas.timecreated+3600))::text, 2, '0') "qastepcreatedstring",
    qasd.name AS "questionattemptstepdataname",
    qasd.value AS "questionattemptstepdatavalue",
    qzat.id AS "quizattemptsid",
    qzat.uniqueid AS "quizattemptsuniqueid",
    qz.id AS "quizid", -- the quiz id.
    qz.name AS "quizname", -- the quiz name.
    qz.grade AS "quizgrade", -- the quiz maximum grade.
    qzfb.feedbacktext, -- the quiz feedback.
    qzfb.feedbacktextformat, -- the quiz feedback text format.
    qzfb.mingrade AS "feedbackmingrade", -- the quiz feedback min grade.
    qzfb.maxgrade AS "feedbackmaxgrade", -- the quiz feedback max grade.
    c.id AS "courseid",
    cm.id AS "coursemodulesid",
    m.name AS "modulename",
    (SELECT MD5(username) FROM {user} WHERE id = qzat.userid) AS "qzatuserid",
    uid.data AS "userinfodata"

FROM {question} qn
LEFT JOIN {question_answers} qna
ON qn.id = qna.question
    LEFT JOIN {qtype_kprime_weights} qtkprimew
    ON qn.id=qtkprimew.questionid
    LEFT JOIN {qtype_kprime_rows} qtkprimer
    ON qn.id=qtkprimer.questionid AND qtkprimer.number=qtkprimew.rownumber
    LEFT JOIN {qtype_kprime_columns} qtkprimec
    ON qn.id=qtkprimec.questionid AND qtkprimec.number=qtkprimew.columnnumber
    LEFT JOIN {question_versions} qnv
    ON qn.id = qnv.questionid
    LEFT JOIN {question_bank_entries} qbe
    ON qbe.id = qnv.questionbankentryid
    LEFT JOIN {question_references} qnr
    ON qbe.id = qnr.questionbankentryid AND qnr.version = qnv.version
    LEFT JOIN {question_categories} qc
    ON qbe.questioncategoryid = qc.id
    LEFT JOIN {question_statistics} qs
    ON qn.id = qs.questionid
    LEFT JOIN {user} u
    ON qbe.ownerid = u.id
    LEFT JOIN {context} ctx
    ON qnr.usingcontextid = ctx.id
    LEFT JOIN {question_attempts} qnat
    ON (qn.id = qnat.questionid OR qn.parent = qnat.questionid)
    LEFT JOIN {question_attempt_steps} qas
    ON qnat.id = qas.questionattemptid
    LEFT JOIN {question_attempt_step_data} qasd
    ON qas.id = qasd.attemptstepid
    LEFT JOIN {quiz_attempts} qzat
    ON qzat.uniqueid = qnat.questionusageid
    LEFT JOIN {quiz} qz
    ON qz.id = qzat.quiz
    LEFT JOIN {quiz_feedback} qzfb
    ON qz.id = qzfb.quizid
    LEFT JOIN {course} c
    ON c.id = qz.course
    LEFT JOIN {course_modules} cm
    ON cm.course = c.id AND cm.instance = qz.id
    LEFT JOIN {modules} m
    ON cm.module = m.id AND m.name = 'quiz'
    LEFT JOIN {user_info_data} uid
    ON u.id = uid.userid
    LEFT JOIN {user_info_field} uif
    ON uif.id = uid.fieldid AND uif.shortname = 'analytics'

WHERE cm.course=%%COURSEID%% AND cm.id = %%CMID%% AND((uid.data IS NULL) OR (uid.data !='1'))
