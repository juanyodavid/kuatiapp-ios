//
//  pesajeVC.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-10-03.
//

import UIKit
import NotificationBannerSwift

class pesajeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var lecturaActivate : Bool = false
    @IBAction func writeDownButton(_ sender: UIButton!) {
        self.timer?.invalidate()
        self.timer = nil
        let storyboard = UIStoryboard(name: "listaCaravanas", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "saveCaravanaID")
        self.present(vc, animated: true, completion: nil)
    }
    @IBOutlet weak var singleCaravanaButton: UIBarButtonItem!
    @IBOutlet weak var CaravanasTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ipLabel : UILabel!
    @IBAction func pararLecturaButton(_ sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
        lecturaActivate = true
    }
    
    @IBAction func continuarLecturaButton(_ sender: UIButton) {
        if (lecturaActivate == true){
            refresh()
        }
        lecturaActivate = false
    }
    @IBAction func singleCaravanaButton(_ sender: UIButton) {
        self.timer?.invalidate()
            self.timer = nil
        changeScene(Storyboard: "listaCara  vanas", VCid: "caravanaVCID")
//        let alert = UIAlertController(title: "Record Inserted", message:
//        "Record Inserted", preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "Ok",
//        style:UIAlertAction.Style.default, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
    }
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        CaravanasTableView.dataSource = self
        CaravanasTableView.register(UINib(nibName: "PesajeTableViewCell", bundle: nil), forCellReuseIdentifier: "PesajeTableViewCell")
        CaravanasTableView.delegate = self
        nameLabel.text = lectorActual[0]
        ipLabel.text = lectorActual[1]
        print(lectorActual)
        fetchService(ip: lectorActual[1],activateRefresh: true)
    }
    //MARK: Table Validiations
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        print(caravanasList[0])
            if (caravanasList[0]==""){ // si no viene ninguna informacion imprimir vacio
                return 0
            }else{
                return caravanasList.count//retorna el numero de filas
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = CaravanasTableView.dequeueReusableCell(withIdentifier: "PesajeTableViewCell", for: indexPath)
            if let newCell = cell as? PesajeTableViewCell {
                // imprimos cada cell, con esta info
                let value = caravanasList[indexPath[1]]
                newCell.setupCell(numero: "\(indexPath[1]+1)-\(value)",peso: "vacio")
            }
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let value = ipList[indexPath[1]]
    //        lectorActual = value!
            let alertController = UIAlertController(title: "Cambiar peso", message: nil, preferredStyle: .alert)
            alertController.addTextField()
            let submit = UIAlertAction(title: "Cambiar", style: .default){
                (alert) in
                if let textField = alertController.textFields?.first{
//                    self.names[indexPath.row] = textField.text ?? "Sin nombre"
                    self.CaravanasTableView.reloadData()
                }
            }
            alertController.addAction(submit)
            self.present(alertController,animated: true,completion: nil)
    //        changeScene(Storyboard: "listaCaravanas", VCid: "listaCaravanasID")
        }
    //MARK: Private Func
        private func refresh() {
            func doSomrThing(str: String) {
                fetchService(ip:lectorActual[1],activateRefresh: false)
                self.CaravanasTableView.reloadData()
                self.CaravanasTableView.refreshControl?.endRefreshing()
                print(str)
            }

            doSomrThing(str: "first time")

            self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
                doSomrThing(str: "after 2.0 second en la lista larga de caravanas")
            }
            )

        }
        private func fetchService(ip : String,activateRefresh:Bool) {
            let endPointString = "http://\(ip)/app/api-lista/index.json"
            print ("el endpoint es :\(endPointString)")
            guard let endpoint = URL(string: endPointString) else {
                print("no se llega al link")
                return
            }
            
            URLSession.shared.dataTask(with: endpoint) { (data: Data?, _, error: Error?) in
                DispatchQueue.main.async {
                    if (error != nil) {
                    NotificationBanner(title: "Error", subtitle: "No se pudo detectar la Ip", style: .danger).show()
                    print("hubo un error")
                    return
                    }


                }
                //aca ya que no tenemos una estructura clara, usamos serialization, si se quiere hacer de una manera mas simple, ver "listaCaravanaViewController.swift"
                guard let dataFromService = data,
                      let dictionary = try? JSONSerialization.jsonObject(with: dataFromService, options: []) as? [String: Any] else {
                          return
                }
                DispatchQueue.main.async { [self] in
                    guard let caravanas = dictionary["caravanas"] as? [String] else {
                        NotificationBanner(title: "Error", subtitle: "No se pudo detectar la caravana o problema de lectura en el servidor", style: .danger).show()
                        return
                    }
                    if (activateRefresh == true){//sirve para que el refresh se ejecute una sola vez y no sea recursivo
                        refresh()
                    }
                    caravanasList = caravanas
                    print("la lectura es \(caravanasList) ")
                }
            }.resume()
        }
        private func saveFile(){
            
        }
        
        private func changeScene(Storyboard:String,VCid:String){
            let storyboard = UIStoryboard(name: Storyboard, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: VCid)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)

        }

}
