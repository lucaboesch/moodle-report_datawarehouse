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
use report_datawarehouse\local\query_category as report_category;

/**
 * Backend renderable class.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class backend implements renderable, templatable {
    /** @var report_category Category object. */
    private $category;

    /** @var context Context. */
    private $context;

    /** @var int Shown query_category id from optional param. */
    private $showcat;

    /** @var int Hidden query_category id from optional param. */
    private $hidecat;

    /** @var bool Do we show the 'Show only' link? */
    private $showonlythislink;

    /** @var bool Can the query_category expanse/collapse? */
    private $expandable;

    /** @var moodle_url Return url. */
    private $returnurl;

    /** @var bool Show 'Add new backend' button or not. */
    private $addnewbackendbtn;

    /** Create the query_category renderable object.
     *
     * @param report_category $category Category object.
     * @param context $context Context to check the permission.
     * @param bool $expandable Can the query_category expanse/collapse?
     * @param int $showcat Shown query_category id from optional param
     * @param int $hidecat Hidden query_category id from optional param
     * @param bool $showonlythislink Do we show the 'Show only' link?
     * @param bool $addnewbackendbtn Show 'Add new backend' button or not.
     * @param moodle_url|null $returnurl Return url.
     */
    public function __construct(report_category $category, context $context, bool $expandable = false, int $showcat = 0,
            int $hidecat = 0, bool $showonlythislink = false, bool $addnewbackendbtn = true, moodle_url $returnurl = null) {
        $this->category = $category;
        $this->context = $context;
        $this->expandable = $expandable;
        $this->showcat = $showcat;
        $this->hidecat = $hidecat;
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

        $backendsdata = $this->category->get_backends_data();

        $backendgroups = [];
        foreach ($backendsdata as $backendgroup) {
            $backends = [];
            foreach ($backendgroup['queries'] as $backenddata) {
                $backend = new report_backend($backenddata);
                if (!$backend->can_view($this->context)) {
                    continue;
                }
                $backendwidget = new category_query($backend, $this->category, $this->context, $this->returnurl);
                $backends[] = ['categorybackenditem' => $output->render($backendwidget)];
            }

            $backendgroups[] = [
                'type' => $backendgroup['type'],
                'title' => get_string($backendgroup['type'] . 'header', 'report_datawarehouse'),
                'helpicon' => $output->help_icon($backendgroup['type'] . 'header', 'report_datawarehouse'),
                'backends' => $backends
            ];
        }

        $addbackendbutton = '';
        if ($this->addbackendbutton && has_capability('report/datawarehouse:managebackends', $this->context)) {
            $addnewbackendurl = report_datawarehouse_url('editbackend.php', ['categoryid' => $this->category->get_id(),
                'returnurl' => $this->returnurl->out_as_local_url(false)]);
            $addbackendbutton = $output->single_button($addnewbackendurl, get_string('addbackend', 'report_datawarehouse'), 'post',
                                        ['class' => 'mb-1']);
        }

        return [
            'id' => $this->category->get_id(),
            'name' => $this->category->get_name(),
            'expandable' => $this->expandable,
            'show' => $this->get_showing_state(),
            'showonlythislink' => $this->showonlythislink,
            'url' => $this->category->get_url()->out(false),
            'linkref' => $this->get_link_reference(),
            'statistic' => $this->category->get_statistic(),
            'backendgroups' => $backendgroups,
            'addbackendbutton' => $addbackendbutton
        ];
    }

    /**
     * Get showing state of query_category. Default is hidden.
     *
     * @return string
     */
    private function get_showing_state(): string {
        $categoryid = $this->category->get_id();

        return $categoryid == $this->showcat && $categoryid != $this->hidecat ? 'shown' : 'hidden';
    }

    /**
     * Get the link with showcat/hidecat parameter.
     *
     * @return string The url.
     */
    private function get_link_reference(): string {
        $categoryid = $this->category->get_id();
        if ($categoryid == $this->showcat) {
            $params = ['hidecat' => $categoryid];
        } else {
            $params = ['showcat' => $categoryid];
        }

        return report_datawarehouse_url('index.php', $params)->out(false);
    }
}
