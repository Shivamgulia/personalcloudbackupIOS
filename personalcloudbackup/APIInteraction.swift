
import Foundation

class ApiService {
    
    // MARK: - GET Request
    func getRequest(urlString: String, token : String, completion: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: -3)))
                return
            }
            
            guard (200...201).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            
            
            completion(.success(data))
        }.resume()
        
    }
    
    // MARK: - POST Request
    func postRequest(urlString: String, body: [String: Any], token : String?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: -3)))
                return
            }
            
            guard (200...201).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // MARK: - PUT Request
    func putRequest(urlString: String, body: [String: Any], token : String?, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: -3)))
                return
            }
            
            guard (200...201).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func convertJSONStringToDictionary(_ jsonString: String) -> [String: Any]? {
            guard let data = jsonString.data(using: .utf8) else {
                print("❌ Failed to convert string to Data")
                return nil
            }
    
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return jsonObject
                } else {
                    print("❌ JSON is not a dictionary")
                    return nil
                }
            } catch {
                print("❌ JSON parsing error:", error.localizedDescription)
                return nil
            }
        }
    
    func convertJSONStringToArray(_ jsonString: String) -> [[String: Any]]? {
            guard let data = jsonString.data(using: .utf8) else {
                print("❌ Failed to convert string to Data")
                return nil
            }
        
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    return jsonObject
                } else {
                    print("❌ JSON is not a Array")
                    return nil
                }
            } catch {
                print("❌ JSON parsing error:", error.localizedDescription)
                return nil
            }
        }
}
