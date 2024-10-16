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
 * Entity model representing backend settings for the data warehouse report.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse;

use core\persistent;

/**
 * Entity model representing backend settings for the data warehouse report.
 *
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class backend extends persistent {

    /** Table name for the persistent. */
    const TABLE = 'report_datawarehouse_bkends';

    /**
     * Return the definition of the properties of this model.
     *
     * @return array
     */
    protected static function define_properties() {
        return [
            'name' => [
                'type' => PARAM_TEXT,
                'default' => '',
            ],
            'description' => [
                'type' => PARAM_TEXT,
                'default' => '',
            ],
            'url' => [
                'type' => PARAM_TEXT,
                'default' => '',
            ],
            'username' => [
                'type' => PARAM_TEXT,
                'default' => '',
            ],
            'password' => [
                'type' => PARAM_TEXT,
            ],
            'enabled' => [
                'type' => PARAM_INT,
                'default' => 0,
            ],
            'sortorder' => [
                'type' => PARAM_INT,
                'default' => 0,
            ],
            'alloweduser' => [
                'type' => PARAM_TEXT,
                'default' => '',
            ],
        ];
    }

    /**
     * Validate backend content.
     *
     * @param string $backend Backend string to validate.
     *
     * @return bool|\lang_string
     */
    protected function validate_backend(string $backend) {
        if (helper::is_valid_report_datawarehouse_backend($backend)) {
            return true;
        } else {
            return new \lang_string('invalidbackend', 'report_datawarehouse');
        }
    }

    /**
     * Check if we can delete the backend.
     *
     * @return bool
     */
    public function can_delete(): bool {
        $result = true;

// phpcs:disable
/*
        if ($this->get('id')) {
            $settings = quiz_settings::get_records(['backendid' => $this->get('id')]);
            $result = empty($settings);
        }
*/
// phpcs:enable

        return $result;
    }

}
