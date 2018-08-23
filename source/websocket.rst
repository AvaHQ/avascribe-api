Websocket
=========

Endpoint
--------
We use single-use websocket url, which can be obtained using the REST API.


Captioner Ready
---------------

When a captioner is ready to handle the conversation, Ava sends a :code:`ready` message to the client, which contains:

.. ava-schema:: websocket.ready

At this point, client can start to send audio messages.

*note*: in :code:`dev` mode (if the conversation has been started with :code:`"dev": true`), the ready message will be sent without having a real captioner ready.

Audio
-----

In order to stream the audio, the client sends :code:`audio` with the audio to transcribe.
No audio message should be sent before receiving the :code:`ready` event.

.. ava-schema:: websocket.audio

Transcript
----------

We return transcripts to the client in :code:`transcript` messages:

.. ava-schema:: websocket.transcript

If two transcripts are sent with the same `blocId`, only the last one should be considered.
For each :code:`blocId`, we will send a transcript with a :code:`isFinal` field set to :code:`true`.

Please note that the blocId will be ordered: if a blocId is smaller than an other one, then the associated transcripts are ordered in the same way.


Ping / pong
-----------

We expect to receive at least one message every :code:`10s`. If during the connection (captioner ready or not), you think you may have a large period without sending message, you must send a ping. We will send back a pong.


End Connection
--------------

When the conversation is finished, the client should send a :code:`end` message over the websocket:

.. ava-schema:: websocket.end

Ava will consider as error all the ws connections which are closed without :code:`end` message.


Errors
------

For various reasons, we may send :code:`error` messages. Client should expect that the underlying WebSocket connection will be closed by us after sending an error message. Error message contains:

.. ava-schema:: websocket.error