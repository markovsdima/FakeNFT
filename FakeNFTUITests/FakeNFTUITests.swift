import XCTest

final class FakeNFTUITests: XCTestCase {
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        // TODO: - Не забудьте написать UI-тесты
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testFilterButtonCart() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Панель вкладок"]/*@START_MENU_TOKEN@*/.buttons["CartTab"]/*[[".buttons[\"Корзина\"]",".buttons[\"CartTab\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(5)
        
        app.buttons["filterButton"].tap()
        
        app.buttons["По цене"].tap()
        
        sleep(3)
        
        app/*@START_MENU_TOKEN@*/.buttons["filterButton"]/*[[".buttons[\"SortButton\"]",".buttons[\"filterButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["По рейтингу"].tap()
        
        sleep(3)
        
        app/*@START_MENU_TOKEN@*/.buttons["filterButton"]/*[[".buttons[\"SortButton\"]",".buttons[\"filterButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["По названию"].tap()
        
        sleep(3)
        
        app/*@START_MENU_TOKEN@*/.buttons["filterButton"]/*[[".buttons[\"SortButton\"]",".buttons[\"filterButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Закрыть"].tap()
        sleep(2)
        
    }
    
    func testpaymentCart() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Панель вкладок"]/*@START_MENU_TOKEN@*/.buttons["CartTab"]/*[[".buttons[\"Корзина\"]",".buttons[\"CartTab\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(5)
        
        app.buttons["К оплате"].tap()
        
        sleep(2)
        
        app.buttons["Оплатить"].tap()
        app.alerts.buttons["Повторить"].tap()
        
        sleep(2)
        
        app.buttons["Оплатить"].tap()
        app.alerts.buttons["Отмена"].tap()
        
        sleep(2)
    }
}
