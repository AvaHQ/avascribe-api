Websocket
=========

Endpoint
--------
We use single-use websocket url, which can be obtained using the REST API.


Captioner Ready
---------------

When a captioner is ready to handle the conversation, Ava sends a :code:`ready` message to the client, which contains:

- **type** (`string`): :code:`ready`.

Exemple:

.. code-block:: json

    {
	"type": "ready"
    }

At this point, client can start to send audio messages.


Audio
-----

In order to stream the audio, the client sends :code:`audio` with the audio to transcribe.
No audio message should be sent before receiving the :code:`ready` event.

- **type** (`string`): :code:`audio`.
- **audio** (`Array<integer>`): one audio chunk (must match the encoding, the length and the sampleRateHertz indicated in connection setup).
- **timestamp** (`integer`): timestamp of the beginning of audio.

Exemple:


.. code-block:: json

    {
	"type": "audio",
	"audio": [22, 0, -17, 112],
        "timestamp": 1531587765
    }


Transcript
----------

We return transcripts to the client in :code:`transcript` messages:

- **type** (`string`): :code:`transcript`.
- **blocId** (`integer`): id of the trancript.
- **transcript** (`string`): transcript text.
- **isFinal** (`boolean`): if :code:`true`, then no more transcript associated to this :code:`blocId` will be published.

Exemple:

.. code-block:: json

    {
	"type": "transcript",
        "blocId": 1531587700,
        "transcript": "Hello, World.",
        "isFinal": true
    }

If two transcripts are sent with the same `blocId`, only the last one should be considered.
For each :code:`blocId`, we will send a transcript with a :code:`isFinal` field set to :code:`true`.

Please note that the blocId will be ordered: if a blocId is smaller than an other one, then the associated transcripts are ordered in the same way.


Ping / pong
-----------

We expect to receive at least one message every :code:`10s`. If during the connection (captioner ready or not), you think you may have a large period without sending message, you must send a ping. We will send back a pong.


End Connection
--------------

When the conversation is finished, the client should send a :code:`end` message over the websocket:

- **type** (`string`): :code:`end`.

Exemple:

.. code-block:: json

    {
	"type": "end"
    }

Ava will consider as error all the ws connections which are closed without :code:`end` message.


Errors
------

For various reasons, we may send :code:`error` messages. Client should expect that the underlying WebSocket connection will be closed by us after sending an error message. Error message contains:

- **type** (`string`): :code:`error`. (this field is ommitted in case of an http response).
- **error** (`object`): An error object (see :doc:`error`).

Exemple:

.. code-block:: json

    {
	"type": "error",
	"error": {
            "name": "VALIDATION_ERROR",
            "fields": {
                "audio": "Audio does not match the required length"
            }
        }
    }


