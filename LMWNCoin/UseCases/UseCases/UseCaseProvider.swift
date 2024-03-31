
import Foundation

public protocol UseCaseProvider {
    func makeListOfCoinsUseCase() -> ListOfCoinsUseCase
}
