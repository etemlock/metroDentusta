//
//  BlogViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/2/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class BlogViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    var menuButton : UIBarButtonItem!
    var scrollView: UIScrollView!
    var logoView: UIImageView!
    var tableView = UITableView()
    
    /**********XML Parsing data *********/
    var parser = XMLParser()
    var foundCharacters = ""
    var blogPostParamsArray : [blogPostParams] = []
    var tempPost = blogPostParams(title: "",date: "",author: "", categories: [], description: "", blogLink: "", image: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.toggleMenuButton(menuButton: menuButton)
        setUpScrollView()
        setUpLogoView()
        setUpTableView()
        setUpParser()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orient = UIDevice.current.orientation
        for cell in tableView.visibleCells  {
            let bCell = cell as! blogTableCell
            bCell.parentViewDidTransition(orientation: orient)
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func setUpScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
    }
    
    func setUpLogoView(){
        logoView = UIImageView(frame: CGRect(x: scrollView.center.x - 70, y: 15, width: 140, height: 40))
        logoView.image = UIImage(named: "Logo Icon")
        logoView.contentMode = .scaleToFill
        scrollView.addSubview(logoView)
    }
    
    func setUpTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        //let tableminY = logoView.frame.maxY + 25
        //tableView = UITableView(frame: CGRect(x: 0, y: tableminY, width: scrollView.frame.width, height: scrollView.frame.height - tableminY))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(blogTableCell.self, forCellReuseIdentifier: "blogCell")
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        //scrollView.addSubview(tableView)
    }
    
    func setUpParser(){
        let activityIndicator = setUpActivityIndicator()
        DispatchQueue.global(qos: .background).async {
            activityIndicator.startAnimating()
            AppDelegate().downloadDataFromURL(urlString: "http://metrodentusa.com/feed", completion: { (data) in
                if data != nil {
                    print("there was data")
                    if let dataString = String(data: data!, encoding: .utf8){
                        print("\(dataString)")
                    }
                    self.parser = XMLParser(data: data!)
                    self.parser.delegate = self
                    let parserDidSuceed = self.parser.parse()
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        print("\(parserDidSuceed)")
                    }
                } else {
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        print("no data aquired")
                    }
                }
            })
        }
    }
    
    /*************************************************************** tableView functions *********************************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPostParamsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! blogTableCell
        cell.setUpCell(params: blogPostParamsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 335
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? blogTableCell {
            if let url = URL(string: cell.link){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    /*************************************************************** XMLParser Delegate ************************************************/
    func getFirstPTagInDescription(descriptionString: String) -> String {
        let startIndex = descriptionString.index(descriptionString.startIndex, offsetBy: 3)
        let indicies = descriptionString.characters.indices
        var doneIndex = descriptionString.endIndex
        for index in indicies[startIndex..<descriptionString.endIndex]{
            if descriptionString[index] == "<"{
                let endTag = descriptionString.index(index, offsetBy: 4)
                let substr = descriptionString.substring(with: index..<endTag)
                if substr == "</p>"{
                    doneIndex = index
                    break
                }
            }
        }
        return descriptionString.substring(with: startIndex..<doneIndex)
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        return
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let elementString = self.foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        if elementName == "title" {
            self.tempPost.title = elementString
        }
        if elementName == "link" {
            self.tempPost.blogLink = elementString
        }
        if elementName == "pubDate"{
            let index = elementString.index(elementString.startIndex, offsetBy: 16)
            self.tempPost.date = elementString.substring(to: index)
        }
        if elementName == "dc:creator"{
            self.tempPost.author = elementString
        }
        if elementName == "category"{
            self.tempPost.categories.append(elementString)
        }
        if elementName == "description"{
            self.tempPost.description = getFirstPTagInDescription(descriptionString: elementString)
        }
        if elementName == "item" {
            self.blogPostParamsArray.append(self.tempPost)
            self.tempPost.clearParams()
        }
        self.foundCharacters = ""
        return
    }
    
    /*func parserDidEndDocument(_ parser: XMLParser) {
        for item in blogPostParamsArray {
            print("\(item)\n")
        }
    }*/
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure Error: \(parseError)")
    }
    
    
    
}
