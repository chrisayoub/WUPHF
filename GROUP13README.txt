Implementation Contributions: 
Chris Ayoub: 33% 
* Various bug fixes
* Implemented Touch ID Login
* Added Twitter messaging in backend for sending WUPHF
* Implemented Twitter login within the app
* Added deletion of Packs via long-click

Victor Maestas: 33%
* Implemented location services to retrieve and send a user's location with a WUPHF
* Edited Send WUPHF View Controller to accommodate location services
* Various constraint adjustments
* Created README

Matthew Savignano: 33% 
* Learned Touch ID to assist with its implementation
* Implemented location services to retrieve and send a user's location with a WUPHF
* Edited Send WUPHF View Controller to accommodate location services
* Various constraint adjustments


Grading Level: 
Same grade for all members


Differences: 
Although in our mockup we had a Feed, we decided not to include this
feature as it was not present in our App Idea paper. It did not fit
with our changed vision of the app, either.


Special Instructions: 
* Make sure to install Cocoa Pods (version 2.0 or higher). Run ‘pod install’.
* Make sure XCode 9.2 is installed. We noticed an inconsistency in our Touch ID code,
  and it was not compiling the same across XCode versions 9.1 and 9.2. We made the code work
  for XCode version 9.2, it likely does NOT work on version 9.1
* There is a known bug with TwitterKit login. If you click “Done” without linking a
  Twitter account, it will dismiss the current view controller. This only occurs if the
  Twitter app is not installed. This is a known issue and we could not find a solution.


	