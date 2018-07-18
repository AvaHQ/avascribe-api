Avascribe API's documentation
=========================================

Please use our `github`_ repo issues / pull requests for your questions.

The general idea is the following:

.. image:: flow.png
   :width: 350px
   :align: center

- The client uses the REST API to create a conversation. He get in return a single-use websocket url.
- The client connects to this websocket url, and wait for a message from ava indicating captioner is ready.
- The client sends audio through the websocket, and get transcripts in return.
- The client sends an end message at the end, and ava close the websocket.


.. _github: https://github.com/avahq/avascribe-api/


.. toctree::
   :maxdepth: 2
   :caption: Contents:

   rest
   websocket
   error

