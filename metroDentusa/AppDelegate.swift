//
//  AppDelegate.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    typealias CompletionHandler = (_ data : Data?, _ errorDesc: String?) -> Void
    //static var xmlStringCache = [String: Data]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func downloadDataFromURL(urlString: String, completion: @escaping (_ data: Data?)->Void){
        let session = URLSession.shared
        let url = URL(string: urlString)
        let task = session.dataTask(with: url!, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            if (error != nil) {
                print("there was an error : \(error)")
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let httpStatusCode = httpResponse?.statusCode {
                    print("status code is \(httpStatusCode)")
                } 
                
                completion(data)
            }
        })
        task.resume()
    }
    
    func AlamofireHandlePostRequest(request: URLRequest, completion: @escaping (_ error: Error?, _ data: Data?) -> Void){
        
        /*if let cachedData = AppDelegate.xmlStringCache[postStmt]{
            print("This data was cached")
            completion(nil,cachedData)
        } else {*/
            Alamofire.request(request).responseData(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let status = response.response?.statusCode {
                        print("status code is \(status)")
                    }
                    
                    if let result = response.data{
                        //AppDelegate.xmlStringCache[postStmt] = result
                        completion(nil,result)
                    }
                } else {
                    if let error = response.result.error {
                        print("Unsuccessful response error: \(error.localizedDescription)")
                        
                        completion(error,nil)
                    } else {
                        print("unknown error")
                        completion(nil,nil)
                    }
                }
            })
        //}
    }
    
    func prepareRequest(url: URL, requestString: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpBody = requestString.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    func makeHTTPPOSTRequestToGetUser(urlstring: String, loginInputs: [String], completion: @escaping CompletionHandler /*completion: @escaping ( _ data: Data?)->Void*/){
        if let myUrl = URL(string: urlstring){
            let queryString = "<request type='LOGINMEMBER'  username='\(loginInputs[0])' password='\(loginInputs[1])' StyleSheet='xml' SessionID=''></request>"
            print("\(queryString)")
            let request = prepareRequest(url: myUrl, requestString: queryString)
            
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data, nil)
                    //completion(data)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    func makeHTTPPostRequestToCreateUser(urlString: String, createInputs: [String], completion: @escaping CompletionHandler /*(_ data: Data?)->Void*/){
        if let myUrl = URL(string: urlString){
            let queryString = "<userinfo type='newuserprofile' StyleSheet='xml'><newuservalidation checkuser='Y' MemberLast4='\(createInputs[0])' MemberBirthdate='\(createInputs[1])' MemberZipCode='\(createInputs[2])' StyleSheet='xml'></newuservalidation></userinfo>"
            let request = prepareRequest(url: myUrl, requestString: queryString)
            
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data, nil)
                    //completion(data)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    func makeHTTPPostRequestToSaveUser(urlString: String, params: SaveUserParams, completion: @escaping CompletionHandler
        /*(_ data: Data?)->Void*/){
        if let myUrl = URL(string: urlString){
            let newName = params.getName(getConfirmField: false)
            let newNameCfrm = params.getName(getConfirmField: true)
            let newPass = params.getPass(getConfirmField: false)
            let newPassCfrm = params.getPass(getConfirmField: true)
            let usrMail = params.getMail(getConfirmField: false)
            let question1 = params.getSecurityQuestion1()
            let answer1 = params.getAnswer1()
            let question2 = params.getSecurityQuestion2()
            let answer2 = params.getAnswer2()
            let sessionId = params.getSessionID()
            let suId = params.getSuID()
            let queryString = "<userinfo newusername='\(newName)' newusernameconfirm='\(newNameCfrm)' newpassword='\(newPass)' newpasswordconfirm='\(newPassCfrm)' useremailaddress='\(usrMail)' securityquestion1='\(question1)' securityanswer1='\(answer1)' securityquestion2='\(question2)' securityanswer2='\(answer2)' StyleSheet='xml' sessionguid='\(sessionId)' suid='\(suId)'></userinfo>"
            print("\(queryString)")
            let request = prepareRequest(url: myUrl, requestString: queryString)
            
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data, nil)
                    //completion(data)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }

        
    
    func makeHTTPPostRequestToSearchDentists(urlstring: String, parameters: dentSearchParams, completion: @escaping (_ jsonResults: [[String: Any]]?, _ errorDesc : String?)->Void){
        if let myUrl = URL(string: urlstring){
            /*570 ATLANTIC AVE LAWRENCE NY 11559*/
            var searchBy = "city"
            if parameters.patientzip != ""{
                searchBy = "distance"
            }
            
            let xmlString = "<pposearch type='dentistearch'><parameters network='V190' patientzip='\(parameters.patientzip)' distance='\(parameters.distance)' specialty='\(parameters.specialty)' providername='\(parameters.dentName)' state='\(parameters.state)' county='' displaytype='J' linelist='Y'></parameters><orderby order='\(searchBy)'></orderby><inhouse ></inhouse></pposearch>"
            var xmlRequest = URLRequest(url: myUrl)
            xmlRequest.httpBody = xmlString.data(using: .utf8)
            xmlRequest.httpMethod = "POST"
            xmlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            AlamofireHandlePostRequest(request: xmlRequest, completion: { (error: Error?, data: Data?) in
                guard error == nil else {
                    completion(nil,error?.localizedDescription)
                    return
                }
                if data != nil {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]{
                            if let results = jsonDict["results"] as? [[String: Any]] {
                                completion(results, nil)
                            }
                        }
                    } catch let error {
                        print("JSONSerialization Error : \(error.localizedDescription)")
                        let jsonDescription = "There were no results matching the query provided"
                        completion(nil, jsonDescription)
                    }
                }
            })
        }
    }
    
    func makeHTTPPostRequestToGetPlanDocuments(urlString: String, user: member, completion: @escaping CompletionHandler /*(_ data : Data?) -> Void*/){
        if let myUrl = URL(string: urlString){
            let queryString = "<request type='plandocumentsHTML'  StyleSheet='xml' memberid='\(user.getMemberId()) ' ClientID='\(user.getClientId())' sessionguid='a'></request>"
            let request = prepareRequest(url: myUrl, requestString: queryString)
            
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data, nil)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    func makeHTTPPostRequestToViewClaims(urlString: String, userDetails: member, completion: @escaping CompletionHandler /*(_ data: Data?) -> Void*/ ){
        if let myUrl = URL(string: urlString){
            let queryString = "<request type='serviceHistoryHTML' UserID='' MemberID='\(userDetails.getMemberId())' ClientID='\(userDetails.getClientId())' StartDate='' EndDate='' Specialty='' FamilyID='' ShowFilter='Y' Tooth='' Code='' Benefit='' Order='' Claim='' ShowServiceDetail='true' MemberServices='' SessionID='' sessionguid='a' StyleSheet='xml'></request>"
            let request = prepareRequest(url: myUrl, requestString: queryString)
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data,nil)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    func makeHTTPPostRequestToGetQuestions(urlString: String, username: String, completion: @escaping CompletionHandler /*(_ data: Data?) -> Void*/){
        if let myUrl = URL(string: urlString){
            let queryString = "<user type='showusersecurityq' UserName='\(username)' StyleSheet='xml'></user>"
            let request = prepareRequest(url: myUrl, requestString: queryString)
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data,nil)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    func makeHTTPPostRequestToEmailPassword(urlString: String, username: String, answer1: String, answer2: String, completion: @escaping CompletionHandler /*(_ data: Data?) -> Void*/){
        if let myUrl = URL(string: urlString){
            let queryString = "<user type='submitusersecurityq' UserName='\(username)' Answer1='\(answer1)' Answer2='\(answer2)' StyleSheet='xml'></user>"
            print("\(queryString)")
            let request = prepareRequest(url: myUrl, requestString: queryString)
            
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data, nil)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    func makeHTTPPostRequestToChangePassword(urlString: String, userName: String, tempPass: String, newPassword: String, confirmPassword: String, completion: @escaping CompletionHandler /*(_ data: Data?) -> Void*/){
        if let myUrl = URL(string: urlString){
            let requestString = "<userinfo username='\(userName)' temppassword='\(tempPass)' newpassword='\(newPassword)' newpasswordconfirm='\(confirmPassword)' StyleSheet='xml' SessionID='' sessionguid=''></userinfo>"
            print("\(requestString)")
            let request = prepareRequest(url: myUrl, requestString: requestString)
            
            AlamofireHandlePostRequest(request: request, completion: { (error: Error?, data: Data?) in
                if data != nil {
                    completion(data, nil)
                } else if error != nil {
                    completion(nil, error?.localizedDescription)
                }
            })
        }
    }
    
    /*public enum requestError: Error {
        init? (type: String, message: String){
            switch type {
                case "connection":
                    self.init(
            }
        }
    }*/
    
            

}

