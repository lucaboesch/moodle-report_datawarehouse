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
 * Unit test for writing to file area.
 *
 * @package     report_datawarehouse
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse;

defined('MOODLE_INTERNAL') || die();

global $CFG;
require_once($CFG->dirroot . '/webservice/tests/helpers.php');
require_once($CFG->dirroot . '/report/datawarehouse/locallib.php');

use core_external\external_api;
use core_external\util as external_util;
use externallib_advanced_testcase;
use mod_glossary_external;

defined('MOODLE_INTERNAL') || die();

if ($CFG->branch < 402) { // In Moodle ≥ 4.2 it throws a @runInSeparateProcess warning otherwise.
    require_once($CFG->libdir . '/externallib.php');
}

/**
 * Unit test for writing to and reading from file area.
 *
 * @package     report_datawarehouse
 * @runTestsInSeparateProcesses
 * @covers \report_datawarehouse\local\form\query
 *
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class file_storage_test extends externallib_advanced_testcase {

    /**
     * Tests saving and retrieving in the file area.
     * @covers \report_datawarehouse\local\form\query
     */
    public function test_file_area() {
        global $DB, $CFG;

        $this->resetAfterTest();
        $this->setAdminUser();

        $context = \context_system::instance()->id;
        $component = 'report_datawarehouse';
        $filearea = 'data';
        $newitemid = get_file_itemid() + 1;
        $timemodified = 102030405;
        $content = 'File content';
        $filesize = strlen($content);
        $filerecord = [
            'filename' => 'file.txt',
            'filepath' => '/',
            'mimetype'      => 'text/plain',
            'filesize'      => $filesize,
            'component' => $component,
            'contextid' => $context,
            'filearea' => $filearea,
            'timemodified'  => $timemodified,
            'itemid' => $newitemid,
        ];

        // Create a file and save it.
        write_datawarehouse_file($filerecord, $content);

        // Control that it exists.
        $files = $DB->get_records('files', ['component' => $component, 'filearea' => $filearea,
            'contextid' => $context, 'itemid' => $newitemid, 'filename' => 'file.txt']);
        $this->assertEquals(1, count($files));

        // Now retrieve it.
        $expectedfiles[] = array(
            'filename' => 'file.txt',
            'filepath' => '/',
            'fileurl' => "{$CFG->wwwroot}/webservice/pluginfile.php/{$context}/{$component}/{$filearea}/{$newitemid}/file.txt",
            'timemodified' => $timemodified,
            'filesize' => $filesize,
            'mimetype' => 'text/plain',
            'isexternalfile' => false,
        );

        // Get all the files for the area.
        $files = \external_util::get_area_files($context, $component, $filearea, false);
        $this->assertEquals($expectedfiles, $files);

        // Get just the file indicated by $itemid.
        $files = \external_util::get_area_files($context, $component, $filearea, $newitemid);
        $this->assertEquals($expectedfiles, $files);
    }
}
