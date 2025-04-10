protocol MainViewModelProtocol {
    var updateViewData: ((ViewData) -> Void)? { get set }
    func viewDidLoad()
}

final class MainViewModel: MainViewModelProtocol {
    var updateViewData: ((ViewData) -> Void)?
    
    func viewDidLoad() {
        
    }
    
    
}
