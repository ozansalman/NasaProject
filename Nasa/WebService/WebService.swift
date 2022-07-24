//
//  WebService.swift
//  Nasa
//
//  Created by Ozan Salman on 24.07.2022.
//

import Foundation

class WebService: NSObject, URLSessionDelegate {
    
    let baseURL: String = "https://api.nasa.gov/mars-photos/api/v1/rovers"

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.serverTrust == nil {
            completionHandler(.useCredential, nil)
        } else {
            let trust: SecTrust = challenge.protectionSpace.serverTrust!
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        }
    }

    func baseSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }

    func baseRequest(lastURL: String) -> URLRequest {
        let firstURL = baseURL + lastURL
        var urlRequest = URLRequest(url: URL(string: firstURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    func getRoverData(roverName: String, camera: String, completion: @escaping (NasaModel)-> ()) {
        var url = String()
        if camera == "" {
            url = "/\(roverName)/photos?sol=1000&api_key=B3Kdhu2peAmTtHoJA7jvrCBGlNv9PdSF8Pacsu2L"
        } else {
            url = "/\(roverName)/photos?sol=1000&api_key=B3Kdhu2peAmTtHoJA7jvrCBGlNv9PdSF8Pacsu2L&camera=\(camera)"
        }
        
        baseSession().dataTask(with: baseRequest(lastURL: url)) {(data, response, error) in
            if let data = data {
                do {
                    let nasa: NasaModel = try JSONDecoder().decode(NasaModel.self, from: data)
                    completion(nasa)
                }catch let error {
                    print(error)
                }
            }
        }.resume()
    }

}
