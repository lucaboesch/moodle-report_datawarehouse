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

namespace report_datawarehouse\local;

use report_datawarehouse\utils;

/**
 * Backend category class.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class backend_category {
    /** @var int Category ID. */
    private $id;

    /** @var string Category name. */
    private $name;

    /** @var array Pre-loaded backends data. */
    private $backendsdata;

    /** @var array Pre-loaded statistic data. */
    private $statistic;

    /**
     * Create a new backend_category object.
     *
     * @param \stdClass $record The record from database.
     */
    public function __construct(\stdClass $record) {
        $this->id = $record->id;
        $this->name = $record->name;
    }

    /**
     * Load backends of backend_category from records.
     *
     * @param array $backends Records to load.
     */
    public function load_backends_data(array $backends): void {
        $statistic = [];
        $backendsdata = [];

        // phpcs:disable
/*        foreach (report_datawarehouse_runable_options() as $type => $description) {
            $fitleredbackends = utils::get_number_of_report_by_type($backends, $type);
            $statistic[$type] = count($fitleredbackends);
            if ($fitleredbackends) {
                $backendsdata[] = [
                    'type' => $type,
                    'backends' => $fitleredbackends
                ];
            }
        }
*/
        // phpcs:enable
        $this->backendsdata = $backendsdata;
        $this->statistic = $statistic;
    }

    /**
     * Get backend_category ID.
     *
     * @return int Category ID.
     */
    public function get_id(): int {
        return $this->id;
    }

    /**
     * Get backend_category name.
     *
     * @return string Backend Category name.
     */
    public function get_name(): string {
        return $this->name;
    }

    /**
     * Get pre-loaded backends' data of this backend_category.
     *
     * @return array Backends' data.
     */
    public function get_backends_data(): array {
        return $this->backendsdata;
    }

    /**
     * Get pre-loaded statistic of this backend_category.
     *
     * @return array Statistic data.
     */
    public function get_statistic(): array {
        return $this->statistic;
    }

    /**
     * Get url to view the backend_category.
     *
     * @return \moodle_url Backend category's url.
     */
    public function get_url(): \moodle_url {
        return report_datawarehouse_url('backend_category.php', ['id' => $this->id]);
    }
}
