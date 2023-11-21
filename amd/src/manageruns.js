/**
 * Backend management code.
 *
 * @module      report_datawarehouse/manageruns
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 */
define(
    ['jquery', 'core/ajax', 'core/str', 'core/notification'],
    function($, ajax, str, notification) {
        var runmanager = {
            /**
             * Confirm removal of the specified run.
             *
             * @method removeBackend
             * @param {EventFacade} e The EventFacade
             */
            removeBackend: function(e) {
                e.preventDefault();
                var targetUrl = $(e.currentTarget).attr('href');
                str.get_strings([
                    {
                        key:        'confirmrunremovaltitle',
                        component:  'report_datawarehouse'
                    },
                    {
                        key:        'confirmrunremovalquestion',
                        component:  'report_datawarehouse'
                    },
                    {
                        key:        'yes',
                        component:  'moodle'
                    },
                    {
                        key:        'no',
                        component:  'moodle'
                    }
                ])
                .then(function(s) {
                    notification.confirm(s[0], s[1], s[2], s[3], function() {
                        window.location = targetUrl;
                    });

                    return;
                })
                .catch(notification.exception);
            },

            /**
             * Setup the runs management UI.
             *
             * @method setup
             */
            setup: function() {
                $('body').delegate('[data-action="rundelete"]', 'click', runmanager.removeBackend);
            }
        };

        return /** @alias module:report_datawarehouse/manageruns */ {
            /**
             * Setup the run management UI.
             *
             * @method setup
             */
            setup: runmanager.setup
        };
    });
