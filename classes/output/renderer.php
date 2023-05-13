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
use html_writer;
use moodle_url;
use plugin_renderer_base;
use stdClass;

/**
 * Data warehouse report queries renderer class.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class renderer extends plugin_renderer_base {

    /**
     * Output the standard action icons (edit, delete and back to list) for a report.
     *
     * @param stdClass $report the report.
     * @param stdClass $category Category object.
     * @param context $context context to use for permission checks.
     * @return string HTML for report actions.
     * @throws \coding_exception
     * @throws \moodle_exception
     */
    public function render_report_actions(stdClass $report, stdClass $category, context $context):string {
        if (has_capability('report/customsql:definequeries', $context)) {
            $reporturl = report_datawarehouse_url('view.php', ['id' => $report->id]);
            $editaction = $this->action_link(
                report_datawarehouse_url('edit.php', ['id' => $report->id, 'returnurl' => $reporturl->out_as_local_url(false)]),
                $this->pix_icon('t/edit', '') . ' ' .
                get_string('editreportx', 'report_datawarehouse', format_string($report->displayname)));
            $deleteaction = $this->action_link(
                report_datawarehouse_url('delete.php', ['id' => $report->id, 'returnurl' => $reporturl->out_as_local_url(false)]),
                $this->pix_icon('t/delete', '') . ' ' .
                get_string('deletereportx', 'report_datawarehouse', format_string($report->displayname)));
        }

        $backtocategoryaction = $this->action_link(
            report_datawarehouse_url('query_category.php', ['id' => $category->id]),
            $this->pix_icon('t/left', '') .
            get_string('backtocategory', 'report_datawarehouse', $category->name));

        $context = [
            'editaction' => $editaction,
            'deleteaction' => $deleteaction,
            'backtocategoryaction' => $backtocategoryaction
        ];

        return $this->render_from_template('report_datawarehouse/query_actions', $context);
    }
}
