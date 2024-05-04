import Foundation

protocol WebViewViewDelegate: NSObjectProtocol {
    func displaySite(request: URLRequest)
}

final class WebViewPresenter {
    weak private var webViewViewDelegate: WebViewViewDelegate?
    
    func setViewDelegate(webViewViewDelegate: WebViewViewDelegate?) {
        self.webViewViewDelegate = webViewViewDelegate
    }
    
    func webViewViewOpened(urlString: String?) {
        
        if let urlString = urlString, let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            self.webViewViewDelegate?.displaySite(request: request)
        }
    }
    
}
