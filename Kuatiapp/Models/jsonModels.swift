//
//  jsonModels.swift
//  Kuatiapp
//
//  Created by Juan David Velazquez on 2022-09-06.
//

import Foundation

// MARK: - Caravanas
struct Caravanas: Codable {
    let caravanas: [String]
}

// MARK: - Caravana
struct Caravana: Codable {
    let caravana: String
}

// MARK: - Bundle
extension Bundle{ // con esto puedo llamar este archivo desde cualquier lugar
    func decode<T: Decodable>(file: String) -> T{
        guard let url = self.url(forResource: file, withExtension: nil) else{
            fatalError("No se pudo encontrar \(file) entre los archivos ")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("No se pudo cargar \(file) entre los archivos ")
        }
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("No se pudo decodificar el archivo de la lista Json")
        }
        return loadedData
    }
}

//func createIpList(ipname:String,ipdirection:String) -> iplist
//{
//    var json : iplist
//    json.name = [ipname]
//    json.direction = [ipdirection]
//    return json
//}
