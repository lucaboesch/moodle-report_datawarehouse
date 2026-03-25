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
        global $DB;

        self::validate_parameters(self::execute_parameters(), []);

        // Establish the base execution context as system.
        $systemcontext = \context_system::instance();
        self::validate_context($systemcontext);

        $component = 'report_datawarehouse';
        $filearea = 'data';
        $files = [];

        // Fetch all distinct context IDs where data warehouse files currently exist.
        $sql = "SELECT DISTINCT contextid 
                  FROM {files} 
                 WHERE component = :component 
                   AND filearea = :filearea 
                   AND filename != '.'";

        $contextids = $DB->get_fieldset_sql($sql, [
            'component' => $component,
            'filearea' => $filearea,
        ]);

        // Iterate over found contexts, check capability, and fetch files.
        foreach ($contextids as $cid) {
            $ctx = \context::instance_by_id($cid, IGNORE_MISSING);

            // Only pull files from this context if the user has the capability to view them.
            if ($ctx && has_capability('report/datawarehouse:viewfiles', $ctx)) {
                $contextfiles = \core_external\util::get_area_files($cid, $component, $filearea, false);
                $files = array_merge($files, $contextfiles);
            }
        }

        // Fiddle in the itemid which is in the fileurl.
        foreach ($files as &$file) {
            $file['itemid'] = 0;

            if (empty($file['fileurl'])) {
                continue;
            }

            $path = parse_url($file['fileurl'], PHP_URL_PATH);
            if ($path === null || $path === false || $path === '') {
                continue;
            }

            $parts = explode('/', trim($path, '/'));
            $filenameindex = array_key_last($parts);
            if ($filenameindex === null || $filenameindex < 1) {
                continue;
            }

            // Moodle file URLs are structured: /pluginfile.php/contextid/component/area/itemid/filename
            // So the itemid is the segment immediately preceding the filename.
            $itemidcandidate = $parts[$filenameindex - 1];
            if (ctype_digit((string) $itemidcandidate)) {
                $file['itemid'] = (int) $itemidcandidate;
            }
        }
        unset($file);

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
