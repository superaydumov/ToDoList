//
//  NetworkService.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 13.07.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData(completion: @escaping (Result<NetworkToDoListModel, NetworkErrors>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    private var baseURLString = "https://dummyjson.com/todos"

    func fetchData(completion: @escaping (Result<NetworkToDoListModel, NetworkErrors>) -> Void) {
        guard let url = URL(string: baseURLString) else { completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }

            guard let data else { completion(.failure(.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(NetworkToDoListModel.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        .resume()
    }
}
