<?php
// This file is part of Moodle - http://moodle.org/
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
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Data warehouse report.
 *
 * Users with the report/datawarehouse:definequeries capability can enter custom
 * SQL SELECT statements. If they have report/datawarehouse:managecategories
 * capability can create custom categories for the sql reports.
 * Other users with the moodle/site:viewreports capability
 * can see the list of available queries and run them. Reports are displayed as
 * a table. Every data value is a string, and field names come from the database
 * results set.
 *
 * This page shows the list of categorised queries, with edit icons, an add new button
 * if you have the report/datawarehouse:definequeries capability, and a manage categories button
 * if you have report/datawarehouse:managecategories capability
 *
 * @package     report_datawarehouse
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require_once(dirname(__FILE__) . '/../../config.php');
require_once(dirname(__FILE__) . '/locallib.php');
require_once($CFG->libdir . '/adminlib.php');

// Start the page.
admin_externalpage_setup('report_datawarehouse');
$context = context_system::instance();
require_capability('report/datawarehouse:view', $context);

$querycategories = $DB->get_records('report_datawarehouse_q_cats', null, 'name, id');
$backendcategories = $DB->get_records('report_datawarehouse_b_cats', null, 'name, id');
// This are just dummy categories. This feature is not yet used.
$querycategories[0] = new \stdClass();
$querycategories[0]->id = 1;
$querycategories[0]->name = 'Dummy category';
$backendcategories[0] = new \stdClass();
$backendcategories[0]->id = 1;
$backendcategories[0]->name = 'Dummy category';
$queries = $DB->get_records('report_datawarehouse_queries', null, 'sortorder');
$backends = $DB->get_records('report_datawarehouse_bkends', null, 'sortorder');
$runs = $DB->get_records('report_datawarehouse_runs', null, 'sortorder');
$showquerycat = optional_param('showquerycat', 0, PARAM_INT);
$hidequerycat = optional_param('hidequerycat', 0, PARAM_INT);
$showbackendcat = optional_param('showbackendcat', 0, PARAM_INT);
$hidebackendcat = optional_param('hidebackendcat', 0, PARAM_INT);
$returnurl = report_datawarehouse_url('index.php');

$widget = new \report_datawarehouse\output\index_page($querycategories, $backendcategories, $queries, $backends, $runs, $context,
    $returnurl, $showquerycat, $hidequerycat, $showbackendcat, $hidebackendcat);
$output = $PAGE->get_renderer('report_datawarehouse');

echo $OUTPUT->header();

echo $output->render($widget);

echo $OUTPUT->footer();
