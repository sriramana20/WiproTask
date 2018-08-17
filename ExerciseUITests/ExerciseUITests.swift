//
//  ExerciseUITests.swift
//  ExerciseUITests
//
//  Created by sriramana on 8/1/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import XCTest
import Foundation

class ExerciseUITests: XCTestCase {
    
    let session = TempURLSession()
    let urlStr = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts"
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func get( url: URL, callback: @escaping completeClosure ) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, error)
        }
        task.resume()
    }
    
    func test_get_request_with_URL() {
        
        guard let url = URL(string: urlStr) else {
            fatalError("URL can't be empty")
        }
        self.get(url: url) { (success, response) in
            // Return data
        }
        XCTAssert(session.lastURL == url)
    }
    
    func test_get_should_return_data() {
        let expectedData = "{}".data(using: .utf8)
        session.nextData = expectedData
        
        var actualData: Data?
        self.get(url: URL(string: urlStr)!) { (data, error) in
            actualData = data
        }
        XCTAssertNotNil(actualData)
    }
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

class TempURLSession: URLSessionProtocol {
    
    var nextDataTask = TempURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: NSURLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
    
}

class TempURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
