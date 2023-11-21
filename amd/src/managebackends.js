/**
 * Backend management code.
 *
 * @module      report_datawarehouse/managebackends
 * @copyright   2023 Luca Bösch <luca.boesch@bfh.ch>
 */
define(
    ['jquery', 'core/ajax', 'core/str', 'core/notification'],
    function($, ajax, str, notification) {
        var backendmanager = {
            /**
             * Confirm removal of the specified backend.
             *
             * @method removeBackend
             * @param {EventFacade} e The EventFacade
             */
            removeBackend: function(e) {
                e.preventDefault();
                var targetUrl = $(e.currentTarget).attr('href');
                str.get_strings([
                    {
                        key:        'confirmbackendremovaltitle',
                        component:  'report_datawarehouse'
                    },
                    {
                        key:        'confirmbackendremovalquestion',
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
             * Setup the backends management UI.
             *
             * @method setup
             */
            setup: function() {
                $('body').delegate('[data-action="backenddelete"]', 'click', backendmanager.removeBackend);
            }
        };

        return /** @alias module:report_datawarehouse/managebackends */ {
            /**
             * Setup the backend management UI.
             *
             * @method setup
             */
            setup: backendmanager.setup
        };
    });
