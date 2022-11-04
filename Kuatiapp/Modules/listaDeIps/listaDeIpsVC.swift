//
//  listaDeIpsVC.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-06.
//
import PopupDialog
import UIKit
import CSV
var actualSelection = "" //vacunacion","lote","pesaje
var ipList :[Int:[String]] = [0:["",""]]
public var lectorActual: [String] = ["",""]
class listaDeIpsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //MARK: OUTLETS
    @IBOutlet weak var IpTableView: UITableView!
    @IBOutlet weak var archivosButton: UIBarButtonItem!
    @IBOutlet weak var vacioLabel: UILabel!
    @IBAction func archivosButtonAction(){
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
//        changeScene(Storyboard: "listaFiles", VCid: "listaFilesID")
    }
    //MARK: GLOBAL VAR
    var selectedRow = 0
    var totalFilas = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        IpTableView.dataSource = self
        totalFilas = csvList()
        IpTableView.register(UINib(nibName: "IpTableViewCell", bundle: nil), forCellReuseIdentifier: "IpTableViewCell")
        IpTableView.delegate = self
    }
    //MARK: Table Validiations

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (totalFilas == 0){
            vacioLabel.text = "No tienes lectores guardados"
        }else{
            vacioLabel.text = ""
        }
        return totalFilas//retorna el numero de filas
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IpTableView.dequeueReusableCell(withIdentifier: "IpTableViewCell", for: indexPath)
        if let newCell = cell as? IpTableViewCell {
            // imprimos cada cell, con esta info
            let value = ipList[indexPath[1]]
            newCell.setupCell(nombre: value![0], direction: value![1])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = ipList[indexPath[1]]
        lectorActual = value!
        infoMessages(titulo: "\(lectorActual[0]): \(lectorActual[1])", mensaje: "Seleccione la acción que desea realizar")
    }

// MARK: Private functions
    private func csvList() -> Int {
        let direction = csvPath()
        // si se creo el archivo no se imprime nada
        if (direction == "emptyPath"){
            return 0
        }
        let stream = InputStream(fileAtPath: direction)!
        print("el stream es:\(direction)")
        let csv = try? CSVReader(stream: stream,hasHeaderRow: true)
        if (csv == nil){
            return 0
        }
        var total = 0
        while let row = csv?.next() {
            ipList[total]=[row[0],row[1]]
            total = total + 1
//            print("\(total)")
        }
//        print(ipList)
//        _ = ipList.removeValue(forKey: 0)
//        print(ipList)
        return total
    }
    private func csvPath() -> String{
        let manager = FileManager.default
        guard let url = manager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return "error"
        }
        // creamos el folder kuatiapp
        let appFolder = url.appendingPathComponent("kuatiapp")
        //creamos el folder "ipFolder"
        let ipFolder = appFolder.appendingPathComponent("ipFolder")
        let ipValuesFile = ipFolder.appendingPathComponent("ipValuesFile.csv")
        do{
            if manager.fileExists(atPath: ipValuesFile.path){
                return ipValuesFile.path
        }
            else{
                print("la lista esta vacia")
            }
        }
        return "emptyPath"
    }
    private func changeScene(Storyboard:String,VCid:String){
        let storyboard = UIStoryboard(name: Storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: VCid)
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: AnyObject.self)
        
    }

    private func infoMessages(titulo: String, mensaje: String){
        // Prepare the popup assets
        
        let title = titulo
        let message = mensaje
        let image = UIImage(named: "pexels-photo-103290")
        let popup = PopupDialog(title: title, message: message, image: image)
        let cancelar = CancelButton(title: "Cancelar") {
            print("You canceled the car dialog.")
        }
        let agregarLote = DefaultButton(title: "Agregar lote", dismissOnTap: true) {
            actualSelection = "lote"
            self.changeScene(Storyboard: "listaCaravanas", VCid: "listaCaravanasID")
        }
        let agregarPesaje = DefaultButton(title: "Agregar pesaje", dismissOnTap: true) {
            actualSelection = "pesaje"
            self.changeScene(Storyboard: "listaCaravanas", VCid: "listaCaravanasID")
        }
        let agregarVacunacion = DefaultButton(title: "Agregar vacunación", dismissOnTap: true) {
            actualSelection = "vacunacion"
            self.changeScene(Storyboard: "listaCaravanas", VCid: "listaCaravanasID")

        }
        let limpiarBuffer = DefaultButton(title: "Vaciar lectura anterior", dismissOnTap: true) {
            caravanasList = [""]
            pesoList = []
            
        }

        if caravanasList == [""]{
            popup.addButtons([agregarLote,agregarPesaje,agregarVacunacion,cancelar])
        }
        else{
            popup.addButtons([agregarLote,agregarPesaje,agregarVacunacion,limpiarBuffer,cancelar])

        }
        // Present dialog
        self.present(popup, animated: true, completion: nil)

    }
}
