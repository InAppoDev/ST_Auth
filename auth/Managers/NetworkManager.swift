//
//  NetworkManager.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation
import Alamofire

class NetworkManager {
	
	static let shared = NetworkManager()
	
	private init() {}

	private func request(urlString: String, parameters: Parameters? = nil, headers: HTTPHeaders?, method: HTTPMethod, completion: @escaping(AFDataResponse<Data?>) -> Void) {
		guard let url = URL(string: urlString) else { return }

		AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
			completion(response)
		}.cURLDescription { description in
			Logger.shared.printInDebug(description)
		}
	}

	private func request<Parameters: Codable>(urlString: String, parameters: Parameters? = nil, headers: HTTPHeaders?, method: HTTPMethod, completion: @escaping(AFDataResponse<Data?>) -> Void) {
		guard let url = URL(string: urlString) else { return }

		AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { response in
			completion(response)
		}.cURLDescription { description in
			Logger.shared.printInDebug(description)
		}
		
	}
	
	func fetchData<T: Codable>(urlString: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion:  @escaping(T?, CustomErrors?) -> Void) {
		request(urlString: urlString, parameters: parameters, headers: headers, method: method) { response in

			guard response.response?.statusCode == 200 || response.response?.statusCode == 201, response.error == nil, let data = response.data else {
				if let error = CustomErrors.returnError(response: response.response, error: response.error) {
					completion(nil, error)
				} else {
					let error = CustomErrors.returnErrorAuth(modelType: LoginErrorModel.self, data: response.data ?? Data())
					completion(nil, error)
				}

				return
			}
			
			let result = self.decodeJSON(type: T.self, data: data)
			completion(result, nil)
		}
	}
	
	func fetchData<T: Codable, Parameters: Codable>(urlString: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion:  @escaping(T?, CustomErrors?) -> Void) {
		
		request(urlString: urlString, parameters: parameters, headers: headers, method: method) { response in

			guard response.response?.statusCode == 200 || response.response?.statusCode == 201, response.error == nil, let data = response.data else {
				if let error = CustomErrors.returnError(response: response.response, error: response.error) {
					completion(nil, error)
				} else {
					let error = CustomErrors.returnErrorAuth(modelType: LoginErrorModel.self, data: response.data!)
					completion(nil, error)
				}

				return
			}
			
			let result = self.decodeJSON(type: T.self, data: data)
			completion(result, nil)
		}
	}
	
	func fetchData(urlString: String, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, completion:  @escaping(Bool?, CustomErrors?) -> Void){
		
		request(urlString: urlString, parameters: nil, headers: headers, method: method) { response in

			guard response.response?.statusCode == 204 || response.response?.statusCode == 201, response.error == nil else {
				if let error = CustomErrors.returnError(response: response.response, error: response.error) {
					completion(nil, error)
				} else {
					let error = CustomErrors.returnErrorAuth(modelType: LoginErrorModel.self, data: response.data!)
					completion(nil, error)
				}

				return
			}
			
			completion(true, nil)
		}
	}
	
	private func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
		let decoder = JSONDecoder()
		guard let data = data else { return nil }
		do {
			let result = try decoder.decode(type.self, from: data)
			return result
		} catch {
			print("Decode error: \(error.localizedDescription)")
			return nil
		}
	}
}

