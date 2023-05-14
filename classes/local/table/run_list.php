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
 * Runs table.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse\local\table;

use report_datawarehouse\helper;
use report_datawarehouse\run;
use report_datawarehouse\run_controller;

defined('MOODLE_INTERNAL') || die();

require_once($CFG->libdir.'/tablelib.php');

/**
 * Runs table.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class run_list extends \flexible_table {

    /**
     * @var int Autogenerated id.
     */
    private static $autoid = 0;

    /**
     * Constructor
     *
     * @param string|null $id to be used by the table, autogenerated if null.
     */
    public function __construct($id = null) {
        global $PAGE;

        $id = (is_null($id) ? self::$autoid++ : $id);
        parent::__construct('report_datawarehouse' . $id);

        $this->define_baseurl($PAGE->url);
        $this->set_attribute('class', 'generaltable admintable');

        // Column definition.
        $this->define_columns([
            'query',
            'backend',
            'courseid',
            'cmid',
            'actions',
        ]);

        $this->define_headers([
            get_string('query', 'report_datawarehouse'),
            get_string('backend', 'report_datawarehouse'),
            get_string('courseid', 'report_datawarehouse'),
            get_string('cmid', 'report_datawarehouse'),
            get_string('actions'),
        ]);

        $this->setup();
    }

    /**
     * Display name column.
     *
     * @param \report_datawarehouse\run $data Query for this row.
     * @return string
     */
    protected function col_name(run $data) : string {
        return \html_writer::link(
            new \moodle_url(run_controller::get_base_url(), [
                'id' => $data->get('id'),
                'action' => run_controller::ACTION_EDIT,
            ]),
            $data->get('name')
        );
    }

    /**
     * Display description column.
     *
     * @param \report_datawarehouse\run $data Query for this row.
     * @return string
     */
    protected function col_description(run $data) : string {
        return $data->get('description');
    }

    /**
     * Display enabled column.
     *
     * @param \report_datawarehouse\run $data Query for this row.
     * @return string
     */
    protected function col_enabled(run $data): string {
        return empty($data->get('enabled')) ? get_string('no') : get_string('yes');
    }

    /**
     * Display if a run is being used.
     *
     * @param \report_datawarehouse\run $data Query for this row.
     * @return string
     */
    protected function col_used(run $data): string {
        return $data->can_delete() ? get_string('no') : get_string('yes');
    }

    /**
     * Display actions column.
     *
     * @param \report_datawarehouse\run $data Query for this row.
     * @return string
     */
    protected function col_actions(run $data) : string {
        $actions = [];

        $actions[] = helper::format_icon_link(
            new \moodle_url(run_controller::get_base_url(), [
                'id'        => $data->get('id'),
                'action'    => run_controller::ACTION_EDIT,
            ]),
            't/edit',
            get_string('edit')
        );

        $actions[] = helper::format_icon_link(
            new \moodle_url(run_controller::get_base_url(), [
                'id'        => $data->get('id'),
                'action'    => run_controller::ACTION_DELETE,
                'sesskey'   => sesskey(),
            ]),
            't/delete',
            get_string('delete'),
            null,
            [
            'data-action' => 'delete',
            'data-id' => $data->get('id'),
            ]
        );

        return implode('&nbsp;', $actions);
    }

    /**
     * Sets the data of the table.
     *
     * @param \report_datawarehouse\run[] $records An array with records.
     */
    public function display(array $records) {
        foreach ($records as $record) {
            $this->add_data_keyed($this->format_row($record));
        }

        $this->finish_output();
    }

}
