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


        $mform->addElement('select', 'query', get_string('query', 'report_datawarehouse'));
        $mform->addRule('query', get_string('required'), 'required', null, 'client');
        $mform->setType('enabled', PARAM_INT);

        $mform->addElement('select', 'backend', get_string('backend', 'report_datawarehouse'));
        $mform->addRule('backend', get_string('required'), 'required', null, 'client');
        $mform->setType('enabled', PARAM_INT);

        $mform->addElement('text', 'courseid', get_string('courseid', 'report_datawarehouse'), 'maxlength="16" size="10"');
        $mform->addRule('courseid', get_string('required'), 'required', null, 'client');
        $mform->setType('courseid', PARAM_INT);

        $mform->addElement('text', 'coursemoduleid', get_string('coursemoduleid', 'report_datawarehouse'), 'maxlength="16" size="10"');
        $mform->addRule('coursemoduleid', get_string('required'), 'required', null, 'client');
        $mform->setType('coursemoduleid', PARAM_INT);

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

        // Check name.
        if (empty($data->name)) {
            $newerrors['name'] = get_string('namerequired', 'report_datawarehouse');
        }

        return $newerrors;
    }
}
