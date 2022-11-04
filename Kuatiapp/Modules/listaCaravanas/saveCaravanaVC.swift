//
//  saveCaravanaVC.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-20.
//

import UIKit
import NotificationBannerSwift
import CSV

class saveCaravanaVC: UIViewController {

    @IBOutlet weak var cantidadAnimalesLabel: UILabel!
    @IBOutlet weak var nombreArchivoInput: UITextField!
    @IBOutlet weak var obsArchivoInput: UITextField!
    @IBOutlet weak var vacunaInput: UITextField!
    @IBOutlet weak var dosisInput: UITextField!
    @IBOutlet weak var promedioPesoLabel: UILabel!
    @IBOutlet weak var dateArchivoInput: UIDatePicker!
    @IBAction func guardarButton(_ sender: UIButton!) {
        createFiles()
    }
    @IBAction func CancelarButton(_ sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if actualSelection != "vacunacion"{
            vacunaInput.isHidden = true
            dosisInput.isHidden = true
        }
        if actualSelection != "pesaje"{
            promedioPesoLabel.isHidden = true

        }else{
            var media = 0
            for peso in pesoList{
                media = peso + media
            }
            media = media/pesoList.count
            promedioPesoLabel.text = "Peso promedio = \(media) kg"
        }
        setUpView()
        // Do any additional setup after loading the view.
    }
    //crear la carpeta donde se va a guardar
//    asignar los nombres para el archivo y una description
//    #MARK: - Private Functions
    private func setUpView(){
        cantidadAnimalesLabel.text = "La cantidad de animales es: \(caravanasList.count)"
       
    }
    private func validateInputs(){
        guard let nombre = nombreArchivoInput.text, !nombre.isEmpty else{
            NotificationBanner(title: "Error", subtitle: "El nombre del archivo no debe estar vacio",  style: .warning).show()
            return
        }
        if actualSelection == "vacunacion"{
            guard let vacuna = vacunaInput.text, !vacuna.isEmpty else{
                NotificationBanner(title: "Error", subtitle: "El nombre de la vacuna no debe estar vacio",  style: .warning).show()
                return
            }
            guard let dosis = dosisInput.text, !dosis.isEmpty else{
                NotificationBanner(title: "Error", subtitle: "La dosificación no debe estar vacia",  style: .warning).show()
                return
            }
        }
        
    }
    private func createFiles() {
        // validar para que nunca sean vacios el nombre y la direccion
        let fileName = nombreArchivoInput.text ?? "vacio"
        let fileObs = obsArchivoInput.text ?? ""
        let fileDate = dateArchivoInput.date
        let data = "\(fileDate)\n\(fileObs)\n" /// este es el titulo de las columnas del CSV
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
        let filesFolder = appFolder.appendingPathComponent("filesFolder")
        do{
            try manager.createDirectory(
                at: filesFolder,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        }
        catch {
            print(error)
        }
        print ("el path es: \(filesFolder.path)") // este imprime en que parte esta el folder que tiene el archivo json
        // aca se crea el archivo
        let fileValuePath = filesFolder.appendingPathComponent("\(fileName).csv")
        do{
            if manager.fileExists(atPath: fileValuePath.path){
                print ("CSV ip lista EXISTE, no se puede crear")
                NotificationBanner(title: "Error", subtitle: "Ya existe un archivo con el mismo nombre",  style: .warning).show()
                return
            }
            else{ //si no existe el archivo Json, lo crea
                manager.createFile(
                    atPath: fileValuePath.path,
                    contents: valor,
                    attributes: [FileAttributeKey.creationDate : Date()])
                chargeCSV(filePath: fileValuePath, list: caravanasList)
            }
        }
        
    }
    private func chargeCSV (filePath: URL,list:[String]){
        let fileObs = obsArchivoInput.text ?? ""
        let fileDate = dateArchivoInput.date
        let stream = OutputStream(toFileAtPath: filePath.path, append: false)!
        print(list)
        let csv = try! CSVWriter(stream: stream)
        try! csv.write(row: [fileDate.description])
        try! csv.write(row: [fileObs])
        if actualSelection == "lote"{
            try! csv.write(row:["numero"])
            try! csv.write(row: [fileObs])
            for animal in list {
                print(animal)
                try! csv.write(row: [animal])
            }
        }
        if actualSelection == "vacunacion"{
            let vacuna = vacunaInput.text!
            let dosis = dosisInput.text!
            try! csv.write(row:["numero","vacuna","dosis"])
            for animal in list {
                print(animal)
                try! csv.write(row: [animal,vacuna,dosis])
            }
           
            
        }
        if actualSelection == "pesaje"{
            try! csv.write(row:["numero","peso"])
            for (animal,peso) in zip(list,pesoList) {
                let pesoString = "\(peso)"
                try! csv.write(row: [animal,pesoString])
            }
        
        
        }
        csv.stream.close()
        NotificationBanner(title: "Agregado", subtitle: "El archivo se ha guardado correctamente",  style: .success).show()
        dismiss(animated: true, completion: nil)

        
    }
    
}
