/**
 * Audio message
 */
export interface AudioWebsocketMessage {
    type: "audio";
    audio: number[];
    timestamp: number;
}
/**
 * End message
 */
export interface EndWebsocketMessage {
    type: "end";
}
/**
 * Error message
 * Error message sent by ava backend to the client
 */
export interface ErrorWebsocketMessage {
    type: "error";
    error: {
    };
}
/**
 * HTTP POST /conversations Request
 */
export interface PostConversationsRequest {
    encoding: "LINEAR16";
    sampleRateHertz: 8000;
    chunkLengthMs: 100;
}
/**
 * Ready message
 * Message sent when captioner is ready
 */
export interface ReadyWebsocketMessage {
    type: "ready";
}
/**
 * Transcript message
 */
export interface TranscriptWebsocketMessage {
    type: "transcript";
    blocId: number;
    transcript: string;
    isFinal: boolean;
}

export type WebsocketMessage = AudioWebsocketMessage | EndWebsocketMessage | ErrorWebsocketMessage | ReadyWebsocketMessage | TranscriptWebsocketMessage;

