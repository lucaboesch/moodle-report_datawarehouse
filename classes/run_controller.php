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
 * Class for manipulating with the run records.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

namespace report_datawarehouse;

use core\notification;

defined('MOODLE_INTERNAL') || die();

require_once(dirname(__FILE__) . '/../locallib.php');

/**
 * Class for manipulating with the run records.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class run_controller {
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
     * Run action.
     */
    const ACTION_RUN = 'run';


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

            case self::ACTION_RUN:
                $this->run(required_param('id', PARAM_INT));

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
        admin_externalpage_setup('report_datawarehouse/run');
    }

    /**
     * Return record instance.
     *
     * @param int $id
     * @param \stdClass|null $data
     *
     * @return \report_datawarehouse\run
     */
    protected function get_instance($id = 0, ?\stdClass $data = null) {
        return new run($id, $data);
    }

    /**
     * Print out all records in a table.
     */
    protected function display_all_records() {
        // phpcs:disable
/*
        $records = $this->get_sorted_runs_list();
        $table = new run_list();
        $table->display($records);
*/
        // phpcs:enable
    }


    /**
     * Return a list of runs sorted by the order defined in the admin interface
     *
     * @return static[] The list of runs
     */
    public function get_sorted_runs_list() {
        return \report_datawarehouse\run::get_records([], 'sortorder');
    }

    /**
     * Returns a text for create new record button.
     * @return string
     */
    protected function get_create_button_text(): string {
        return get_string('addrun', 'report_datawarehouse');
    }

    /**
     * Returns form for the record.
     *
     * @param \report_datawarehouse\run|null $instance
     *
     * @return \report_datawarehouse\local\form\run
     */
    protected function get_form($instance): \report_datawarehouse\local\form\run {
        global $PAGE;

        return new \report_datawarehouse\local\form\run($PAGE->url->out(false), ['persistent' => $instance]);
    }

    /**
     * View run heading string.
     * @return string
     */
    protected function get_view_heading(): string {
        return get_string('manageruns', 'report_datawarehouse');
    }

    /**
     * New run heading string.
     * @return string
     */
    protected function get_new_heading(): string {
        return get_string('newrun', 'report_datawarehouse');
    }

    /**
     * Edit run heading string.
     * @return string
     */
    protected function get_edit_heading(): string {
        return get_string('editrun', 'report_datawarehouse');
    }

    /**
     * Returns base URL for the manager.
     * @return string
     */
    public static function get_base_url(): string {
        return '/report/datawarehouse/run.php';
    }

    /**
     * Execute edit action.
     *
     * @param string $action Could be edit or create.
     * @param null|int $id Id of the region or null if creating a new one.
     */
    protected function edit($action, $id = null) {
        global $PAGE;

        if (!has_capability('report/datawarehouse:manageruns', \context_system::instance())) {
            notification::warning(get_string('canteditrun', 'report_datawarehouse'));
            redirect(new \moodle_url('/report/datawarehouse/index.php'));
        }

        $PAGE->set_url(new \moodle_url(static::get_base_url(), ['action' => $action, 'id' => $id]));
        $instance = null;

        if ($id) {
            $instance = $this->get_instance($id);
        }

        $form = $this->get_form($instance);

        if ($form->is_cancelled()) {
            redirect(new \moodle_url('/report/datawarehouse/index.php'));
        } else if ($data = $form->get_data()) {
            unset($data->submitbutton);
            try {
                if (empty($data->id)) {
                    // Inserting a completely new run.
                    $persistent = $this->get_instance(0, $data);
                    $persistent->create();

                    \report_datawarehouse\event\run_created::create_strict(
                        $persistent,
                        \context_system::instance()
                    )->trigger();
                    // phpcs:disable
                    // $this->trigger_enabled_event($persistent);
                    // phpcs:enable
                } else {
                    // Modifying an existing run.
                    $instance->from_record($data);
                    $instance->update();

                    \report_datawarehouse\event\run_updated::create_strict(
                        $instance,
                        \context_system::instance()
                    )->trigger();
                    // phpcs:disable
                    // $this->trigger_enabled_event($persistent);
                    // phpcs:enable
                }
                notification::success(get_string('changessaved'));
            } catch (\Exception $e) {
                notification::error($e->getMessage());
            }
            redirect(new \moodle_url('/report/datawarehouse/index.php'));
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
        if (!has_capability('report/datawarehouse:manageruns', \context_system::instance())) {
            notification::warning(get_string('cantdeleterun', 'report_datawarehouse'));
            redirect(new \moodle_url('/report/datawarehouse/index.php'));
        }
        require_sesskey();
        $instance = $this->get_instance($id);

        if ($instance->can_delete()) {
            $instance->delete();
            notification::success(get_string('rundeleted', 'report_datawarehouse'));

            \report_datawarehouse\event\run_deleted::create_strict(
                $id,
                \context_system::instance()
            )->trigger();

            redirect(new \moodle_url('/report/datawarehouse/index.php'));
        } else {
            notification::warning(get_string('cantdeleterun', 'report_datawarehouse'));
            redirect(new \moodle_url('/report/datawarehouse/index.php'));
        }
    }

    /**
     * Execute run action.
     *
     * @param int $runid the run id
     * @throws \dml_exception
     * @throws \moodle_exception
     */
    protected function run($runid) {
        report_datawarehouse_execute_run($runid);
        redirect(new \moodle_url('/report/datawarehouse/index.php'));
    }

    /**
     * Execute view action.
     */
    protected function view() {

        // phpcs:disable
        /*
        $this->header($this->get_view_heading());
        $this->print_add_button();
        $this->display_all_records();

        // JS for run management.
        $PAGE->requires->js_call_amd('report_datawarehouse/manageruns', 'setup');

        $this->footer();
        */
        // phpcs:enable
    }

    /**
     * Show the run.
     *
     * @param int $id The ID of the run to show.
     */
    protected function show(int $id) {
        $this->show_hide($id, 1);
    }

    /**
     * Hide the run.
     *
     * @param int $id The ID of the run to hide.
     */
    protected function hide($id) {
        $this->show_hide($id, 0);
    }

    /**
     * Show or Hide the run.
     *
     * @param int $id The ID of the run to hide.
     * @param int $visibility The intended visibility.
     */
    protected function show_hide(int $id, int $visibility) {
        require_sesskey();
        $run = $this->get_instance($id);
        $run->set('enabled', $visibility);
        $run->save();

        $this->trigger_enabled_event($run);

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
     * Change the order of this run.
     *
     * @param string $runtomove - The run to move
     * @param string $dir - up or down
     * @return string The next page to display
     */
    public function move_run($runtomove, $dir) {
        // Get a list of the current runs.
        $runs = $this->get_sorted_runs_list();

        $currentindex = 0;

        // Throw away the keys.
        $runs = array_values($runs);

        // Find this run in the list.
        foreach ($runs as $key => $run) {
            if ($run == $runtomove) {
                $currentindex = $key;
                break;
            }
        }

        // Make the switch.
        if ($dir == 'up') {
            if ($currentindex > 0) {
                $temprun = $runs[$currentindex - 1];
                $runs[$currentindex - 1] = $runs[$currentindex];
                $runs[$currentindex] = $temprun;
            }
        } else if ($dir == 'down') {
            if ($currentindex < (count($runs) - 1)) {
                $temprun = $runs[$currentindex + 1];
                $runs[$currentindex + 1] = $runs[$currentindex];
                $runs[$currentindex] = $temprun;
            }
        }

        // Save the new normal order.
        foreach ($runs as $key => $run) {
            $run = $this->get_instance($run["id"]);
            $run->save();
        }
        $this->view();
    }

    /**
     * Helper function to fire off an event that informs of if a run is enabled or not.
     *
     * @param \report_datawarehouse\run $run The run persistent object.
     */
    private function trigger_enabled_event(run $run) {
        $eventstring = ($run->get('enabled') == 0 ? 'disabled' : 'enabled');

        $func = '\report_datawarehouse\event\run_' . $eventstring;
        $func::create_strict(
            $run,
            \context_system::instance()
        )->trigger();
    }

}
