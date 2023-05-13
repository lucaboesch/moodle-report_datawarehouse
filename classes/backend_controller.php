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
 * Class for manipulating with the backend records.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse;

use core\notification;

/**
 * Class for manipulating with the backend records.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class backend_controller {
    /**
     * View action.
     */
    const ACTION_VIEW = 'view';

    /**
     * Add action.
     */
    const ACTION_ADD = 'add';

    /**
     * Edit action.
     */
    const ACTION_EDIT = 'edit';

    /**
     * Delete action.
     */
    const ACTION_DELETE = 'delete';

    /**
     * Hide action.
     */
    const ACTION_HIDE = 'hide';

    /**
     * Show action.
     */
    const ACTION_SHOW = 'show';


    /**
     * Locally cached $OUTPUT object.
     * @var \bootstrap_renderer
     */
    protected $output;

    /**
     * region_manager constructor.
     */
    public function __construct() {
        global $OUTPUT;

        $this->output = $OUTPUT;
    }

    /**
     * Execute required action.
     *
     * @param string $action Action to execute.
     */
    public function execute($action) {

        switch($action) {
            case self::ACTION_ADD:
            case self::ACTION_EDIT:
                $this->edit($action, optional_param('id', null, PARAM_INT));
                break;

            case self::ACTION_DELETE:
                $this->delete(required_param('id', PARAM_INT));
                break;

            case self::ACTION_HIDE:
                $this->hide(required_param('id', PARAM_INT));
                break;

            case self::ACTION_SHOW:
                $this->show(required_param('id', PARAM_INT));
                break;

            case self::ACTION_VIEW:
            default:
                $this->edit($action, optional_param('id', null, PARAM_INT));
                break;
        }
    }

    /**
     * Set external page for the manager.
     */
    protected function set_external_page() {
        admin_externalpage_setup('report_datawarehouse/backend');
    }

    /**
     * Return record instance.
     *
     * @param int $id
     * @param \stdClass|null $data
     *
     * @return \report_datawarehouse\backend
     */
    protected function get_instance($id = 0, \stdClass $data = null) {
        return new backend($id, $data);
    }

    /**
     * Print out all records in a table.
     */
    protected function display_all_records() {
        $records = $this->get_sorted_backends_list();

        $table = new backend_list();
        $table->display($records);
    }

    /**
     * Return a list of backends sorted by the order defined in the admin interface
     *
     * @return static[] The list of backends
     */
    public function get_sorted_backends_list() {
        return \report_datawarehouse\backend::get_records([], 'sortorder');
    }

    /**
     * Returns a text for create new record button.
     * @return string
     */
    protected function get_create_button_text() : string {
        return get_string('addbackend', 'report_datawarehouse');
    }

    /**
     * Returns form for the record.
     *
     * @param \report_datawarehouse\backend|null $instance
     *
     * @return \report_datawarehouse\local\form\backend
     */
    protected function get_form($instance) : \report_datawarehouse\local\form\backend {
        global $PAGE;

        return new \report_datawarehouse\local\form\backend($PAGE->url->out(false), ['persistent' => $instance]);
    }

    /**
     * View backend heading string.
     * @return string
     */
    protected function get_view_heading() : string {
        return get_string('managebackends', 'report_datawarehouse');
    }

    /**
     * New backend heading string.
     * @return string
     */
    protected function get_new_heading() : string {
        return get_string('newbackend', 'report_datawarehouse');
    }

    /**
     * Edit backend heading string.
     * @return string
     */
    protected function get_edit_heading() : string {
        return get_string('editbackend', 'report_datawarehouse');
    }

    /**
     * Returns base URL for the manager.
     * @return string
     */
    public static function get_base_url() : string {
        return '/report/datawarehouse/index.php';
    }

    /**
     * Execute edit action.
     *
     * @param string $action Could be edit or create.
     * @param null|int $id Id of the region or null if creating a new one.
     */
    protected function edit($action, $id = null) {
        global $PAGE;

        $PAGE->set_url(new \moodle_url(static::get_base_url(), ['action' => $action, 'id' => $id]));
        $instance = null;

        if ($id) {
            $instance = $this->get_instance($id);
        }

        $form = $this->get_form($instance);

        if ($form->is_cancelled()) {
            redirect(new \moodle_url(static::get_base_url()));
        } else if ($data = $form->get_data()) {
            unset($data->submitbutton);
            try {
                if (empty($data->id)) {
                    // Inserting a completely new backend.
                    $persistent = $this->get_instance(0, $data);
                    $persistent->create();

                    \report_datawarehouse\event\backend_created::create_strict(
                        $persistent,
                        \context_system::instance()
                    )->trigger();
                    $this->trigger_enabled_event($persistent);
                } else {
                    // Modifying an existing backend.
                    $instance->from_record($data);
                    $instance->update();

                    \report_datawarehouse\event\backend_updated::create_strict(
                        $instance,
                        \context_system::instance()
                    )->trigger();
                    $this->trigger_enabled_event($instance);
                }
                notification::success(get_string('changessaved'));
            } catch (\Exception $e) {
                notification::error($e->getMessage());
            }
            redirect(new \moodle_url(static::get_base_url()));
        } else {
            if (empty($instance)) {
                $this->header($this->get_new_heading());
            } else {
                if (!$instance->can_delete()) {
                    notification::warning(get_string('cantedit', 'report_datawarehouse'));
                }
                $this->header($this->get_edit_heading());
            }
        }

        $form->display();
        $this->footer();
    }

    /**
     * Execute delete action.
     *
     * @param int $id ID of the region.
     */
    protected function delete($id) {
        require_sesskey();
        $instance = $this->get_instance($id);

        if ($instance->can_delete()) {
            $instance->delete();
            notification::success(get_string('deleted'));

            \report_datawarehouse\event\backend_deleted::create_strict(
                $id,
                \context_system::instance()
            )->trigger();

            redirect(new \moodle_url(static::get_base_url()));
        } else {
            notification::warning(get_string('cantdelete', 'report_datawarehouse'));
            redirect(new \moodle_url(static::get_base_url()));
        }
    }

    /**
     * Execute view action.
     */
    protected function view() {
        global $PAGE;

        // phpcs:disable
        /*
        $this->header($this->get_view_heading());
        $this->print_add_button();
        $this->display_all_records();

        // JS for backend management.
        $PAGE->requires->js_call_amd('report_datawarehouse/managebackends', 'setup');

        $this->footer();
        */
        // phpcs:enable
    }

    /**
     * Show the backend.
     *
     * @param int $id The ID of the backend to show.
     */
    protected function show(int $id) {
        $this->show_hide($id, 1);
    }

    /**
     * Hide the backend.
     *
     * @param int $id The ID of the backend to hide.
     */
    protected function hide($id) {
        $this->show_hide($id, 0);
    }

    /**
     * Show or Hide the backend.
     *
     * @param int $id The ID of the backend to hide.
     * @param int $visibility The intended visibility.
     */
    protected function show_hide(int $id, int $visibility) {
        require_sesskey();
        $backend = $this->get_instance($id);
        $backend->set('enabled', $visibility);
        $backend->save();

        $this->trigger_enabled_event($backend);

        redirect(new \moodle_url(self::get_base_url()));
    }

    /**
     * Print out add button.
     */
    protected function print_add_button() {
        echo $this->output->single_button(
            new \moodle_url(static::get_base_url(), ['action' => self::ACTION_ADD]),
            $this->get_create_button_text(), 'post', ['class' => 'mb-3']
        );
    }

    /**
     * Print out page header.
     * @param string $title Title to display.
     */
    protected function header($title) {
        echo $this->output->header();
        echo $this->output->heading($title);
    }

    /**
     * Print out the page footer.
     *
     * @return void
     */
    protected function footer() {
        echo $this->output->footer();
    }

    /**
     * Change the order of this backend.
     *
     * @param string $backendtomove - The backend to move
     * @param string $dir - up or down
     * @return string The next page to display
     */
    public function move_backend($backendtomove, $dir) {
        // Get a list of the current backends.
        $backends = $this->get_sorted_backends_list();

        $currentindex = 0;

        // Throw away the keys.
        $backends = array_values($backends);

        // Find this backend in the list.
        foreach ($backends as $key => $backend) {
            if ($backend == $backendtomove) {
                $currentindex = $key;
                break;
            }
        }

        // Make the switch.
        if ($dir == 'up') {
            if ($currentindex > 0) {
                $tempbackend = $backends[$currentindex - 1];
                $backends[$currentindex - 1] = $backends[$currentindex];
                $backends[$currentindex] = $tempbackend;
            }
        } else if ($dir == 'down') {
            if ($currentindex < (count($backends) - 1)) {
                $tempbackend = $backends[$currentindex + 1];
                $backends[$currentindex + 1] = $backends[$currentindex];
                $backends[$currentindex] = $tempbackend;
            }
        }

        // Save the new normal order.
        foreach ($backends as $key => $backend) {
            $backend = $this->get_instance($backend["id"]);
            $backend->save();
        }
        $this->view();
    }

    /**
     * Helper function to fire off an event that informs of if a backend is enabled or not.
     *
     * @param \report_datawarehouse\backend $backend The backend persistent object.
     */
    private function trigger_enabled_event(backend $backend) {
        $eventstring = ($backend->get('enabled') == 0 ? 'disabled' : 'enabled');

        $func = '\report_datawarehouse\event\backend_' . $eventstring;
        $func::create_strict(
            $backend,
            \context_system::instance()
        )->trigger();
    }

}
