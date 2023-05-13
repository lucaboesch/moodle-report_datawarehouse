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
 * Queries table.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse\local\table;

use report_datawarehouse\helper;
use report_datawarehouse\query;
use report_datawarehouse\query_controller;

defined('MOODLE_INTERNAL') || die();

require_once($CFG->libdir.'/tablelib.php');

/**
 * Queries table.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class query_list extends \flexible_table {

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
            'name',
            'description',
            'enabled',
            'used',
            'actions',
        ]);

        $this->define_headers([
            get_string('name', 'report_datawarehouse'),
            get_string('description', 'report_datawarehouse'),
            get_string('enabled', 'report_datawarehouse'),
            get_string('used', 'report_datawarehouse'),
            get_string('actions'),
        ]);

        $this->setup();
    }

    /**
     * Display name column.
     *
     * @param \report_datawarehouse\query $data Query for this row.
     * @return string
     */
    protected function col_name(query $data) : string {
        return \html_writer::link(
            new \moodle_url(query_controller::get_base_url(), [
                'id' => $data->get('id'),
                'action' => query_controller::ACTION_EDIT,
            ]),
            $data->get('name')
        );
    }

    /**
     * Display description column.
     *
     * @param \report_datawarehouse\query $data Query for this row.
     * @return string
     */
    protected function col_description(query $data) : string {
        return $data->get('description');
    }

    /**
     * Display enabled column.
     *
     * @param \report_datawarehouse\query $data Query for this row.
     * @return string
     */
    protected function col_enabled(query $data): string {
        return empty($data->get('enabled')) ? get_string('no') : get_string('yes');
    }

    /**
     * Display if a query is being used.
     *
     * @param \report_datawarehouse\query $data Query for this row.
     * @return string
     */
    protected function col_used(query $data): string {
        return $data->can_delete() ? get_string('no') : get_string('yes');
    }

    /**
     * Display actions column.
     *
     * @param \report_datawarehouse\query $data Query for this row.
     * @return string
     */
    protected function col_actions(query $data) : string {
        $actions = [];

        $actions[] = helper::format_icon_link(
            new \moodle_url(query_controller::get_base_url(), [
                'id'        => $data->get('id'),
                'action'    => query_controller::ACTION_EDIT,
            ]),
            't/edit',
            get_string('edit')
        );

        $actions[] = helper::format_icon_link(
            new \moodle_url(query_controller::get_base_url(), [
                'id'        => $data->get('id'),
                'action'    => query_controller::ACTION_DELETE,
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
     * @param \report_datawarehouse\query[] $records An array with records.
     */
    public function display(array $records) {
        foreach ($records as $record) {
            $this->add_data_keyed($this->format_row($record));
        }

        $this->finish_output();
    }

}
