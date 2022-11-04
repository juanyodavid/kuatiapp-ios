//
//  caravanaVC.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-15.
//

import UIKit
import NotificationBannerSwift

class caravanaVC: UIViewController {

    
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var nombreLectorLabel: UILabel!
    @IBOutlet weak var numeroCaravanaLabel: UILabel!
    @IBOutlet weak var volverButton: UIButton!
    @IBAction func volverButtonAction(){
        self.timer?.invalidate()
            self.timer = nil
        dismiss(animated: true, completion: nil)

    }
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreLectorLabel.text = lectorActual[0]
        ipLabel.text = lectorActual[1]
        fetchService(ip:lectorActual[1], activateRefresh: true)
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Private Functions
    private func refresh() {
        func doSomrThing(str: String) {
            fetchService(ip:lectorActual[1],activateRefresh: false)
            print(str)
        }
        doSomrThing(str: "first time")
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
            doSomrThing(str: "after 2 seconds in single caravana view")
        })
    }
    private func fetchService(ip : String,activateRefresh:Bool) {
        let endPointString = "http://\(ip)/app/api-actual/index.json"
        print ("el end point es \(endPointString)")
        guard let endpoint = URL(string: endPointString) else {
            print("no se llega al link")
            return
        }
        
        URLSession.shared.dataTask(with: endpoint) { (data: Data?, _, error: Error?) in
            DispatchQueue.main.async {
                if (error != nil) {
                NotificationBanner(title: "Error", subtitle: "No se pudo detectar la Ip", style: .danger).show()
                print("hubo un error al buscar la url")
                return
                }
                

            }
            //aca ya que no tenemos una estructura clara, usamos serialization, si se quiere hacer de una manera mas simple, ver "listaCaravanaViewController.swift"
            guard let dataFromService = data,
                  let dictionary = try? JSONSerialization.jsonObject(with: dataFromService, options: []) as? [String: Any] else {
                      return
            }
            DispatchQueue.main.async { [self] in
                guard let caravana = dictionary["caravana"] as? String else {
                    NotificationBanner(title: "Error", subtitle: "No se pudo detectar la caravana", style: .warning).show()
                    return
                }
                if (activateRefresh == true){//sirve para que el refresh se ejecute una sola vez y no sea recursivo
                    refresh()
                }
                print("la lectura es \(caravana) ")
                let outCaravana = "\(caravana)"
                numeroCaravanaLabel.text = outCaravana
            }
        }.resume()
    }
    
}
//NO PUEDE LEER SE QUEDA SIN EN EL END POINT Y NO TERMINA


//QUE FALTA HACER?

//guardar todo como csv,
//crear los archivos csv y que se puedan Ver
//hacer el boton de share
