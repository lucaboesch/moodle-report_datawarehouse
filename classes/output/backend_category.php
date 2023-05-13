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
use report_datawarehouse\local\backend as report_backend;
use report_datawarehouse\local\backend_category as report_category;

/**
 * Backend category renderable class.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class backend_category implements renderable, templatable {
    /** @var \report_datawarehouse\local\backend_category Category object. */
    private $backendcategory;

    /** @var context Context. */
    private $context;

    /** @var int Shown backend_category id from optional param. */
    private $showbackendcat;

    /** @var int Hidden backend_category id from optional param. */
    private $hidebackendcat;

    /** @var bool Do we show the 'Show only' link? */
    private $showonlythislink;

    /** @var bool Can the backend_category expanse/collapse? */
    private $expandable;

    /** @var moodle_url Return url. */
    private $returnurl;

    /** @var bool Show 'Add new backend' button or not. */
    private $addnewbackendbtn;

    /** Create the backend_category renderable object.
     *
     * @param backend_category $backendcategory Category object.
     * @param context $context Context to check the permission.
     * @param bool $expandable Can the backend_category expanse/collapse?
     * @param int $showbackendcat Shown backend_category id from optional param
     * @param int $hidebackendcat Hidden backend_category id from optional param
     * @param bool $showonlythislink Do we show the 'Show only' link?
     * @param bool $addnewbackendbtn Show 'Add new backend' button or not.
     * @param moodle_url|null $returnurl Return url.
     */
    public function __construct(\report_datawarehouse\local\backend_category $backendcategory, context $context,
        bool $expandable = false, int $showbackendcat = 0, int $hidebackendcat = 0, bool $showonlythislink = false,
        bool $addnewbackendbtn = true, moodle_url $returnurl = null) {
        $this->backendcategory = $backendcategory;
        $this->context = $context;
        $this->expandable = $expandable;
        $this->showbackendcat = $showbackendcat;
        $this->hidebackendcat = $hidebackendcat;
        $this->showonlythislink = $showonlythislink;
        $this->addnewbackendbtn = $addnewbackendbtn;
        $this->returnurl = $returnurl ?? $this->category->get_url();
    }

    /**
     * Export the data so it can be used as the context for a mustache template.
     *
     * @param renderer_base $output The renderer base
     * @return array The data to be passed to mustache
     * @throws \coding_exception
     */
    public function export_for_template(renderer_base $output) {

        $queriesdata = $this->backendcategory->get_backends_data();

        $backendgroups = [];
        foreach ($queriesdata as $backendgroup) {
            $queries = [];
            foreach ($backendgroup['queries'] as $backenddata) {
                $backend = new report_backend($backenddata);
                if (!$backend->can_view($this->context)) {
                    continue;
                }
                $backendwidget = new category_backend($backend, $this->category, $this->context, $this->returnurl);
                $queries[] = ['categorybackenditem' => $output->render($backendwidget)];
            }

            $backendgroups[] = [
                'type' => $backendgroup['type'],
                'title' => get_string($backendgroup['type'] . 'header', 'report_datawarehouse'),
                'helpicon' => $output->help_icon($backendgroup['type'] . 'header', 'report_datawarehouse'),
                'queries' => $queries
            ];
        }

        // phpcs:disable
        /*
                $addbackendbutton = '';
                if ($this->addnewbackendbtn && has_capability('report/customsql:definequeries', $this->context)) {
                    $addnewbackendurl = report_datawarehouse_url('edit.php', ['categoryid' => $this->category->get_id(),
                        'returnurl' => $this->returnurl->out_as_local_url(false)]);
                    $addbackendbutton = $output->single_button($addnewbackendurl, get_string('addreport', 'report_datawarehouse'), 'post',
                                                ['class' => 'mb-1']);
                }
        */
        // phpcs:enable

        return [
            'id' => $this->backendcategory->get_id(),
            'name' => $this->backendcategory->get_name(),
            'expandable' => $this->expandable,
            'show' => $this->get_showing_state(),
            'showonlythislink' => $this->showonlythislink,
            'url' => $this->backendcategory->get_url()->out(false),
            'linkref' => $this->get_link_reference(),
            'statistic' => $this->backendcategory->get_statistic(),
            'backendgroups' => $backendgroups,
            'addbackendbutton' => $addbackendbutton
        ];
    }

    /**
     * Get showing state of backend_category. Default is hidden.
     *
     * @return string
     */
    private function get_showing_state(): string {
        $categoryid = $this->backendcategory->get_id();

        return $categoryid == $this->showbackendcat && $categoryid != $this->hidebackendcat ? 'shown' : 'hidden';
    }

    /**
     * Get the link with showcat/hidecat parameter.
     *
     * @return string The url.
     */
    private function get_link_reference(): string {
        $categoryid = $this->backendcategory->get_id();
        if ($categoryid == $this->showbackendcat) {
            $params = ['hidebackendcat' => $categoryid];
        } else {
            $params = ['showbackendcat' => $categoryid];
        }

        return report_datawarehouse_url('index.php', $params)->out(false);
    }
}
