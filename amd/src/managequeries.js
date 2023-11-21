/**
 * Query management code.
 *
 * @module      report_datawarehouse/managequeries
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 */
define(
    ['jquery', 'core/ajax', 'core/str', 'core/notification'],
    function($, ajax, str, notification) {
        var querymanager = {
            /**
             * Confirm removal of the specified query.
             *
             * @method removeQuery
             * @param {EventFacade} e The EventFacade
             */
            removeQuery: function(e) {
                e.preventDefault();
                var targetUrl = $(e.currentTarget).attr('href');
                str.get_strings([
                    {
                        key:        'confirmqueryremovaltitle',
                        component:  'report_datawarehouse'
                    },
                    {
                        key:        'confirmqueryremovalquestion',
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
             * Setup the query management UI.
             *
             * @method setup
             */
            setup: function() {
                $('body').delegate('[data-action="querydelete"]', 'click', querymanager.removeQuery);
            }
        };

        return /** @alias module:report_datawarehouse/managequeries */ {
            /**
             * Setup the query management UI.
             *
             * @method setup
             */
            setup: querymanager.setup
        };
    });
