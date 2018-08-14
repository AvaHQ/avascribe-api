/**
 * Error
 */
export interface Error {
    /**
     * Human readable name for the error.
     */
    name: string;
    /**
     * An object with fields name as keys and associated message as values.
     */
    message?: string;
    /**
     * Human readable message, describing the error.
     */
    fields?: {
    };
}
/**
 * HTTP POST /conversations Request
 */
export interface PostConversationsRequest {
    /**
     * Encoding of audio data which will be sent.
     */
    encoding: "LINEAR16";
    /**
     *  Sample rate in Hertz of the audio data which will be sent.
     */
    sampleRateHertz: 8000 | 16000;
    /**
     * Duration in ms of the chunks of audio data which will be sent.
     */
    chunkLengthMs: number;
    /**
     * If `true`, then no real captioner will be triggered. A :code:`ready` event will be sent in the websocket between :code:`2` and :code:`5` seconds after the connection initialization, and the following transcripts will be ASR only.
     */
    dev?: boolean;
    /**
     * Language of the conversation (french by default).
     */
    language?: "fr-FR" | "en-US";
}
/**
 * Audio message !
 */
export interface WebsocketMessageAudio {
    type: "audio";
    /**
     * one audio chunk (must match the encoding, the length and the sampleRateHertz indicated in connection setup). Must be base64 encoded 16LE integer bits.
     */
    audio: string;
    /**
     * timestamp of the beginning of audio.
     */
    timestamp: number;
}
/**
 * End message
 */
export interface WebsocketMessageEnd {
    type: "end";
}
/**
 * Error message
 * Error message sent by ava backend to the client
 */
export interface WebsocketMessageError {
    type: "error";
    /**
     * An error object (see :doc:`error`).
     */
    error: Error;
}
/**
 * Ready message
 * Message sent when captioner is ready
 */
export interface WebsocketMessageReady {
    type: "ready";
}
/**
 * Transcript message
 */
export interface WebsocketMessageTranscript {
    type: "transcript";
    /**
     * id of the trancript.
     */
    blocId: number;
    /**
     * transcript text
     */
    transcript: string;
    /**
     * if :code:`true`, then no more transcript associated to this :code:`blocId` will be published.
     */
    isFinal: boolean;
}

export type WebsocketMessage = WebsocketMessageAudio | WebsocketMessageEnd | WebsocketMessageError | WebsocketMessageReady | WebsocketMessageTranscript;

