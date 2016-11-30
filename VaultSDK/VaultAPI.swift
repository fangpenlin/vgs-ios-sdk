//
//  VaultAPI.swift
//  VaultSDK
//
//  Created by Fang-Pen Lin on 11/22/16.
//  Copyright © 2016 Very Good Security. All rights reserved.
//

import Foundation

@objc
public enum VaultAPIError: Int {
    case NoData
    case InvalidData
    case BadResponse
}

public class VaultAPI: NSObject {
    static let errorDomainSuffix = ".valut-api"

    /// Version of framework
    static var frameworkVersion: String? = {
        let bundle = NSBundle(forClass: VaultAPI.self)
        return bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
    }()

    /// Build of framework
    static var frameworkBuild: String? = {
        let bundle = NSBundle(forClass: VaultAPI.self)
        return bundle.objectForInfoDictionaryKey("CFBundleVersion") as? String
    }()

    /// Base URL to the API server
    public var baseURL: NSURL
    /// The publishable key for tokenlizing senstive data to be stored in the vault
    public var publishableKey: String
    /// The URL session to be used for making HTTP requests
    public var urlSession: NSURLSession

    public init(
        baseURL: NSURL,
        publishableKey: String,
        urlSession: NSURLSession = NSURLSession.sharedSession()
    ) {
        self.baseURL = baseURL
        self.publishableKey = publishableKey
        self.urlSession = urlSession
    }

    /// Create a token for given senstive data
    ///  - Parameters payload: the payload of senstive data to be tokenlized
    ///  - Parameters failure: the callback to be called with error when we failed to create
    ///  - Parameters success: the callback to be called with token data when we create successfully
    ///  - Returns: the URLSessionTask for outgoing HTTP request
    public func createToken(
        payload: String,
        failure: (NSError) -> Void,
        success: ([String: AnyObject]) -> Void
    ) -> NSURLSessionTask {
        let jsonObj: [String: AnyObject] = [
            "raw": payload as AnyObject
        ]
        let request = try! makeRequest("POST", path: "/tokens", jsonObj: jsonObj)
        let task = urlSession.dataTaskWithRequest(request!) { (data, response, error) in
            if let error = error {
                failure(error as NSError)
                return
            }
            let httpResponse = response as! NSHTTPURLResponse
            guard httpResponse.statusCode < 400 else {
                failure(VaultAPI.createError(
                    .BadResponse,
                    userInfo: ["status_code": NSNumber(integerLiteral: httpResponse.statusCode)]
                ))
                return
            }
            guard let data = data else {
                failure(VaultAPI.createError(.NoData))
                return
            }
            let jsonObj: Any
            do {
                jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                failure(VaultAPI.createError(.InvalidData))
                return
            }
            success(jsonObj as! [String: AnyObject])
        }
        task.resume()
        return task
    }

    private func makeRequest(method: String, path: String, jsonObj: AnyObject?) throws -> NSURLRequest? {
        let request = NSMutableURLRequest(URL: baseURL.URLByAppendingPathComponent(path)!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let obj = jsonObj {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions(rawValue: 0))
        }
        if let version = VaultAPI.frameworkVersion, let build = VaultAPI.frameworkBuild {
            request.addValue(
                "Vault-iOS-SDK/\(version) (build \(build))",
                forHTTPHeaderField: "User-Agent"
            )
        }
        let basicAuth = "\(publishableKey):".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        request.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
        return request as NSURLRequest
    }

    private static func createError(
        error: VaultAPIError,
        userInfo: [String: AnyObject]? = nil
    ) -> NSError {
        return NSError(
            domain: VaultError.errorDomain + errorDomainSuffix,
            code: error.rawValue,
            userInfo: userInfo
        )
    }
}
