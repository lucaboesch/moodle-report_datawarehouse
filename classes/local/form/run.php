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
 * Form for manipulating the query records.
 *
 * @package     report_datawarehouse
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse\local\form;

defined('MOODLE_INTERNAL') || die();

require_once(dirname(__FILE__) . '/../../../locallib.php');

/**
 * Form for manipulating the query records.
 *
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class run extends \core\form\persistent {

    /** @var string Persistent class name. */
    protected static $persistentclass = 'report_datawarehouse\\run';

    /**
     * Form definition.
     */
    protected function definition() {
        global $CFG;

        $mform = $this->_form;

        $queries = [];
        $queries[0] = get_string('none');
        $enabledqueries = report_datawarehouse_get_queries();
        foreach ($enabledqueries as $qry) {
            $queries[$qry->id] = format_string($qry->name);
        }

        $mform->addElement('select', 'queryid', get_string('query', 'report_datawarehouse'), $queries);
        $mform->addRule('queryid', get_string('required'), 'required', null, 'client');
        $mform->setType('enabled', PARAM_INT);

        $backends = [];
        $backends[0] = get_string('none');
        $enabledbackends = report_datawarehouse_get_backends();
        foreach ($enabledbackends as $bknd) {
            $backends[$bknd->id] = format_string($bknd->name);
        }

        $mform->addElement('select', 'backendid', get_string('backend', 'report_datawarehouse'), $backends);
        $mform->addRule('backendid', get_string('required'), 'required', null, 'client');
        $mform->setType('enabled', PARAM_INT);

        $mform->addElement('text', 'courseid', get_string('courseid', 'report_datawarehouse'), 'maxlength="16" size="10"');
        $mform->addRule('courseid', get_string('required'), 'required', null, 'client');
        $mform->setType('courseid', PARAM_INT);

        $mform->addElement('text', 'cmid', get_string('coursemoduleid', 'report_datawarehouse'), 'maxlength="16" size="10"');
        $mform->addRule('cmid', get_string('required'), 'required', null, 'client');
        $mform->setType('cmid', PARAM_INT);

        $mform->addElement('static', 'note', get_string('note', 'report_datawarehouse'),
            get_string('runsnote', 'report_datawarehouse', $CFG->wwwroot));

        $this->add_action_buttons();

        if (!empty($this->get_persistent()) && !$this->get_persistent()->can_delete()) {
            $mform->hardFreezeAllVisibleExcept([]);
            $mform->addElement('cancel');
        }
    }

    /**
     * Extra validation.
     *
     * @param  \stdClass $data Data to validate.
     * @param  array $files Array of files.
     * @param  array $errors Currently reported errors.
     * @return array of additional errors, or overridden errors.
     */
    protected function extra_validation($data, $files, array &$errors) {
        $newerrors = [];

        return $newerrors;
    }
}
