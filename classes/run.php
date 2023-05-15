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
 * Entity model representing run settings for the data warehouse report.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse;

use core\persistent;

/**
 * Entity model representing run settings for the data warehouse report.
 *
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class run extends persistent {

    /** Table name for the persistent. */
    const TABLE = 'report_datawarehouse_runs';

    /**
     * Return the definition of the properties of this model.
     *
     * @return array
     */
    protected static function define_properties() {
        return [
            'queryid' => [
                'type' => PARAM_INT,
                'default' => '',
            ],
            'backendid' => [
                'type' => PARAM_INT,
                'default' => '',
            ],
            'courseid' => [
                'type' => PARAM_INT,
            ],
            'cmid' => [
                'type' => PARAM_INT,
                'default' => 0,
            ],
            'lastrun' => [
                'type' => PARAM_INT,
                'default' => 0,
            ],
            'lastexecutiontime' => [
                'type' => PARAM_INT,
                'default' => 0,
            ],
        ];
    }

    /**
     * Validate run content.
     *
     * @param string $run Run string to validate.
     *
     * @return bool|\lang_string
     */
    protected function validate_run(string $run) {
        if (helper::is_valid_report_datawarehouse_run($run)) {
            return true;
        } else {
            return new \lang_string('invalidrun', 'report_datawarehouse');
        }
    }

    /**
     * Check if we can delete the run.
     *
     * @return bool
     */
    public function can_delete() : bool {
        $result = true;

// phpcs:disable
/*
        if ($this->get('id')) {
            $settings = quiz_settings::get_records(['runid' => $this->get('id')]);
            $result = empty($settings);
        }
*/
// phpcs:enable

        return $result;
    }

}
