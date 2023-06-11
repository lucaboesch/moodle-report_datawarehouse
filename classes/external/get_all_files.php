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
 * Report data warehouse external web service functions.
 *
 * @package     report_datawarehouse
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse\external;

use external_function_parameters;
use external_multiple_structure;
use external_single_structure;
use external_value;

defined('MOODLE_INTERNAL') || die;

require_once($CFG->libdir . "/externallib.php");

/**
 * Class report_datawarehouse_external_get_all_files
 */
class get_all_files extends \external_api {
    /**
     * Returns description of get_all_files method parameters
     *
     * @return external_function_parameters
     */
    public static function execute_parameters(): external_function_parameters {
        return new external_function_parameters([
            // If this function had any parameters, they would be described here.
            // This example has no parameters, so the array is empty.
        ]);
    }

    /**
     * Return a list of all datawarehouse files.
     *
     * @return array of files
     */
    public static function execute() {
        $context = \context_system::instance()->id;
        $component = 'report_datawarehouse';
        $filearea = 'data';

        // Get all the files for the area.
        $files = \external_util::get_area_files($context, $component, $filearea, false);

        // Fiddle in the itemid which is in the fileurl.
        foreach ($files as &$file) {
            $parts = explode('/', $file["fileurl"]);
            $secondlastpart = (int) count($parts) - 2;
            $file["itemid"] = (int) $parts[$secondlastpart];
        }
        return $files;
    }

    /**
     * Return for calling the report_datawarehouse get_all_files function.
     *
     * @return external_multiple_structure
     */
    public static function execute_returns() {
        return new external_multiple_structure(
            new external_single_structure([
                'filename' => new external_value(PARAM_TEXT, 'The file name'),
                'fileurl' => new external_value(PARAM_TEXT, 'The file URL'),
                'timemodified' => new external_value(PARAM_INT, 'The file modified timestamp'),
                'filesize' => new external_value(PARAM_INT, 'The file size'),
                'itemid' => new external_value(PARAM_INT, 'The file item ID'),
            ])
        );
    }
}
