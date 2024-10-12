# moodle-report_datawarehouse
[![Moodle Plugin CI](https://github.com/lucaboesch/moodle-report_datawarehouse/workflows/Moodle%20Plugin%20CI/badge.svg?branch=main)](https://github.com/lucaboesch/moodle-report_datawarehouse/actions?query=workflow%3A%22Moodle+Plugin+CI%22+branch%3Amain)
[![PHP Support](https://img.shields.io/badge/php-8.1_--_8.3-blue)](https://github.com/lucaboesch/moodle-report_datawarehouse/actions)
[![Moodle Support](https://img.shields.io/badge/Moodle-4.2--4.5-orange)](https://github.com/lucaboesch/moodle-report_datawarehouse/actions)
[![License GPL-3.0](https://img.shields.io/github/license/lucaboesch/moodle-report_datawarehouse?color=lightgrey)](https://github.com/lucaboesch/moodle-report_datawarehouse/blob/main/LICENSE)
[![GitHub contributors](https://img.shields.io/github/contributors/lucaboesch/moodle-report_datawarehouse)](https://github.com/lucaboesch/moodle-report_datawarehouseA/graphs/contributors)

My MSc Thesis project, see [How to design an extensible data warehouse – Set a foundation to transfer custom
log data out of a LMS to a data warehouse in order to empower researchers to perform learning
analysis](https://ma-showroom.dsl.digisus-lab.ch/lms-data_warehouse/).

## Installing via uploaded ZIP file ##

1. Log in to your Moodle site as an admin and go to _Site administration >
   Plugins > Install plugins_.
2. Upload the ZIP file with the plugin code. You should only be prompted to add
   extra details if your plugin type is not automatically detected.
3. Check the plugin validation report and finish the installation.

## Installing manually ##

The plugin can be also installed by putting the contents of this directory to

    {your/moodle/dirroot}/report/datawarehouse

Afterwards, log in to your Moodle site as an admin and go to _Site administration >
Notifications_ to complete the installation.

Alternatively, you can run

    $ php admin/cli/upgrade.php

to complete the installation from the command line.

## License ##

2023 Luca Bösch <luca.boesch@bfh.ch>

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.
