//
//  ChatModel.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 13/08/23.
//

import Foundation

// open chat
struct OpenChatModel: Codable {
    let conversationId: String
}

// query chat
struct QueryChatModel: Codable {
    let question: String
    let answer: String
}

// close chat
struct CloseChatModel: Codable {
    let conversationId: String
    let message: String
}

// chat history
struct ChatHistoryModel: Codable {
    let conversations: [Conversation]
}

struct Conversation: Codable {
    let ChatHistory: [Context]
}

struct Context: Codable {
    let Context: String
}
