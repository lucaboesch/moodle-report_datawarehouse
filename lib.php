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
 * Library functions for the report_datawarehouse plugin.
 *
 * @package     report_datawarehouse
 * @copyright   2026 Erik Steinacher <erik.steinacher@students.fhnw.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Serve the requested file for the report_datawarehouse plugin.
 *
 * @param stdClass $course the course object
 * @param stdClass $cm the course module object
 * @param stdClass $context the context
 * @param string $filearea the name of the file area
 * @param array $args extra arguments (itemid, path)
 * @param bool $forcedownload whether or not force download
 * @param array $options additional options affecting the file serving
 * @return bool false if the file not found, just send the file otherwise and do not return anything
 */
function report_datawarehouse_pluginfile(
    $course,
    $cm,
    $context,
    string $filearea,
    array $args,
    bool $forcedownload,
    array $options
): bool {

    // Dynamically handle login requirements based on the context level requested.
    if ($context->contextlevel == CONTEXT_MODULE) {
        require_login($course, true, $cm);
    } else if ($context->contextlevel == CONTEXT_COURSE) {
        require_login($course);
    } else {
        require_login();
    }

    // Check permissions against the specific context the file belongs to.
    if (
        !has_any_capability(
            [
                'report/datawarehouse:view',
                'report/datawarehouse:viewfiles',
            ],
            $context
        )
    ) {
        return false;
    }

    // Only the 'data' file area is supported.
    if ($filearea !== 'data') {
        return false;
    }

    if (empty($args) || count($args) < 2) {
        return false;
    }

    $itemid = (int) array_shift($args);
    $filename = array_pop($args);
    if ($itemid < 0 || $filename === null || $filename === '') {
        return false;
    }

    $filepath = $args ? '/' . implode('/', $args) . '/' : '/';

    $fs = get_file_storage();
    $file = $fs->get_file($context->id, 'report_datawarehouse', $filearea, $itemid, $filepath, $filename);

    if (!$file || $file->is_directory()) {
        return false;
    }

    send_stored_file($file, 0, 0, $forcedownload, $options);
    return true;
}
