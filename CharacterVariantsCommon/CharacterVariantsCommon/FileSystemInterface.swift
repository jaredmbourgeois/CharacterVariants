//
//  FileSystemInterface.swift
//  CharacterVariantsCommon
//
//  Created by  Jared on 1/7/20.
//  Copyright © 2020 Jared Bourgeois. All rights reserved.
//

import UIKit

public class FileSystemInterface {
    public static var databaseDirectory: URL {
        return cacheURL!
    }
    
    public static var logoImage: UIImage {
        if let cacheURL: URL = cacheURL,
        let logoURL: URL = URL(string: mainConfiguration.fileSystem.logoImageName, relativeTo: cacheURL) {
            do {
                let logoData: Data = try Data(contentsOf: logoURL)
                if let logoImage: UIImage = UIImage(data: logoData) {
                    return logoImage
                }
            } catch {
                print("logoData == nil @ \(logoURL.absoluteString)")
                downloadLogoImage()
            }
        }
        if let launchImage: UIImage = UIImage(named: mainConfiguration.fileSystem.logoImageName) {
            return launchImage
        }
        return UIImage.empty
    }
    
    public static func downloadLogoImage() -> Void {
        OperationQueue.main.addOperation {
            NetworkInterface.downloadLogoImage(NetworkInterface.Request.DownloadLogoImage(
                url: mainConfiguration.urlList.logoImage,
                callback: logoImageDownloaded(downloadLogoImageResponse:),
                callbackQueue: OperationQueue.main
            ))
        }
    }
    
    public static func logoImageDownloaded(downloadLogoImageResponse: NetworkInterface.Response.DownloadLogoImage) -> Void {
        if let imageData: NSData = downloadLogoImageResponse.imageData as NSData?,
            let logoURL: URL = logoURL {
            imageData.write(to: logoURL, atomically: false)
        }
    }
    
    private static var cacheURL: URL? {
        let cacheURLs: [URL] = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        if let url: URL = URL(string: "\(cacheURLs[0].absoluteString)/") {
            return url
        }
        return nil
    }
    
    private static var logoURL: URL? {
        if let cacheURL: URL = cacheURL {
            return URL(string: "\(cacheURL.absoluteString)\(mainConfiguration.fileSystem.logoImageName)")
        }
        return nil
    }
}
