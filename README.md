# RandomUserAccess
### iOS UIKit App to display user details from randomuser.me
- Swift, iOS 10 Compatible
- MVVM conforming, maintainable and testable multithreaded architecture
- UIKit, CoreData, Grand Central Dispatch, Codable, URLSession, Storyboards
- XCTest: In depth testing, 

![Banner](images/RandomUserAccessBanner.png)

## Noteable Features:
- CoreData based automatic offline saving and caching
- Scrollable table display list of users with images
- Pull to refresh and request more users
- Dynamic type to search functionality to filter by searched name
- Sectioned pagination by name, sorted alphabetically, generated automatically
- Detailed view of the user with contact information
- Web image cache saving only what you need when you need it to keep memory footprint low

## In the future:
- The data is solid, however the images are very low res, I would like to use [Unsplash](https://unsplash.com/t/people) for portraits
- I woud like to work on the UI and make some visual changed to how the information is displayed, it is very simple as the focus was on the performant data storage and searching/retreival

### I would like the different data points displayed to link elsewhere eg:
- To the indivisuals "website", to the phone app or location to maps
- Perhaps UIMapKit to display there location in app
- It would be interesting to use device location to check distance from "user" similar to find friends.
