
import Foundation
import RxSwift
import RxCocoa

final class RepositoryFromJsonFile<T: Decodable> {
    
    private let jsonFileName: String
    private let typeFileName: String
    
    init(jsonFileName: String,
         typeFileNam: String) {
        self.jsonFileName = jsonFileName
        self.typeFileName = typeFileNam
    }
    
    func getListOfCoinsService() -> Observable<[T]> {
        return Observable.create { observer -> Disposable in
            guard let path = Bundle.main.path(forResource: self.jsonFileName, ofType: self.typeFileName) else {
                return Disposables.create { }
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let response = try JSONDecoder().decode([T].self, from: data)
                observer.onNext(response)
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create { }
        }
    }
}

