import Foundation

final class OAuth2Service {

    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code

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
        task = session.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            do {
                let data = try result.get()
                completion(.success(data.accessToken))
            } catch let error {
                completion(.failure(error))
            }
        }
        task?.resume()
    }
}
