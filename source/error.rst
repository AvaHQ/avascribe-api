Errors
======

Errors object could be sent in an HTTP response or in a websocket message. Error object contains:

.. ava-schema:: error

Validation Error
----------------

This error is sent after receiving an incorrect message.

- **name** (`string`): :code:`VALIDATION_ERROR`.

Exemple:

.. code-block:: json

    {
        "name": "VALIDATION_ERROR",
        "fields": {
            "audio": "Audio does not match the required length"
        }
    }


Authentication Failure
----------------------

This error is sent when receiving no API token or an invalid API token.

- **name** (`string`): :code:`AUTHENTICATION_FAILURE`.

Exemple:

.. code-block:: json

    {
        "name": "AUTHENTICATION_FAILURE",
        "message": "Invalid token"
    }



... list in progress.

