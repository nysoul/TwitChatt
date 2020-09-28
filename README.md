![TwitChat](assets/images/logo.png)

A chat application made with flutter with twitter search functionality included with it.
The Complete application is made from scratch (excluding twitter search part which uses api's).

## Features
1. Authentication Using firebase authentication.
2. Storing user info, user chats and chatroom details in the Cloud Firestore.
3. Searching user info from the users list from database using firestore queries.
4. Storing user info in the local device to keep him logged in even after closing the application using shared preferences.
5. Twitter mixed( popular + recent ) search showing 20 results (can be changed), Using Twitter api and Twitter view Api.

## How To Run
### Requirements

```sh
 flutter
 android studio
 ```

After installing the Requirements stated above...
In Flutter console or android studio use this command to get application dependencies.

```sh
flutter: $ pub get
android studio: $ flutter pub get
```
### Note
> _1._  Do not make changes with the database file as changing it may cause errors with server communication.

>  _2._ Application won't work in ios devices as ios app connection to firestore requires mac and I only have windows currently. (can be done in a mac machine in 10 minutes.)

## How To Use

<figure class="video_container">
  <video controls="true" allowfullscreen="true" poster="assets/images/logo.png">
    <source src="assets/demo/video.mp4" type="video/mp4">
      </video>
</figure>

<!-- blank line -->
<figure class="video_container">
  <iframe src="assets/demo/video.mp4" frameborder="0" allowfullscreen="true"> </iframe>
</figure>
<!-- blank line -->


## Timeline
Detailed as well as overview timeline is included.

### Overview
| Duration | Task |
| ------ | ------- |
| **18th Sept - 19th Sept** | Installation and learning about flutter basics. |
| **20th Sept - 21st Sept** | Building UI and functions for authentication. |
| **22th Sept - 23st Sept** | Setting and communicating with the database. |
| **24th Sept - 25st Sept** | Building and setting rest of UI and its functionality. |
|  **20th Sept - 21st Sept** | Twitter Search Implementaion. |
### Detailed
- **18th Sept -**  Installation of flutter and android studio
- **19th Sept -**  Learning basic flutter application from flutter official website.
- **20th Sept -** Implementing UI of the Sign In & Sign Out and connecing app through firebase.
- **21st Sept -** Implementing SignIn and SignOut functions and connecting application to google firebase authentication.
- **22nd Sept -** Connecting application through firestore database and saving user data to database.
- **23rd Sept -** Implementing Search using username UI and functioning to seach user data from firestore database.
- **24th Sept -** Implementing chatroom UI and addmessage to database as well as getmessages from database function.
- **25th Sept -** Creating chat screen for each conversations. Also various ui changes in the app including drawer, wallpaper, loading screens.A lot of testing.
- **26th Sept -** Studying about twitter api and getting search results in json data format.
- **27th Sept -** Adding search tweets screen and converting the json data to this format using tweet_ui api. 
- **28th Sept -** Documentation you are reading right now, Demo video and screenshots of the app.

## Diffuclties
As I didn't have any experience with making an application before. I have to lookup everthing on the internet and so the process was a lot time consuming but also rewarding which made me faster with time.

**Major problems/errors faced**
- Render flex errors.
- Null value errors.
- database data abtsraction errors.
- positioning of layers in order.( like containers overlapping each other and height, width, padding issues)
- Conversion of twitter data to twitter view.

**Things which could be better**
- In a chatapp the number of features that can be added are endless and I still feel many features can still be added to app like ( message deletion , chat screen wallpapers change, settings pane, notification functionality).
- There is still scope for UI improvements.
- Many problems which are solved and some unsolved whih arrived after testing.
- Not much time spent on the twitter search function as information provided to me was vague and hard to understand.
- ios fucntionality as I dont have an apple device and windows don't have capability to open ios files. (Blame Apple)

## Conclusion
This project helped me in learning a lot about flutter and android apllication development.
I really enjoyed the process and hope to continue my career in this path in future.
I hope you enjoy the application. I have included a final built android apllication with the project. 



