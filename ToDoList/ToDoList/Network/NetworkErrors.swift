//
//  NetworkErrors.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 13.07.2025.
//

enum NetworkErrors: Error {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(String)

    var userMessage: String {
        switch self {
        case .invalidURL:
            return "The URL is not valid."
        case .noData:
            return "No data was received from the server."
        case .decodingFailed:
            return "Failed to process data."
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
