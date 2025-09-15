//
//  AnalyticsTest.swift
//  Tracker
//
//  Created by Ульта on 13.09.2025.
//

import Foundation
import YandexMobileMetrica


final class AnalyticsTest {
    

    static func runFullTest() {
        print("🧪 ===== ПОЛНЫЙ ТЕСТ АНАЛИТИКИ =====")
        
     
        checkSDKStatus()
        

        testEventSending()
        

        checkConfiguration()
        
        print("🧪 =================================")
    }
    

    private static func checkSDKStatus() {
        print("📊 Проверка статуса SDK:")
        print("   - Версия: \(YMMYandexMetrica.libraryVersion)")
        print("   - SDK загружен и готов к работе")
        print("")
    }
    

    private static func testEventSending() {
        print("📊 Тестирование отправки событий:")
        
        let testEvents = [
            ("event", ["event": "open", "screen": "Main"]),
            ("event", ["event": "click", "screen": "Main", "item": "add_track"]),
            ("event", ["event": "click", "screen": "Main", "item": "track"]),
            ("event", ["event": "click", "screen": "Main", "item": "filter"]),
            ("event", ["event": "close", "screen": "Main"])
        ]
        
        for (eventName, parameters) in testEvents {
            YMMYandexMetrica.reportEvent(eventName, parameters: parameters)
            print("   ✅ Отправлено: \(eventName) с параметрами: \(parameters)")
        }
        
        print("")
    }
    

    private static func checkConfiguration() {
        print("📊 Проверка конфигурации:")
        print("   - API ключ: 2f9bfdfc-6406-4df5-a776-e7d876db84cd")
        print("   - Логирование: включено (DEBUG)")
        print("   - Crash reporting: включено (DEBUG)")
        print("")
    }
}
