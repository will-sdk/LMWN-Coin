
import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

final class ServiceAPI<T: Decodable> {
    
    private let endpoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    private let header: HTTPHeaders
    
    init(_ endpoint: String) {
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
        self.endpoint = endpoint
        self.header = ["x-access-token": "coinrankingc7c4f0eb97923be788350c20a065b7479fe83dfd7e920bf8"]
    }
    
    func getCoinsItem(scopeLimit: String, search: String) -> Observable<T> {
        
        let scopeParam = scopeLimit.isEmpty ? "" : "?scopeLimit=\(scopeLimit)"
        let searchParam = search.isEmpty ? "" : "&search=\(search)"
        let absolutePath = "\(endpoint)\(scopeParam)\(searchParam)"
        print("absolutePath \(absolutePath)")
        return RxAlamofire
            .request(.get, absolutePath, headers: header)
            .debug()
            .observe(on: scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }
}

