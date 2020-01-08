//
//  NetworkInterface.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 12/22/19.
//  Copyright © 2019 Jared Bourgeois. All rights reserved.
//

import Dispatch
import UIKit

public class NetworkInterface {
    public static var queueName: String { "NetworkQueue" }
    
    public enum Request {
        public struct DownloadCharacterImage {
            let url: String
            let characterTitle: String
            let index: Int
            let callback: Callback.DownloadCharacterImage
            let callbackQueue: OperationQueue
        }
        public struct DownloadCharacters {
            let url: String
            let callback: Callback.DownloadCharacters
            let callbackQueue: OperationQueue
        }
        public struct DownloadLogoImage {
            let url: String
            let callback: Callback.DownloadLogoImage
            let callbackQueue: OperationQueue
        }
    }
    public enum Callback {
        typealias DownloadCharacterImage = (Response.DownloadCharacterImage) -> Void
        typealias DownloadCharacters = (Response.DownloadCharacters) -> Void
        typealias DownloadLogoImage = (Response.DownloadLogoImage) -> Void
    }
    public enum Response {
        public struct DownloadCharacterImage {
            let characterTitle: String
            let index: Int
            let imageData: Data?
        }
        public struct DownloadCharacters {
            let characterData: Data?
        }
        public struct DownloadLogoImage {
            let imageData: Data?
        }
    }
    
    public static func downloadCharacterImage(_ downloadImageRequest: Request.DownloadCharacterImage) -> Void {
        if let url: URL = URL(string: downloadImageRequest.url) {
            let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response :URLResponse?, error: Error?) -> Void in
                let imageData: Data = data != nil ? data! : Data.empty
                let success: Bool = data != nil && error == nil
                if success {
                    downloadImageRequest.callbackQueue.addOperation {
                        downloadImageRequest.callback(Response.DownloadCharacterImage(characterTitle: downloadImageRequest.characterTitle, index: downloadImageRequest.index, imageData: imageData))
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    public static func downloadCharacters(_ downloadCharactersRequest: Request.DownloadCharacters) -> Void {
        if let url: URL = URL(string: downloadCharactersRequest.url) {
            let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response :URLResponse?, error: Error?) -> Void in
                let characterData: Data = data != nil ? data! : Data.empty
                let success: Bool = data != nil && error == nil
                if success {
                    downloadCharactersRequest.callbackQueue.addOperation {
                        downloadCharactersRequest.callback(Response.DownloadCharacters(characterData: characterData))
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    public static func downloadLogoImage(_ downloadLogoImageRequest: Request.DownloadLogoImage) -> Void {
        if let url: URL = URL(string: downloadLogoImageRequest.url) {
            let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response :URLResponse?, error: Error?) -> Void in
                let imageData: Data = data != nil ? data! : Data.empty
                let success: Bool = data != nil && error == nil
                if success {
                    downloadLogoImageRequest.callbackQueue.addOperation {
                        downloadLogoImageRequest.callback(Response.DownloadLogoImage(imageData: imageData))
                    }
                }
            })
            dataTask.resume()
        }
    }

}
