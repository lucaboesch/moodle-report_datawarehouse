<?php
/*// This file is part of Moodle - http://moodle.org/
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
use report_datawarehouse\local\query as report_query;
use report_datawarehouse\local\query_category as report_category;

/**
 * Query renderable class.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class query implements renderable, templatable {
    /** @var query_category Category object. */
    private $querycategory;

    /** @var context Context. */
    private $context;

    /** @var int Shown query_category id from optional param. */
    private $showquerycat;

    /** @var int Hidden query_category id from optional param. */
    private $hidequerycat;

    /** @var bool Do we show the 'Show only' link? */
    private $showonlythislink;

    /** @var bool Can the query_category expanse/collapse? */
    private $expandable;

    /** @var moodle_url Return url. */
    private $returnurl;

    /** @var bool Show 'Add new query' button or not. */
    private $addnewquerybtn;

    /** Create the query_category renderable object.
     *
     * @param query_category $querycategory Category object.
     * @param context $context Context to check the permission.
     * @param bool $expandable Can the query_category expanse/collapse?
     * @param int $showquerycat Shown query_category id from optional param
     * @param int $hidequerycat Hidden query_category id from optional param
     * @param bool $showonlythislink Do we show the 'Show only' link?
     * @param bool $addnewquerybtn Show 'Add new query' button or not.
     * @param moodle_url|null $returnurl Return url.
     */
/*    public function __construct(query_category $querycategory, context $context, bool $expandable = false, int $showquerycat = 0,
            int $hidequerycat = 0, bool $showonlythislink = false, bool $addnewquerybtn = true, moodle_url $returnurl = null) {
        $this->querycategory = $querycategory;
        $this->context = $context;
        $this->expandable = $expandable;
        $this->showquerycat = $showquerycat;
        $this->hidequerycat = $hidequerycat;
        $this->showonlythislink = $showonlythislink;
        $this->addnewquerybtn = $addnewquerybtn;
        $this->returnurl = $returnurl ?? $this->category->get_url();
    }*/

    /**
     * Export the data so it can be used as the context for a mustache template.
     *
     * @param renderer_base $output The renderer base
     * @return array The data to be passed to mustache
     * @throws \coding_exception
     */
/*    public function export_for_template(renderer_base $output) {
        $queriesdata = $this->category->get_queries_data();

        $querygroups = [];
        foreach ($queriesdata as $querygroup) {
            $queries = [];
            foreach ($querygroup['queries'] as $querydata) {
                $query = new report_query($querydata);
                if (!$query->can_view($this->context)) {
                    continue;
                }
                $querywidget = new category_query($query, $this->category, $this->context, $this->returnurl);
                $queries[] = ['categoryqueryitem' => $output->render($querywidget)];
            }

            $querygroups[] = [
                'type' => $querygroup['type'],
                'title' => get_string($querygroup['type'] . 'header', 'report_datawarehouse'),
                'helpicon' => $output->help_icon($querygroup['type'] . 'header', 'report_datawarehouse'),
                'queries' => $queries
            ];
        }

        $addquerybutton = '';
        if ($this->addnewquerybtn && has_capability('report/datawarehouse:definequeries', $this->context)) {
            $addnewqueryurl = report_datawarehouse_url('edit.php', ['categoryid' => $this->category->get_id(),
                'returnurl' => $this->returnurl->out_as_local_url(false)]);
            $addquerybutton = $output->single_button($addnewqueryurl, get_string('addreport', 'report_datawarehouse'), 'post',
                                        ['class' => 'mt-1 mb-3']);
        }

        return [
            'id' => $this->querycategory->get_id(),
            'name' => $this->querycategory->get_name(),
            'expandable' => $this->expandable,
            'show' => $this->get_showing_state(),
            'showonlythislink' => $this->showonlythislink,
            'url' => $this->querycategory->get_url()->out(false),
            'linkref' => $this->get_link_reference(),
            'statistic' => $this->querycategory->get_statistic(),
            'querygroups' => $querygroups,
            'addquerybutton' => $addquerybutton,
            'sesskey' => sesskey(),
        ];
    }*/

    /**
     * Get showing state of query_category. Default is hidden.
     *
     * @return string
     */
/*
    private function get_showing_state(): string {
        $categoryid = $this->querycategory->get_id();

        return $querycategoryid == $this->showquerycat && $categoryid != $this->hidequerycat ? 'shown' : 'hidden';
    }
*/

    /**
     * Get the link with showcat/hidecat parameter.
     *
     * @return string The url.
     */
/*
     private function get_link_reference(): string {
        $categoryid = $this->category->get_id();
        if ($categoryid == $this->showcat) {
            $params = ['hidecat' => $categoryid];
        } else {
            $params = ['showcat' => $categoryid];
        }

        return report_datawarehouse_url('index.php', $params)->out(false);
    }
*/
}
