<?php
// This file is part of Moodle - https://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <https://www.gnu.org/licenses/>.

/**
 * Plugin strings are defined here.
 *
 * @package     report_datawarehouse
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();

$string['addbackend'] = 'Add new backend';
$string['addquery'] = 'Add new query';
$string['addrun'] = 'Add new run';
$string['alloweduser'] = 'Allowed user';
$string['availablebackends'] = 'Available backends';
$string['availablequeries'] = 'Available queries';
$string['availableruns'] = 'Available runs';
$string['backend'] = 'Backend';
$string['backenddeleted'] = 'The data warehouse report backend has successfully been deleted';
$string['cantdeletebackend'] = 'The backend can\'t be deleted.';
$string['cantdeletequery'] = 'The query can\'t be deleted.';
$string['canteditbackend'] = 'The backend can\'t be edited.';
$string['canteditquery'] = 'The query can\'t be edited.';
$string['canteditrun'] = 'The run can\'t be edited.';
$string['categorycontent'] = '({$a->manual} on-demand, {$a->daily} daily, {$a->weekly} weekly, {$a->monthly} monthly)';
$string['confirmbackendremovalquestion'] = 'Are you sure you want to remove this backend?';
$string['confirmqueryremovalquestion'] = 'Are you sure you want to remove this query?';
$string['confirmrunremovalquestion'] = 'Are you sure you want to remove this run?';
$string['confirmbackendremovaltitle'] = 'Confirm backend removal?';
$string['confirmqueryremovaltitle'] = 'Confirm query removal?';
$string['confirmrunremovaltitle'] = 'Confirm run removal?';
$string['courseid'] = 'Course ID';
$string['coursemoduleid'] = 'Course module ID';
$string['datawarehouse:managebackends'] = 'Manage data warehouse report backends';
$string['datawarehouse:managequeries'] = 'Manage data warehouse report queries';
$string['datawarehouse:manageruns'] = 'Manage data warehouse report runs';
$string['datawarehouse:view'] = 'View a data warehouse report file';
$string['datawarehouse:viewfiles'] = 'View data warehouse report files overview';
$string['description'] = 'Description';
$string['editbackend'] = 'Edit backend';
$string['editquery'] = 'Edit query';
$string['editrun'] = 'Edit run';
$string['event:backendcreated'] = 'Data warehouse report backend was created';
$string['event:backenddeleted'] = 'Data warehouse report backend was deleted';
$string['event:backenddisabled'] = 'Data warehouse report backend was disabled';
$string['event:backendenabled'] = 'Data warehouse report backend was enabled';
$string['event:backendupdated'] = 'Data warehouse report backend was updated';
$string['event:querycreated'] = 'Data warehouse report query was created';
$string['event:querydeleted'] = 'Data warehouse report query was deleted';
$string['event:querydisabled'] = 'Data warehouse report query was disabled';
$string['event:queryenabled'] = 'Data warehouse report query was enabled';
$string['event:queryupdated'] = 'Data warehouse report query was updated';
$string['event:runcreated'] = 'Data warehouse report run was created';
$string['event:rundeleted'] = 'Data warehouse report run was deleted';
$string['event:rundisabled'] = 'Data warehouse report run was disabled';
$string['event:runenabled'] = 'Data warehouse report run was enabled';
$string['event:runupdated'] = 'Data warehouse report run was updated';
$string['enabled'] = 'Enabled';
$string['lastrun'] = 'Last run';
$string['name'] = 'Name';
$string['note'] = 'Notes';
$string['nobackendsavailable'] = 'No backends available';
$string['noqueriesavailable'] = 'No queries available';
$string['norunsavailable'] = 'No runs available';
$string['namerequired'] = 'A name is required';
$string['newbackend'] = 'New backend';
$string['newquery'] = 'New query';
$string['newrun'] = 'New run';
$string['password'] = 'Password';
$string['pluginname'] = 'Data warehouse reports';
$string['query'] = 'Query';
$string['querydeleted'] = 'The data warehouse report query has successfully been deleted';
$string['querynote'] = '<ul>
<li>The token <code>%%COURSEID%%</code> in the query will be replaced with the course id of the course the report is called in, before the query is executed. The same happens with <code>%%CMID%%</code> that will be replaced with the course module id.</li>
<li>The query must include <code>WHERE cm.course=%%COURSEID%% AND cm.id = %%CMID%% AND ((uid.data IS NULL) OR (uid.data !=\'1\'))</code> at the end, whereas the uid.data value comes from an user_info_data field of which a value of 1 expresses that the user opts out of analytics.</li>
<li>You cannot use the characters <code>:</code>, <code>;</code> or <code>?</code> in strings in your query.<ul>
    <li>If you need them in output data (such as when outputting URLs), you can use the tokens <code>%%C%%</code>, <code>%%S%%</code> and <code>%%Q%%</code> respectively.</li>
    <li>If you need them in input data (such as in a regular expression or when querying for the characters), you will need to use a database function to get the characters and concatenate them yourself. In Postgres, respectively these are CHR(58), CHR(59) and CHR(63); in MySQL CHAR(58), CHAR(59) and CHAR(63).</li>
</ul></li>
</ul>';
$string['querysql'] = 'Query';
$string['rundeleted'] = 'The data warehouse report run has successfully been deleted';
$string['runnow'] = 'Run now';
$string['runsnote'] = '<div class="mb-6"><br>Combine a prepared query and backend with a course module (a quiz, an assignment etc.) and a course for which the run should be executed.</br>
The course module and the course field have no chooser on purpose, look up the values in the URL or the breadcrumb/course/secondary navigation.</p></div>';
$string['showonlythiscategory'] = 'Show only {$a}';
$string['url'] = 'URL';
$string['used'] = 'In use';
$string['username'] = 'Username';
