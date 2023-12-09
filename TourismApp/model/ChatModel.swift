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

//MARK: - Search Model
struct SearchModel: Codable {
    let destinations: [SearchDestinationModel]
}

struct SearchDestinationModel: Codable {
    let id: String
    let name: DestionationName?
    let location: MainLocation?
    let city_name: CityName?
    let gallery: [Gallery]?
    let description: DescriptionString?
    let recommendationLevel: MainRecomentationLevel?
    let comments: [MainComment]?
}

struct LocationModel: Codable {
    let latitude: Double
    let longitude: Double
}

struct DestionationName: Codable {
    let english: String?
    let uzbek: String?
}

struct CityName: Codable {
    let english: String?
    let uzbek: String?
}

struct HotelName: Codable {
    let english: String?
    let uzbek: String?
}

struct RestaurantName: Codable {
    let english: String?
    let uzbek: String?
}

struct DescriptionString: Codable {
    let english: String?
    let uzbek: String?
}
