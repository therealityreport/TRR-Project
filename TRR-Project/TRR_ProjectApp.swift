


import SwiftUI
import FirebaseCore
@main
struct TRR_ProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        
        WindowGroup {
            
            ContentView()
            
                .environmentObject(authViewModel)
            
                .environmentObject(UserManager.shared)
            
        }
        
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:

    [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        FirebaseApp.configure()

        print("Configured Firebase!")

        return true
}
}
    
    // ContentView.swift
    
    
    

