//
//  AppDelegate.swift
//  SJDD
//
//  Created by Jared Perez Vega on 12/6/18.
//  Copyright © 2018 Everis. All rights reserved.
//

import UIKit
import Firebase
import FrameworkEhCOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
  // JSDD let navigationControllerPublic = SJDDNavigationBar()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        RemoteLib.shared.setConfig(LibConfig(
            entitySelected: false,
            imageLogo: "",
            homeEnable: false,
            colorPrimary: "#F44336",
            colorSecundary: "#D32F2F",
            disableBack: false))
        RemoteLib.shared.setEntityConfig(appEntityCode: "EVR_QA")
        RemoteLib.shared.setVersionUpdate(false)
        
        RemoteLib.shared.setWelcomeMessage(
            welcomeMessage_es: "Portal del paciente del Hospital Sant Joan de Déu",
            welcomeMessage_ca: "Portal del pacient de l’Hospital Sant Joan de Déu",
            welcomeMessage_en: "Patient Portal of SJD Barcelona Children’s Hospital",
            welcomeMessage_pt: "Portal do paciente do Hospital Sant Joan de Deu")
                
        RemoteLib.shared.setHomeMessage(
            homeMessage_es: "Una plataforma digital para fomentar la comunicación entre pacientes y familiares y el equipo sanitario.",
            homeMessage_ca: "Una plataforma digital per fomentar la comunicació entre pacients i familiars i l'equip sanitari.",
            homeMessage_en: "A digital platform to promote communication between patients and families and the healthcare team.",
            homeMessage_pt: "Una plataforma digital per fomentar la comunicació entre pacients i familiars i l'equip sanitari.")

/*    // JSDD
        let home = SJDDHomeRouter.createModule()
        navigationControllerPublic.viewControllers = [home]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationControllerPublic
        window?.makeKeyAndVisible()
        Thread.sleep(forTimeInterval: 1.0)
*/
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
          Messaging.messaging().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        
       
        RemoteLib.shared.setNameInitialViewController(
            storyboardName: "Main",
            viewControllerIdentifier: "ContainerViewController")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setOpenViewController(notification:)), name: Notification.Name("open"), object: nil)

        
        return true
    }
    
    
    //Nombre de la vista base que se desea mostrar
    @objc func setOpenViewController(notification: NSNotification)  {
      //  NotificationCenter.default.post(name: Notification.Name("openViewInital"), object: nil, userInfo: nil)
     
    }

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        RemoteLib.shared.setToken(fcmToken ?? "")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    @available(iOS 10.0, *)
    //método que se ejecuta al llegar las notificaciones
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //chat - actualizado
        if (UIApplication.shared.topViewController() as? ChatViewController) != nil {
            completionHandler([])
        } else {    }
        
        RemoteLib.shared.setBadgeGeneric(true)
        let userInfo = notification.request.content.userInfo as? NSDictionary
        let typeChat = userInfo?["type"] as? String
        let textChat = userInfo?["text"] as? String
        let timestampChat = userInfo?["timestamp"] as? String
        let actUsernameChat = userInfo?["sender_fullname"] as? String
        let userIdChat = userInfo?["sender_userid"] as? String
        let userNamelo = RemoteLib.shared.settingsManager.username
        if typeChat == "INCOMING_CHAT" {
            let  badge  = RemoteLib.shared.settingsManager.badgeGeneric
            if badge == true {
                let number : Int = 1
                UserDefaults.standard.set(number, forKey: "badgegeneric")
            }
            
        }
        //chat - actualizado
        if let userId = userIdChat , let username = actUsernameChat , let type =  typeChat , let time =  timestampChat , let textC = textChat  {
            let keychat = userNamelo + "\(userId)"
            saveUsersDataChat.saveMessageDataUserDefault(userKey: keychat, userId: "\(userId)", username: "\(username)", typeMessage: "\(type)", timestamp: "\(time )", text: "\(textC )", actUsername: "\(username)")
            saveUsersDataChat.chatMessageKeyDefault(keychat)
        }
        
        let dataDict:[String: String?] = ["token": "PushwillPresent"]
        NotificationCenter.default.post(name: Notification.Name("PushwillPresent"), object: nil, userInfo: dataDict as [AnyHashable : Any])
        let pushRefresh:[String: String?] = ["token": "UpdateCompletedQuestionnaire"]
        NotificationCenter.default.post(name: Notification.Name("UpdateCompletedQuestionnaire"), object: nil, userInfo: pushRefresh as [AnyHashable : Any])
        
        completionHandler([.alert, .badge, .sound]) //actualizado
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        notificationCall(userInfo: userInfo)
    }
    
    func notificationCall (userInfo: [AnyHashable : Any]) {
        
        if (userInfo["type"] as? String) != nil {
            let INCOMING_CALL = "inComingCall"
            let NOTIFICATION_VITALSIGN = "vitaldata"
            let NOTIFICATION_POLLS = "forms"
            let INCOMING_CHAT = "INCOMING_CHAT"  //chat - actualizado
            
            UserDefaults.standard.set(NOTIFICATION_VITALSIGN, forKey: "vitaldata")
            UserDefaults.standard.set(NOTIFICATION_POLLS, forKey: "forms")
            
            
            //tipo de notificaciones para signos vitales y cuestionario
            let roomUser = userInfo["room"] as? String
            UserDefaults.standard.set(roomUser, forKey: "keyroom")
            let keytype = userInfo["type"] as? String
            UserDefaults.standard.set(keytype, forKey: "keytype")
            let attributetitle = userInfo["gcm.notification.attribute1"] as? String
                UserDefaults.standard.set(attributetitle, forKey: "keytitle")
            
            //tipo de notificaciones para chat - actualizado
            let type_incoming_chat = userInfo["type"] as? String
            if type_incoming_chat == INCOMING_CHAT {
                let type_chat =  type_incoming_chat
                UserDefaults.standard.set(type_chat, forKey: "incomingchat")
                let text = userInfo["text"] as? String
                UserDefaults.standard.set(text, forKey: "text")
                let timestamp = userInfo["timestamp"] as? String
                UserDefaults.standard.set(timestamp, forKey: "timestamp")
                let actUsername = userInfo["sender_fullname"] as? String
                UserDefaults.standard.set(actUsername, forKey: "actUsername")
                let userId = userInfo["sender_userid"] as? String
                UserDefaults.standard.set(userId, forKey: "userId")
            }
           
            
            
             //tipos de vistas a mostrar
            if let type = userInfo["type"] as? String{
                switch type {
                //MARK:- chat - actualizado
                case INCOMING_CHAT:
                    DispatchQueue.main.async {
                        self.nextViewChat(UIApplication.topViewController())
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                //vista cuestionario segun el estado de la aplicación
                case NOTIFICATION_POLLS:
                    switch UIApplication.shared.applicationState {
                    case .active:
                        DispatchQueue.main.async {
                            self.nextViewPollsDetail(UIApplication.topViewController())
                            UIApplication.shared.applicationIconBadgeNumber = 0
                        }
                        break
                    case .inactive:
                        DispatchQueue.main.async {
                            self.nextViewPollsDetail(UIApplication.topViewController())
                             UIApplication.shared.applicationIconBadgeNumber = 0
                        }
                        break
                    case .background:
                        DispatchQueue.main.async {
                            self.nextViewPollsDetail(UIApplication.topViewController())
                        }
                        break
                    default:
                        break
                    }
                  //vista signos vitales segun el estado de la aplicación
                case NOTIFICATION_VITALSIGN:
                    switch UIApplication.shared.applicationState {
                    case .active:
                        DispatchQueue.main.async {
                         self.nextViewVitalSign(UIApplication.topViewController())
                          UIApplication.shared.applicationIconBadgeNumber = 0
                            }
                        break
                    case .inactive:
                         DispatchQueue.main.async {
                        self.nextViewVitalSign(UIApplication.topViewController())
                         UIApplication.shared.applicationIconBadgeNumber = 0
                         }
                        break
                    case .background:
                          DispatchQueue.main.async {
                         self.nextViewVitalSign(UIApplication.topViewController())
                          }
                        break
                    default:
                        break
                    }
                    //validación para tipo de llamada ya sea individual ó grupal
                    case INCOMING_CALL:
                                            
                        Timer.after(2.seconds) { [weak self] in
                            
                            let roomVar = userInfo["room"] as! String
                            let callerVar = "7000009"
                            let name = userInfo["professional"] as! String
                            let apsIncomingCall = userInfo[AnyHashable("aps")] as? NSDictionary
                            let alertIncomingCall  = apsIncomingCall?["alert"] as? NSDictionary
                            let profesionalName = alertIncomingCall?["body"] as? String
                            let typeVideoName = userInfo["typeVideo"] as! String
                            let videoCallType = userInfo["type"] as? String
                            
                            UserDefaults.standard.set(roomVar, forKey: "roominComingCall")
                            UserDefaults.standard.set(name, forKey: "professionalinComingCall")
                            UserDefaults.standard.set(profesionalName, forKey: "profesionalNameinComingCall")
                            UserDefaults.standard.set(typeVideoName, forKey: "typeVideoNameinComingCall")
                            UserDefaults.standard.set(videoCallType, forKey: "incomingCallType")
                            
                            let videoCallSystem = VideoSystemRemote(rawValue: RemoteLib.shared.settingsManager.videoCallSystem) ?? .googleMeet

                            switch videoCallSystem {
                                
                            case .i2cat:
                                
                                var typeVideo = ConferenceTypeRemote.individual
                                
                                if userInfo["typeVideo"] != nil {
                                    typeVideo = ConferenceTypeRemote(rawValue: userInfo["typeVideo"] as! String) ?? .individual
                                    
                                }
                                

                                switch typeVideo {
                                    
                                case .individual:
                                    self?.goCall(UIApplication.topViewController(), roomId: roomVar , callerId: callerVar, name: name)
                              
                                case .group, .instant, .presentation:
                                    let urlCall = self?.generatedUrlVideo(roomVar: roomVar)
                                 
                                    self?.videoConferenceCallNMView( UIApplication.topViewController(), profesionalName: profesionalName!, url: urlCall!)
                                }
                                
                            case .openVidu:
                                
                                var typeVideo = ConferenceTypeRemote.individual
                                
                                if userInfo["typeVideo"] != nil {
                                    typeVideo = ConferenceTypeRemote(rawValue: userInfo["typeVideo"] as! String) ?? .individual
                                }
                                

                                switch typeVideo {
                                    
                                case .individual:
                                    self?.goCall(UIApplication.topViewController(), roomId: roomVar , callerId: callerVar, name: name)
                               
                                case .group, .instant, .presentation:
                               
                                    self?.videoConferenceCallNMView( UIApplication.topViewController(), profesionalName: profesionalName! , url: roomVar)

                                }
                                
                            case .googleMeet:
                              
                                self?.videoConferenceCallNMView( UIApplication.topViewController(), profesionalName: profesionalName! , url: roomVar)
                            
                            }
                            
                    }
                    
                    
                    default:
                        break
                }
            }
        } else {
          /*
            let aps = userInfo[AnyHashable("aps")] as? NSDictionary
            let alert = aps?["alert"] as? NSDictionary
            let body = alert?["body"] as? String
            
            let alertCtrl = UIAlertController(title: "notificacion_recibida".localized(), message: body, preferredStyle: .alert)
            alertCtrl.addAction(UIAlertAction(title: "colas_ok".localized(), style: .default, handler: { (_) in
                let view = self.window?.rootViewController as! SJDDNavigationBar
                view.navigateTo(HamburguerMenuNavigationModel.ColasView)
            }))
            self.window?.rootViewController?.present(alertCtrl, animated: true)
            */
        }
 
    }
    
    private func nextViewChat(_ origin: UIViewController?) {
        let text = UserDefaults.standard.object(forKey: "text") as? String ?? ""
        let timestamp = UserDefaults.standard.object(forKey: "timestamp") as? String ?? ""
        let actUsername = UserDefaults.standard.object(forKey: "actUsername") as? String ?? ""
        let userId = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
        let incomingchat = UserDefaults.standard.object(forKey: "incomingchat") as? String ?? ""
        let usernameLogin =  RemoteLib.shared.settingsManager.username
        guard let origin = origin else {return}
        guard let navigationController = origin.navigationController as? NavigationBarPrivate else {return}
        let keychat = "\(usernameLogin)" + "\(userId)"
        
        if saveData == true {
            print("applicationDidBecomeActive")
        } else {
            switch UIApplication.shared.applicationState {
            case .active:
                break
            case .inactive, .background:
                saveUsersDataChat.saveMessageDataUserDefault(userKey: keychat, userId: "\(userId)", username: "\(actUsername)", typeMessage: "\(incomingchat)", timestamp: "\(timestamp)", text: "\(text)", actUsername: "\(actUsername)")
                break
            default:
                break
            }
        }
        navigationController.pushViewController(ChatRouter.createModule(data: ChatUserStateInformation(identifier: Int(userId) ?? 0, fullName: actUsername, type: "", typeMessage: incomingchat, timestamp: Int(timestamp) ?? 0, text: text , actUsername: actUsername, userId: userId, stateSock: true )), animated: true )
        
    }
    
    //MARK: - Customización de código para obtener titulo de notificación push
    private func nextViewPollsDetail(_ origin: UIViewController?) {
        guard let origin = origin else { return }
        let keyroom = UserDefaults.standard.object(forKey: "keyroom") as? String ?? ""
        let titleUser = UserDefaults.standard.object(forKey: "keytitle") as? String ?? ""
        let movementIDConvert = Int(keyroom) ?? 0
        guard let navigationController = origin.navigationController as? NavigationBarPrivate else {return}
        navigationController.pushViewController(PollRouter.createModule(actionBar: ActionBar(id: 0, name: titleUser , image: nil, movementID: movementIDConvert, withCheck: false), userNameNhc: "userNameNhc", readOnly: false, pendingOrFinished: true, pollTab: PollTab(rawValue: 1)!), animated: true)
    }
    
    // función para regirigir a las vista de signos vitales
    private func nextViewVitalSign(_ origin: UIViewController?) {
        guard let origin = origin else { return }
        guard let navigationController = origin.navigationController as? NavigationBarPrivate else { return }
        navigationController.setViewControllers([VitalSignRouter.createModule()], animated: true)
    }
    
    //tipos de videollamada
    enum ConferenceTypeRemote: String {
        case group = "Group"
        case individual = "Individual"
        case presentation = "Presentation"
        case instant = "Instant"
    }

    enum VideoSystemRemote: String, Codable {
        case i2cat = "backoffice.videoCallSystem.i2cat"
        case googleMeet = "backoffice.videoCallSystem.googleMeet"
        case openVidu = "backoffice.videoCallSystem.openVidu"
    }
    
    //video llamada individual
    func goCall(_ origin: UIViewController?, roomId:String, callerId:String, name:String){
        DispatchQueue.main.async {
            guard let origin = origin else {return}
            guard let navigationController = origin.navigationController as? NavigationBarPrivate else {return}
            let callVC = CallContainerViewController()
            callVC.isCaller = false
            callVC.callerId = callerId
            callVC.roomId = roomId
            callVC.callerName = name
            callVC.calleeName = "Paciente"
            callVC.modalPresentationStyle = .fullScreen
            navigationController.pushViewController(callVC, animated: true)
            self.window?.makeKeyAndVisible()
        }
    }
    
    //video llamada grupal
    func generatedUrlVideo(roomVar:String) -> String{
          let gender = RemoteLib.shared.settingsManager.userGender
          let birthdate = RemoteLib.shared.settingsManager.userBirthdate
          let userNameLogin = RemoteLib.shared.settingsManager.username
          let urlBase = RemoteLib.shared.settingsManager.urlVideoNM
          let rol = UserDefaults.standard.string(forKey: "userProfile")
          
          var rolVideoCall = "moderator"
          if rol == "professionals" {
              rolVideoCall = "moderator"
          } else if rol == "patients" {
              rolVideoCall = "publisher"
          }
        
        let urlPart01 = urlBase+"/videoProxy.html?user="+userNameLogin
        let urlPart02 = "&role="+rolVideoCall+"&room=room"+roomVar+"&gender="+gender+"&birthdate="+birthdate
        let updateUrl = urlPart01 + urlPart02
        
          return updateUrl
          
      }
    
    //vista llamada
    private func videoConferenceCallNMView(_ origin: UIViewController?, profesionalName : String , url: String ) {
        guard let origin = origin else { return }
        guard let navigationController = origin.navigationController as? NavigationBarPrivate else { return }
        navigationController.pushViewController(ConferenceNMRouter.createModule(profesionalName:  profesionalName , url: url), animated: true)
    }
    
  

    func applicationWillEnterForeground(_ application: UIApplication) {
        //LogOutTimerManager.appCameToForeground()
     
    }
    
    
    //MARK:- CÓDIGO AGREGADO
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
    }

    //MARK:- CÓDIGO AGREGADO
    func applicationWillResignActive(_ application: UIApplication) {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    
    var saveData : Bool = false
    func applicationDidBecomeActive(_ application: UIApplication) {
    //MARK:- CÓDIGO AGREGADO
        NotificationCenter.default.post(name: Notification.Name("PushTest"), object: nil, userInfo: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.endBackgroundUpdateTask()
        saveData = true
    }
    
      //MARK:- CÓDIGO AGREGADO
      func applicationDidEnterBackground(_ application: UIApplication) {
          saveData = false
      }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}

 //MARK:- chat - actualizado
extension UIApplication {
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        switch (base) {
        case let controller as UINavigationController:
            return topViewController(controller.visibleViewController)
        case let controller as UITabBarController:
            return controller.selectedViewController.flatMap { topViewController($0) } ?? base
        default:
            return base?.presentedViewController.flatMap { topViewController($0) } ?? base
        }
    }
}

