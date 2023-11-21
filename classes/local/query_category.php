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
 * Query category class.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class query_category {
    /** @var int Category ID. */
    private $id;

    /** @var string Category name. */
    private $name;

    /** @var array Pre-loaded queries data. */
    private $queriesdata;

    /** @var array Pre-loaded statistic data. */
    private $statistic;

    /**
     * Create a new query_category object.
     *
     * @param \stdClass $record The record from database.
     */
    public function __construct(\stdClass $record) {
        $this->id = $record->id;
        $this->name = $record->name;
    }

    /**
     * Load queries of query_category from records.
     *
     * @param array $queries Records to load.
     */
    public function load_queries_data(array $queries): void {
        $statistic = [];
        $queriesdata = [];
        foreach (report_datawarehouse_runable_options() as $type => $description) {
            $filteredqueries = utils::get_number_of_report_by_type($queries, $type);
            $statistic[$type] = count($filteredqueries);
            if ($filteredqueries) {
                $queriesdata[] = [
                    'type' => $type,
                    'queries' => $filteredqueries,
                ];
            }
        }
        $this->queriesdata = $queriesdata;
        $this->statistic = $statistic;
    }

    /**
     * Get query_category ID.
     *
     * @return int Category ID.
     */
    public function get_id(): int {
        return $this->id;
    }

    /**
     * Get query_category name.
     *
     * @return string Query Category name.
     */
    public function get_name(): string {
        return $this->name;
    }

    /**
     * Get pre-loaded queries' data of this query_category.
     *
     * @return array Queries' data.
     */
    public function get_queries_data(): array {
        return $this->queriesdata;
    }

    /**
     * Get pre-loaded statistic of this query_category.
     *
     * @return array Statistic data.
     */
    public function get_statistic(): array {
        return $this->statistic;
    }

    /**
     * Get url to view the query_category.
     *
     * @return \moodle_url Query category's url.
     */
    public function get_url(): \moodle_url {
        return report_datawarehouse_url('query_category.php', ['id' => $this->id]);
    }
}
