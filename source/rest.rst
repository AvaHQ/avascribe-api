REST API
========

Basics
------

- you must use JSON-encoded bodies for POST request, and therefore set the appropriate header :code:`Content-type: application/json`). JSON body should be a hash of attribute key/value pairs (no array, string, number or boolean).
- You must transmit a valid API token as a bearer token in the :code:`Authorization` HTTP header.

Exemple:

.. sourcecode:: http

    POST /conversations HTTP/1.1
    Content-type: application/json
    Authorization: Bearer xxxxxxxxxxxxxxxxx

    {"key": "value"}


Conversations
-------------

.. http:post:: /conversations

   In order to open start a conversation, you need to perform a :code:`POST` call on :code:`/conversations`. You will get in return a conversation object, with a single-use websocket url for audio / transcripts transfer.
   Single-use websocket url are only valid 30s.

   **Rrequest**:

    .. ava-schema:: http.post.request.conversation



   **Response**:

    - **url** (`string`): `optional` - the url to connect to.
    - **error** (`object`): `optional` - An error object (see :doc:`error`).
    - **id** (`string`): `optional` - Id of the conversation. May be used to establish a second websocket connection (future) or to restart a connection if the first one is closed unexpectedly (future).

   Typical success response (:code:`201`):

   .. sourcecode:: json

      {
        "url": "wss://scribe.ava.me/ws/5b49d758ec2040000121aaf?5ee3b6618774d422e3b",
        "id": "5b49d758ec2040000121aaf5"
      }


   Typical error response (:code:`400`):

   .. sourcecode:: json

      {
        "error": {
          "name": "VALIDATION_ERROR",
          "fields": {
            "encoding": "Invalid value"
          }
        }
      }