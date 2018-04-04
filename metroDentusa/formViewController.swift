//
//  formViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/25/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import QuartzCore

class formViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate, setRowDelegate {
    
    /********* views *******/
    var menuButton : UIBarButtonItem!
    //var scrollView = UIScrollView()
    //var contentViewBottom : NSLayoutConstraint!
    //var contentView = UIView()
    var pickerPop = popUpPickerViewView()
    var pickerPopTop : NSLayoutConstraint!
    var invisibleView = UIView()
    var divider = UIView()
    var dividerTop : NSLayoutConstraint!
    var rollTableViewButton = UIButton()
    var tableView = UITableView()
    var resultsCountLabel = UILabel()
    var planTrigger = UIButton()
    var viewFormsButton = UIButton()
    var activityVC: UIActivityViewController?
    
    /******** data ********/
    private var user: member?
    private var planTypes = ["Select Plan", "AGMA HEALTH FUND PLAN B",
                     "AGMA HEALTH FUND PLAN B ACA",
                     "AMERICAN CIVIL LIBERTIES UNION",
                     "ASO EMPLOYEE BENEFIT PLAN",
                     "ASST DEPUTY WARDENS/DEPUTY WARDENS",
                     "BETHPAGE CONGRESS OF TEACHERS",
                     "BRICKLAYERS - PLAN A", "BRICKLAYERS - PLAN B",
                     "BRICKLAYERS - PLAN C", "BRICKLAYERS - RETIREES",
                     "CITYWIDE ASSOC OF LAW ASSISTANTS WF",
                     "CIVIL SERVICE BAR ASSOC",
                     "CONSOLIDATED EDISON CO OF NY INC",
                     "CORRECTION CAPTAINS ASSOC ACTIVITIES",
                     "CORRECTION CAPTAINS ASSOC ANNUITY FUNDS",
                     "CORRECTION CAPTAINS ASSOC RETIREES",
                     "CSA RETIREE WELFARE FUND",
                     "CSA WELFARE FUND",
                     "CWA LOCAL 1180 MEMBERS ANNUITY FUND",
                     "CWA LOCAL 1181 SECURITY BENEFITS (ACTIVE)",
                     "CWA LOCAL 1181 SECURITY BENEFITS (RETIREE)",
                     "DCC/CSA WELFARE FUND",
                     "DOCTOR'S COUNCIL WELFARE FUND",
                     "DOCTOR'S COUNCIL BENEFIT PLAN B",
                     "DOCTOR'S COUNCIL RETIREE WF",
                     "DRYWALL TAPERS INSURANCE FUNDS",
                     "FARMINGDALE FEDERATION OF TEACHERS",
                     "GRAPHIC COMMUNICATION LOCAL 612M",
                     "HALF HOLLOW HILLS TEACHERS ASSOCIATION WT",
                     "HASTINGS AUXILIARY PERSONNEL",
                     "HEASTINGS TEACHERS ASSOC",
                     "IATSE LOCAL ONE", "IATSE MEDICAL REIMBURSEMENT PROGRAM",
                     "IATSE NAT'L HEALTH & WELFARE FUND",
                     "IBEW LOCAL 1986",
                     "IMPERIAL TOBACCO RETIREE MEDICAL PLAN",
                     "INDUSTRY & LOCAL 338 P & W FU",
                     "IRONWORKERS L-580 SHOP",
                     "IRONWORKERS L40 - L361 - L417",
                     "LEVITTOWN UNITED TEACHERS"]
    
    private var clientIdArray = ["XXX", "V59", "V211", "V203", "V190", "066", "118",
                                 "V101", "V102", "V104", "V103", "150", "V33", "V165",
                                 "V41", "V114", "V39", "016", "015", "V83", "V46",
                                 "V47", "017", "002", "082", "010", "V136", "V32",
                                 "131", "V207", "031", "029", "V216", "V50", "113",
                                 "132", "V112", "049", "056", "091", "V3"]
    
    private var parameters : [String] = ["",""]
    var tableRolledDown: Bool = true
    var headingCellId = "headingCell"
    
    /************ Parser data ***********/
    var parser = XMLParser()
    var foundCharacters = ""
    var tempDoc = DocumentModel(name: "", docURL: "")
    private var documentsArray : [DocumentModel] = []
    
    
    
    
    init(user: member?){
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "Forms"
        self.toggleMenuButton(menuButton: menuButton)
        self.navigationController?.view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        setUpViewFormButton()
        setUpTableView()
        
        /****** For next version ********/
        //setUpScrollAndContentView()
        //setUpTriggerAndNeighbors()
        //initPickerPop()
        

        /*contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initPickerPop(){

        pickerPop.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerPop)
        pickerPop.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pickerPop.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pickerPop.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pickerPopTop = pickerPop.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        pickerPopTop.isActive = true
    }
    
    
    /*func setUpScrollAndContentView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        
    }*/
    
    func setUpTriggerAndNeighbors(){
        planTrigger.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(planTrigger)
        planTrigger.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        planTrigger.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        planTrigger.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -75).isActive = true
        planTrigger.heightAnchor.constraint(equalToConstant: 35).isActive = true
        planTrigger.setTitle(planTypes[0], for: .normal)
        planTrigger.setTitleColor(LoginSignUpViewController.defaultButtonTextColor, for: .normal)
        planTrigger.layer.borderWidth = 1
        planTrigger.addTarget(self, action: #selector(presentPickerPop), for: .touchUpInside)
        
        
        let selectPlanLabel = UILabel()
        selectPlanLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(selectPlanLabel)
        selectPlanLabel.bottomAnchor.constraint(equalTo: planTrigger.topAnchor, constant: -25).isActive = true
        selectPlanLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        selectPlanLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        selectPlanLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        selectPlanLabel.text = "Select Plan Type"
        selectPlanLabel.textColor = UIColor.lightGray
        selectPlanLabel.font = selectPlanLabel.font.withSize(19)
        
        viewFormsButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewFormsButton)
        viewFormsButton.topAnchor.constraint(equalTo: planTrigger.bottomAnchor, constant: 20).isActive = true
        viewFormsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        viewFormsButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        viewFormsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        viewFormsButton.setUpDefaultType(title: "View Forms")
        viewFormsButton.addTarget(self, action: #selector(getFormsForPlan), for: .touchUpInside)
        
    }
    
    func setUpViewFormButton(){
        
        viewFormsButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewFormsButton)
        viewFormsButton.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -90).isActive = true
        viewFormsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        viewFormsButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        viewFormsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        viewFormsButton.setUpDefaultType(title: "View Forms")
        viewFormsButton.addTarget(self, action: #selector(getFormsForPlan), for: .touchUpInside)
    }
    
    func setUpTableView(){
        invisibleView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(invisibleView)
        invisibleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        invisibleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        invisibleView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        invisibleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.85).isActive = true
        invisibleView.backgroundColor = UIColor.clear
        self.view.sendSubview(toBack: invisibleView)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(divider)
        dividerTop = divider.topAnchor.constraint(equalTo: viewFormsButton.bottomAnchor, constant: 20)
        dividerTop.isActive = true
        divider.leadingAnchor.constraint(equalTo: invisibleView.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: invisibleView.trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        divider.backgroundColor = UIColor(red: 206/255, green: 205/255, blue: 212/255, alpha: 1)
        
        rollTableViewButton.translatesAutoresizingMaskIntoConstraints = false
        divider.addSubview(rollTableViewButton)
        rollTableViewButton.centerXAnchor.constraint(equalTo: divider.centerXAnchor).isActive = true
        rollTableViewButton.centerYAnchor.constraint(equalTo: divider.centerYAnchor).isActive = true
        rollTableViewButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rollTableViewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rollTableViewButton.setTitle("\u{25B2}", for: .normal)
        rollTableViewButton.setTitleColor(UIColor(red: 60/255, green: 136/255, blue: 255/255, alpha: 1), for: .normal)
        rollTableViewButton.addTarget(self, action: #selector(rollUpTable), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: invisibleView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: invisibleView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: divider.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: headingCellId)
        tableView.register(cellClass: documentTableViewCell.self)
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
    }
    
    func setUpCountLabel(cContentView: UIView){
        resultsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        cContentView.addSubview(resultsCountLabel)
        resultsCountLabel.centerXAnchor.constraint(equalTo: cContentView.centerXAnchor).isActive = true
        resultsCountLabel.centerYAnchor.constraint(equalTo: cContentView.centerYAnchor).isActive = true
        resultsCountLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        resultsCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resultsCountLabel.font = resultsCountLabel.font.withSize(15)
        resultsCountLabel.textAlignment = .center
        resultsCountLabel.textColor = UIColor.darkGray
    }
    
    
    
    /*********************************** UIButton function *****************************/
    
    func getFormsForPlan(){
        guard user != nil else {
            promptAlertWithDelay("Log in to view your forms", inmessage: "Please log in to get your view your forms", indelay: 5.0)
            return
        }
        parameters[0] = (user?.getId())!
        parameters[1] = (user?.getClientId())!
        let activityIndicator = setUpActivityIndicator()
        DispatchQueue.global(qos: .background).async {
            activityIndicator.startAnimating()
            AppDelegate().makeHTTPPostRequestToGetPlanDocuments(urlString: "https://edi.asonet.com/httpserver.ashx?obj=plandocumentsHTML", parameters: self.parameters, completion: { (data: Data?) in
                if data != nil {
                    self.parser = XMLParser(data: data!)
                    self.parser.delegate = self
                    let parserDidSucceed = self.parser.parse()
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        //self.dismissPopUpPicker()
                        if parserDidSucceed {
                            self.tableView.reloadData()
                            self.rollUpTable()
                            self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                        } else {
                          print("parser error occured")
                        }
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
    
    func rollUpTable(){
        if tableRolledDown {
            dividerTop.isActive = false
            dividerTop = divider.topAnchor.constraint(equalTo: invisibleView.topAnchor)
            dividerTop.isActive = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.view.layoutIfNeeded()
                //self.divider.layoutIfNeeded()
                //self.tableView.layoutIfNeeded()
                self.rollTableViewButton.setTitle("\u{25BC}", for: .normal)
                self.tableRolledDown = false
            }, completion: nil)
        } else {
            dividerTop.isActive = false
            dividerTop = divider.topAnchor.constraint(equalTo: viewFormsButton.bottomAnchor, constant: 20)
            dividerTop.isActive = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                //self.divider.layoutIfNeeded()
                //self.tableView.layoutIfNeeded()
                self.view.layoutIfNeeded()
                self.rollTableViewButton.setTitle("\u{25B2}", for: .normal)
                self.tableRolledDown = true
            }, completion: nil)
        }
    }
    
    func setRow(row: Int) {
        loadPDFDoc(docName: documentsArray[row].name, urlString: documentsArray[row].docURL )
    }
    
    func loadPDFDoc(docName: String, urlString: String){
        let pdfAlert = UIAlertController(title: "Open PDF Document?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        pdfAlert.addAction(UIAlertAction(title: "Open", style: .default, handler: { (action: UIAlertAction) in
            guard let url = URL(string: urlString) else { return }
            let webView = UIWebView()
            let urlRequest = URLRequest(url: url)
            webView.loadRequest(urlRequest)
            
            let pdfVC = UIViewController()
            webView.translatesAutoresizingMaskIntoConstraints = false
            pdfVC.view.addSubview(webView)
            webView.topAnchor.constraint(equalTo: pdfVC.view.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: pdfVC.view.bottomAnchor).isActive = true
            webView.leadingAnchor.constraint(equalTo: pdfVC.view.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: pdfVC.view.trailingAnchor).isActive = true
            pdfVC.title = docName
            self.activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            let pdfTap = UITapGestureRecognizer(target: self, action: #selector(self.presentActivityVCInPDFView))
            pdfVC.view.addGestureRecognizer(pdfTap)
            self.setUpBackBarButton(title: "Forms")
            self.navigationController?.pushViewController(pdfVC, animated: true)
        }))
        pdfAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            pdfAlert.dismiss(animated: true, completion: nil)
        }))
        present(pdfAlert, animated: true, completion: nil)
    }
    
    func presentActivityVCInPDFView(){
        present(activityVC!, animated: true, completion: nil)
    }
    
    
   
    
    
    
    /*************************************************** tableView delegate functions *******************************************/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return documentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            let htvc = tableView.dequeueReusableCell(withIdentifier: headingCellId, for: indexPath)
            setUpCountLabel(cContentView: htvc.contentView)
            resultsCountLabel.text = String(describing: documentsArray.count) + " documents are included in your plan"
            cell = htvc
        } else {
            let dtvc = tableView.dequeueReusableCell(ofType: documentTableViewCell.self, for: indexPath)
            let row = indexPath.row
            dtvc.setUpView()
            dtvc.setText(text: documentsArray[row].name)
            dtvc.setRowDelegate = self
            dtvc.row = row
            dtvc.cellButton.addTarget(dtvc, action: #selector(dtvc.setRowTrigger), for: .touchUpInside)
            cell = dtvc
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 30
        }
        return 40
    }
    
    /**************************** pickerView related functions ***************************/
    func presentPickerPop(){
        pickerPopTop.isActive = false
        pickerPopTop = pickerPop.topAnchor.constraint(equalTo: viewFormsButton.bottomAnchor, constant: 20)
        pickerPopTop.isActive = true
        

        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        pickerPop.barLabel.text = "Change Plan"
        pickerPop.pickerView.delegate = self
        pickerPop.pickerView.dataSource = self
        
        pickerPop.closeButton.addTarget(self, action: #selector(dismissPopUpPicker), for: .touchUpInside)
        
    }
    
    func dismissPopUpPicker(){
        pickerPopTop.isActive = false
        pickerPopTop = pickerPop.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        pickerPopTop.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return planTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return planTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        planTrigger.setTitle(planTypes[row], for: .normal)
        parameters[1] = clientIdArray[row]
    }
    
    /*********************************************** xmlParserDelegate functions **************************************/
    func parserDidStartDocument(_ parser: XMLParser) {
        documentsArray.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        return
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "formurl"{
            self.tempDoc.docURL = self.foundCharacters
        }
        if elementName == "formdescription" {
            self.tempDoc.name = self.foundCharacters
        }
        if elementName == "planform" {
            self.documentsArray.append(self.tempDoc)
            self.tempDoc.clearParams()
        }
        self.foundCharacters = ""
        return
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for item in documentsArray {
            print("\(item)\n")
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure Error: \(parseError)")
    }
    
    
}
