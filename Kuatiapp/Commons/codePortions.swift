//
//  codePortions.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-17.
//

import Foundation
/*
 este codigo agrega como ruta a una carpeta
 sirve para crear el camino de carpetas dentro de carpetas
 let tempFile = ipFolder.appendingPathComponent("temp.json")
 */

/*
 si existe un path para la carpeta "ipValuesFile" (es un objeto path) crea un archivo con el contenido guardado en "valor",
do{
     if manager.fileExists(atPath: ipValuesFile.path){
                // esta parte crea el file
                    manager.createFile(
                    atPath: tempFile.path,
                    contents: valor,
                    attributes: [FileAttributeKey.creationDate : Date()])
                do{
 // reemplaza con el tempfile, pero borra este tempfile, para copiar de manera segura
                    _ = try manager.replaceItemAt(ipValuesFile, withItemAt: tempFile)
                    print("Lista Json de ips modificada")
                } catch{
                    print("error al reemplazar la lista de ip json")
                }
         print ("CSV ip lista EXISTE")
     
 }
     else{ //si no existe el archivo Json, lo crea
         manager.createFile(
             atPath: ipValuesFile.path,
             contents: valor,
             attributes: [FileAttributeKey.creationDate : Date()])
     }
 }
 */

/*
 Json encoding
 
let newIp = Iplist (name:[ipname],direction:[ipdireccion]) ///crear un objeto Json
let valor = "\n\(ipname),\(ipdireccion)"
// Json encoding
let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = .prettyPrinted
do {
    let encodeIp = try jsonEncoder.encode(newIp)
    let newIpString = String(data: encodeIp, encoding: .utf8)!
    print(newIpString)
    valor = newIpString.data(using: .utf8)
} catch {
    print(error.localizedDescription)
    }
         // end Json encoding
 */

/*
 en los casos donde present es usado, despues se cierra la presentacion abierta
        dismiss(animated: true, completion: nil)
 */
/*
 presenta un view controller encima de otro .show o present
 lista
 let vc = self.storyboard?.instantiateViewController(withIdentifier: "viewControllerID") as! viewControllerFileName
 vc.modalPresentationStyle = .fullScreen
       //self.show(vc, sender: AnyObject.self)
       //self.present(vc, animated: true, completion: nil)

 Show - Pushes the destination view controller onto the navigation stack, sliding overtop from right to left, providing a back button to return -
 Present Modally - Presents a view controller overtop the current view controller in various fashions as defined by the modal presentation and transition style -
 */

/*
 es para hacer dismiss cuando se hace push
 self.navigationController?.popViewController(animated: true)

 */
