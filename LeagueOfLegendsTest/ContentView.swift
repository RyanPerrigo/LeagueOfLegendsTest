//
//  ContentView.swift
//  LeagueOfLegendsTest
//
//  Created by Ryan Perrigo on 4/28/22.
//

import SwiftUI
import Combine

final class APIManager {
    
    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func decodeChampions(_ champions:@escaping (TopLevelChampionsEntity) -> Void) {
        let decoder = JSONDecoder()
        guard let data = readLocalJSONFile(forName: "Champions") else {debugPrint( "failed to get data from local Json File") ;return}
        
        guard let decodedData: TopLevelChampionsEntity = try? decoder.decode(TopLevelChampionsEntity.self, from: data) else { debugPrint("failed to decode Data from local Json File"); return}
        champions(decodedData)
    }
}

class ContentViewModel: ObservableObject {
    
    let apiManager = APIManager()
    var observers: Set<AnyCancellable> = .init()
    
    func getDecodedChampions() -> Future<TopLevelChampionsEntity, Never> {
        
        return Future { [weak self] promise in
            
            self?.apiManager.decodeChampions { champs in
                promise(.success(champs))
            }
        }
    }
    func getStats()  {
        let allChampsData = getDecodedChampions().map { champs in
            return champs.data
        }.map { dict in
           return dict.values
        }.map { dataValues in
            dataValues.map { data in
                data.stats.filter { dictThing in
                    dictThing.
                }
            }
        }
        observers.insert(champions)
      let data = champions.map { topLevelChampionsEntity in
            return topLevelChampionsEntity.data
      }.eraseToAnyPublisher()
    }
}

struct ContentView: View {
    
   @ObservedObject var vm: ContentViewModel = ContentViewModel()
    
    var body: some View {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
