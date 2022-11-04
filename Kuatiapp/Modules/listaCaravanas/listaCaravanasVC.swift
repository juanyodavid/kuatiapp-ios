//
//  listaCaravanasVC.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-13.
//

import UIKit
import NotificationBannerSwift

var caravanasList:[String] = [""]
var pesoList:[Int] = []
class listaCaravanasVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
//MARK: GLOBAL VAR
//MARK: OUTLETS
    var lecturaActivate : Bool = false
    @IBAction func writeDownButton(_ sender: UIButton!) {
        self.timer?.invalidate()
        self.timer = nil
        if !validarPeso(){
            let storyboard = UIStoryboard(name: "listaCaravanas", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "saveCaravanaID")
            self.present(vc, animated: true, completion: nil)
        }
        
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
        changeScene(Storyboard: "listaCaravanas", VCid: "caravanaVCID")
        
    }
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        CaravanasTableView.dataSource = self
        CaravanasTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
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
        let cell = CaravanasTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        if let newCell = cell as? TableViewCell {
            // imprimos cada cell, con esta info
            let value = caravanasList[indexPath[1]]
            newCell.setupCell(numero: "\(indexPath[1]+1)-\(value)",peso:pesoList[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if actualSelection == "pesaje" {
            pesaje(indexValue: indexPath.row)
        }
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
                weightAddZero()
                print("la cantidad de 0 es \(pesoList.count) y la de caravanas es \(caravanasList.count)")
                print("la lectura es \(pesoList) ")
            }
        }.resume()
    }
    private func changeScene(Storyboard:String,VCid:String){
        let storyboard = UIStoryboard(name: Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: VCid)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    private func pesaje(indexValue : Int){
        let alertController = UIAlertController(title: "Cambiar peso", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let submit = UIAlertAction(title: "Cambiar", style: .default){
            (alert) in
            if let textField = alertController.textFields?.first{
                if let number = NumberFormatter().number(from: textField.text ?? "0") {
                    let intvalue = number.intValue
                    pesoList[indexValue] = intvalue
                  }
                self.CaravanasTableView.reloadData()
            }
        }
        alertController.addAction(submit)
        self.present(alertController,animated: true,completion: nil)
    }
    private func weightAddZero(){
        let range = caravanasList.count - pesoList.count
        for _ in stride(from: 0, to: range, by: 1){
            pesoList.append(0)
        }
    }
    private func validarPeso() -> Bool {
        var pesosIncompletos = ""
        var index = 0
        for peso in pesoList{
            if peso == 0{
                pesosIncompletos = pesosIncompletos + "#\(index+1) "
            }
            index = index + 1
        }
        if (pesosIncompletos != "" && actualSelection == "pesaje"){
            NotificationBanner(title: "Cuidado", subtitle: "Completar pesos de:\(pesosIncompletos)", style: .warning).show()
            return true
            }
        else{
            return false
        }
        
    }
}
