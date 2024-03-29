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

namespace report_datawarehouse\output;

use context;
use moodle_url;
use renderable;
use templatable;
use renderer_base;
use report_datawarehouse\utils;
use report_datawarehouse\local\query_category as local_query_category;
use report_datawarehouse\local\backend_category as local_backend_category;
use report_datawarehouse\output\query_category;

/**
 * Index page renderable class.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class index_page implements renderable, templatable {
    /** @var array Query querycategories' data. */
    private $querycategories;

    /** @var array Backend querycategories' data. */
    private $backendcategories;

    /** @var array Queries' data. */
    private $queries;

    /** @var array Backends' data. */
    private $backends;

    /** @var array Runs' data. */
    private $runs;

    /** @var context Context to check the capability. */
    private $context;

    /** @var moodle_url Return url for edit/delete link. */
    private $returnurl;

    /** @var int Shown query_category id from optional param. */
    private $showquerycat;

    /** @var int Hidden query_category id from optional param. */
    private $hidequerycat;

    /** @var int Shown backend_category id from optional param. */
    private $showbackendcat;

    /** @var int Hidden backend_category id from optional param. */
    private $hidebackendcat;

    /** Build the index page renderable object.
     *
     * @param array $querycategories Query categories for renderer.
     * @param array $backendcategories Query categories for renderer.
     * @param array $queries Queries for renderer.
     * @param array $backends Backends for renderer.
     * @param array $runs Runs for renderer.
     * @param context $context Context to check the capability.
     * @param moodle_url $returnurl Return url for edit/delete link.
     * @param int $showquerycat Showing Query category Id.
     * @param int $hidequerycat Hiding Query category Id.
     * @param int $showbackendcat Showing Backend category Id.
     * @param int $hidebackendcat Hiding Backend category Id.
     */
    public function __construct(array $querycategories, array $backendcategories, array $queries, array $backends, array $runs,
        context $context, moodle_url $returnurl, int $showquerycat = 0, int $hidequerycat = 0, int $showbackendcat = 0,
        int $hidebackendcat = 0) {
        $this->querycategories = $querycategories;
        $this->backendcategories = $backendcategories;
        $this->queries = $queries;
        $this->backends = $backends;
        $this->runs = $runs;
        $this->context = $context;
        $this->returnurl = $returnurl;
        $this->showquerycat = $showquerycat;
        $this->hidequerycat = $hidequerycat;
        $this->showbackendcat = $showbackendcat;
        $this->hidebackendcat = $hidebackendcat;
    }

    /**
     * Export the data so it can be used as the context for a mustache template.
     *
     * @param renderer_base $output The renderer base
     * @return array The data to be passed to mustache
     * @throws \coding_exception
     */
    public function export_for_template(renderer_base $output) {
        $querycategoriesdata = [];
        $groupedqueries = $this->queries;
        foreach ($groupedqueries as $queries) {
            $queries->inuse = report_datawarehouse_get_query_used_by_id($queries->id);
            $querycategoriesdata[] = $queries;
        }

        $backendcategoriesdata = [];
        $groupedbackends = $this->backends;
        foreach ($groupedbackends as $backends) {
            $backends->inuse = report_datawarehouse_get_backend_used_by_id($backends->id);
            $backendcategoriesdata[] = $backends;
        }

        $runcategoriesdata = [];
        $groupedruns = $this->runs;
        foreach ($groupedruns as $runs) {
            $runs->queryname = report_datawarehouse_get_query_name_by_id($runs->queryid);
            $runs->backendname = report_datawarehouse_get_backend_name_by_id($runs->backendid);
            if ($runs->lastrun == 0) {
                $runs->lastrunstring = get_string('never');
            } else {
                $runs->lastrunstring = userdate($runs->lastrun, '%d %b %Y %T');
            }
            $runcategoriesdata[] = $runs;
        }
        $addquerybutton = '';
        if (has_capability('report/datawarehouse:managequeries', $this->context)) {
            $addquerybutton = $output->single_button(report_datawarehouse_url('query.php', ['returnurl' => $this->returnurl]),
                get_string('addquery', 'report_datawarehouse'), 'post', ['class' => 'mt-1 mb-3']);
        }
        $addbackendbutton = '';
        if (has_capability('report/datawarehouse:managebackends', $this->context)) {
            $addbackendbutton =
                $output->single_button(report_datawarehouse_url('backend.php', ['returnurl' => $this->returnurl]),
                    get_string('addbackend', 'report_datawarehouse'), 'post', ['class' => 'mt-1 mb-3']);
        }
        $addrunbutton = '';
        if (has_capability('report/datawarehouse:manageruns', $this->context)) {
            $addrunbutton =
                $output->single_button(report_datawarehouse_url('run.php', ['returnurl' => $this->returnurl]),
                    get_string('addrun', 'report_datawarehouse'), 'post', ['class' => 'mt-1 mb-3']);
        }
        // phpcs:disable
        /*
                if (has_capability('report/customsql:managecategories', $this->context)) {
                    $managecategorybutton = $output->single_button(report_customsql_url('manage.php'),
                        get_string('managecategories', 'report_customsql'));
                }
        */
        // phpcs:enable

        $allowmanagequeries = false;
        if (has_capability('report/datawarehouse:managequeries', \context_system::instance())) {
            $allowmanagequeries = true;
        }
        $allowmanagebackends = false;
        if (has_capability('report/datawarehouse:managebackends', \context_system::instance())) {
            $allowmanagebackends = true;
        }
        $allowmanageruns = false;
        if (has_capability('report/datawarehouse:manageruns', \context_system::instance())) {
            $allowmanageruns = true;
        }

        $data = [
            'addquerybutton' => $addquerybutton,
            'addbackendbutton' => $addbackendbutton,
            'addrunbutton' => $addrunbutton,
            'queries' => (array) $querycategoriesdata,
            'backends' => (array) $backendcategoriesdata,
            'runs' => (array) $runcategoriesdata,
            'sesskey' => sesskey(),
            'allowmanagequeries' => $allowmanagequeries,
            'allowmanagebackends' => $allowmanagebackends,
            'allowmanageruns' => $allowmanageruns,
        ];
        return $data;
    }
}
