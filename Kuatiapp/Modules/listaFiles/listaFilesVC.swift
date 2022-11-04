//
//  listaFilesVC.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-13.
//

import UIKit

class listaFilesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var listOfFiles : [String] = []

    @IBAction func shareButton(_ sender: Any) {
//        let shareSheetVC = UIActivityViewController(activityItems: ["ou"], applicationActivities: nil)
//        present(shareSheetVC,animated: true)
        //Set the default sharing message.
//               let message = "Message goes here."
//               //Set the link to share.
//               if let link = NSURL(string: "http://yoururl.com")
//               {
//                   let objectsToShare = [message,link] as [Any]
//                   let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                   activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//                   self.present(activityVC, animated: true, completion: nil)
//               }
        //////////////////////
//        let objectsToShare = [NSURL(string: "http://youtube.com")]
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                activityVC.title = "Share One"
//                activityVC.excludedActivityTypes = []
//
//                activityVC.popoverPresentationController?.sourceView = self.view
//        activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
//
//        self.present(activityVC, animated: true, completion: nil)
        lazy var applicationSupportURL: URL = {
                let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
                return urls[0]
        }()
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsUrl)
//        if let sharedUrl = URL(string: "\(filename)") {
//            print(sharedUrl)
//            if UIApplication.shared.canOpenURL(sharedUrl) {
//                UIApplication.shared.open(url, options: [:])
//            }
//        }
        print(applicationSupportURL)
    }
    @IBOutlet weak var ListaTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ListaTableView.dataSource = self
        ListaTableView.register(UINib(nibName: "FilesTableViewCell", bundle: nil), forCellReuseIdentifier: "FilesTableViewCell")
        ListaTableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return csvPath()//retorna el numero de filas
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListaTableView.dequeueReusableCell(withIdentifier: "FilesTableViewCell", for: indexPath)
        if let newCell = cell as? FilesTableViewCell {
            // imprimos cada cell, con esta info
            let value = listOfFiles[indexPath[1]]
            newCell.setupCell(nombre: value )
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = listOfFiles[indexPath[1]]
        print(value)
        let manager = FileManager.default
        guard let url = manager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return
        }
        // creamos el folder kuatiapp
        let appFolder = url.appendingPathComponent("kuatiapp")
        //creamos el folder "ipFolder"
        let filesFolder = appFolder.appendingPathComponent("filesFolder")

        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsUrl)
        if let sharedUrl = URL(string: "shareddocuments://\(filesFolder.path)") {
            print(sharedUrl)
            if UIApplication.shared.canOpenURL(sharedUrl) {
                UIApplication.shared.open(sharedUrl, options: [:])
            }
        }
        ///
        ///
        ///
        ///
        ///
        /////////

    }
    
    private func csvPath() -> Int {
        let manager = FileManager.default
        guard let url = manager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return 0
        }
        // creamos el folder kuatiapp
        let appFolder = url.appendingPathComponent("kuatiapp")
        //creamos el folder "ipFolder"
        let filesFolder = appFolder.appendingPathComponent("filesFolder")
        guard let data = try? manager.contentsOfDirectory(atPath: filesFolder.path) else {
            print("No se pudo cargar entre los archivos ")
            return 0
        }
        print(data)
        listOfFiles = data
        return data.count
    }
    @objc private func presentShare(){
        let shareSheetVC = UIActivityViewController(activityItems: ["ou"], applicationActivities: nil)
        present(shareSheetVC,animated: true)
        
    }
    
}
