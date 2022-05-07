# - Red TV Shows app -

### Brief project overview

For learning purposes I created an application that allows you to view TV shows, comment and rate them. Aplication is natively made for iPhone devices (I have Android version as well) in Swift language.

### Installation

Since this app is not available on App store only way to install it is to clone reposeitory and build app using Xcode.

### Application screenshots

<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/1.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/2.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/3.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/4.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/5.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/6.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/7.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/8.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/9.PNG?raw=true" width="300" height="600">
<img src="https://github.com/gorsicleo/tv-shows-iOS/blob/main/Screenshots/10.PNG?raw=true" width="300" height="600">

### What I have learned and technologies I have used

Through the process of creating an application I learned lot about iOS operating system and how app conforms to OS requirements (app lifecycle). I also learned about MVC pattern as base before exploring MVVM or other patterns. UI layout was done using Storyboards with some modules extracted as .xib files. Big chapter was memory management in Swift with ARC where I learned differences between strong and weak references with objective to prevent retain cycles. Dependency managment was done using CocoaPods. Big step was learning to use auto layout together with Stack view to build UI and utilize debugger for finding bugs in UI and code. Since all shows are loaded from the internet networking had to be handled... For that purpose I used Alamofire pod. Backend required continuous passing of authentication credentials so I created simple API manager to handle API requests with ease. In this app I faced a challenge of passing data between view controllers. Here I learned about delegate pattern that is often used in iOS development together with closures and NSNotifications. At the end I played a bit with animations and ways to preserve data in form of user defaults or keychain. I was very curious how keychain works with biometric authentication so I implemented simple feature of loging in with your touchID or faceID. I grasped a bit on permissions since app supports profile photo change where user can choose between camera and phto library.  There are definitely  many thing to improve and app is by no means perfect, but it was great journey building first app and learning along the way.
