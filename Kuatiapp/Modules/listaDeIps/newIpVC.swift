//
//  newIpVC.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-06.
//

import UIKit
import NotificationBannerSwift
import CSV

class newIpVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var ipDirection1input: UITextField!
    @IBOutlet weak var ipDirection2input: UITextField!
    @IBOutlet weak var ipDirection3input: UITextField!
    @IBOutlet weak var ipDirection4input: UITextField!

    @IBOutlet weak var nameReaderInput: UITextField!
    @IBOutlet weak var addReaderButton: UIButton!
    // MARK: Actions
    @IBAction func addReaderButtonAction(){
        if performAdd() == 0{
            addIpListIfNotExistAndAdd()
            changeScene()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("se ejecuta la vista")
    }
  
    
    // MARK: Private functions
    private func performAdd() -> Int{
        // validar: que no ponga ","
        var errores = 0
        print("performing Add:")
        guard let ipdirection1 = ipDirection1input.text,!ipdirection1.isEmpty else{
            NotificationBanner(title:"Error", subtitle:"Debes completar este campo", style: .warning).show()
            errores = 1
            return errores
        }
        guard let ipdirection2 = ipDirection2input.text,!ipdirection2.isEmpty else{
            NotificationBanner(title:"Error", subtitle:"Debes completar este campo", style: .warning).show()
            errores = 1
            return errores
        }
        guard let ipdirection3 = ipDirection3input.text,!ipdirection3.isEmpty else{
            NotificationBanner(title:"Error", subtitle:"Debes completar este campo", style: .warning).show()
            errores = 1
            return errores
        }
        guard let ipdirection4 = ipDirection4input.text,!ipdirection4.isEmpty else{
            NotificationBanner(title:"Error", subtitle:"Debes completar este campo", style: .warning).show()
            errores = 1
            return errores
        }
        guard let ipname = nameReaderInput.text,!ipname.isEmpty else{
            NotificationBanner(title:"Error", subtitle:"Debes completar este campo", style: .warning).show()
            errores = 1
            return errores
        }
        return errores
    }

    private func addIpListIfNotExistAndAdd() {
        // validar para que nunca sean vacios el nombre y la direccion
        let ipdireccion1 = ipDirection1input.text ?? "0"
        let ipdireccion2 = ipDirection2input.text ?? "0"
        let ipdireccion3 = ipDirection3input.text ?? "0"
        let ipdireccion4 = ipDirection4input.text ?? "0"
        let ipname = nameReaderInput.text ?? "vacio"
        let ipdireccion = "\(ipdireccion1).\(ipdireccion2).\(ipdireccion3).\(ipdireccion4)"
        let data = "name,ipdirection \n\(ipname),\(ipdireccion)" /// este es el titulo de las columnas del CSV
        print ("el dato es: \(data)")
        let valor = data.data(using: .utf8)
        // trae el path en el que se guardan los datos
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
        let ipFolder = appFolder.appendingPathComponent("ipFolder")
        do{
            try manager.createDirectory(
                at: ipFolder,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        }
        catch {
            print(error)
        }
        print ("el path es: \(ipFolder.path)") // este imprime en que parte esta el folder que tiene el archivo json
        // aca se crea el archivo
        let ipValuesFile = ipFolder.appendingPathComponent("ipValuesFile.csv")
        do{
            if manager.fileExists(atPath: ipValuesFile.path){
                print ("CSV ip lista EXISTE")
                addIp()
        }
            else{ //si no existe el archivo Json, lo crea
                manager.createFile(
                    atPath: ipValuesFile.path,
                    contents: valor,
                    attributes: [FileAttributeKey.creationDate : Date()])
            }
        }
        
    }
    private func addIp(){
        // validar para que nunca sean vacios el nombre y la direccion
        let ipdireccion1 = ipDirection1input.text ?? "0"
        let ipdireccion2 = ipDirection2input.text ?? "0"
        let ipdireccion3 = ipDirection3input.text ?? "0"
        let ipdireccion4 = ipDirection4input.text ?? "0"
        let ipname = nameReaderInput.text ?? "vacio"
        let ipdireccion = "\(ipdireccion1).\(ipdireccion2).\(ipdireccion3).\(ipdireccion4)"
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
        let ipFolder = appFolder.appendingPathComponent("ipFolder")
        let ipValuesFile = ipFolder.appendingPathComponent("ipValuesFile.csv")
        if manager.fileExists(atPath: ipValuesFile.path){
            let stream = OutputStream(toFileAtPath: ipValuesFile.path, append: true)!
            let csv = try! CSVWriter(stream: stream)
            try! csv.write(row: [""])
            try! csv.write(row: [ipname,ipdireccion])

            csv.stream.close()
            print ("CSV ip lista Actualizado")
            NotificationBanner(title:"Agregado", subtitle:"El nuevo lector ha sido guardado", style: .success).show(bannerPosition: .bottom)
        }
    }
    private func changeScene(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "listaDeIpsVCId") as! listaDeIpsVC
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: AnyObject.self)
    }
}

