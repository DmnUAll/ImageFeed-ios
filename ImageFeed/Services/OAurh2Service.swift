import Foundation

final class OAuth2Service {

    private enum NetworkError: Error {
        case codeError
    }

    static func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {

        var urlComponents = URLComponents(string: unsplashTokenURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code" )
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.codeError))
                return
            }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ResponseModel.self, from: data)
                    completion(.success(decodedData.accessToken))
                } catch let error {
                    completion(.failure(error))
                }
            } else {
                return
            }
        }
        task.resume()
    }
}