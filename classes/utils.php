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

namespace report_datawarehouse;

/**
 * Static utility methods to support the report_datawarehouse module.
 *
 * @package    report_datawarehouse
 * @copyright  2023 Luca Bösch <luca.boesch@bfh.ch>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
class utils {

    /**
     * Return the current timestamp, or a fixed timestamp specified by an automated test.
     *
     * @return int The timestamp
     */
    public static function time(): int {
        if ((defined('BEHAT_SITE_RUNNING') || PHPUNIT_TEST) &&
                $time = get_config('report_customsql', 'behat_fixed_time')) {
            return $time;
        } else {
            return time();
        }
    }

    /**
     * Group the queries by query_category id.
     *
     * @param array $queries Queries need to be grouped.
     * @return array Pre-loaded Categories.
     */
    public static function group_queries_by_query_category($queries) {
        $groupedqueries = [];
        foreach ($queries as $query) {
            if (isset($groupedqueries[$query->categoryid])) {
                $groupedqueries[$query->categoryid][] = $query;
            } else {
                $groupedqueries[$query->categoryid] = [$query];
            }
        }

        return $groupedqueries;
    }

    /**
     * Group the backends by backend_category id.
     *
     * @param array $backends Backends need to be grouped.
     * @return array Pre-loaded Categories.
     */
    public static function group_backends_by_backend_category($backends) {
        $groupedbackends = [];
        foreach ($backends as $backend) {
            if (isset($groupedbackends[$backend->categoryid])) {
                $groupedbackends[$backend->categoryid][] = $backend;
            } else {
                $groupedbackends[$backend->categoryid] = [$backend];
            }
        }

        return $groupedbackends;
    }

    /**
     * Look up queries' data
     *
     * @param array $queries the queries to get data from
     */
    public function get_queries_data($queries) {

    }

    /**
     * Get queries for each type.
     *
     * @param array $queries Array of queries.
     * @param string $type Type to filter.
     * @return array All queries of type.
     */
    public static function get_number_of_report_by_type(array $queries, string $type) {
        return array_filter($queries, function($query) use ($type) {
            return $query->runable == $type;
        }, ARRAY_FILTER_USE_BOTH);
    }

}
