# Suko

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description

Suko allows users to find and keep track of the anime they want to watch.

### App Evaluation
- **Category:** Entertainment, Social
- **Mobile:** Mobile first experience.
- **Story:** Suko enables users to 
    - track anime they want to watch, are currently watching, and have watched,
    - discover new anime.
- **Market:** Anyone with a desire to watch anime can use this app. Partnerships with animation companies to promote specific anime could be used for monetization.
- **Habit:** Turning on a show after school or work is a common habit. So, anime watchers will be using this app very often to find new shows and update their status with a show. 
- **Scope:**
    - Allow users to search for and mark the anime they want to watch, are watching, and have watched,
    - Allow users to see what users near them are watching.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create a new account
* User can login
* User can search for an anime
* User can mark an anime as want-to-watch, watching, or watched
* User can friend/unfriend another user
* User can share an anime to another user in-app (and the other user can see received recommendations)

**Optional Nice-to-have Stories**

* User can rate an anime
* User can leave a review for an anime
* User can view others' review for an anime
* Users can create their own lists
* Users can follow their friends' anime lists
* User can post a recommendation request, and their friends can submit recommendations

### 2. Screen Archetypes

* Login Screen
   * Users are able to login/sign-up/logout from the application
* Sign Up Screen
   * Users are able to login/sign-up/logout from the application
* Home Screen
    * Users are able to see what their friends are watching
* Library Screen
    * Users are able to see (and click into) the three default lists: want to watch, watching, and watched
* List Screen
    * List of anime of a specific type (ex. want to watch, romance, etc.)
* Detail Screen
    * Users are able to see all relevant information about a specific anime
* Search / Explore Screen
    * Users are able to search for a specific anime
    * Users are able to see buttons that lead to genre-specific lists
* Profile Screen
    * Users are able to see and edit their profile picture
    * Users are able to see their lists

### 3. Navigation 

**Tab Navigation** (Tab to Screen)

* Home
* Library
* Search
* Profile

**Flow Navigation** (Screen to Screen)

* Home Screen
   * Click on specific anime ->  Detail Screen of an anime
* Library Screen
   * Click on a list -> List Screen of that list
* Anime List Screen
    * Click on specific anime ->  Detail Screen of an anime
* Search / Explore Screen
    * Click on specific anime ->  Detail Screen of an anime
    * Click on genre button -> List Screen of that genre

## Wireframes 
https://www.figma.com/file/VEcbEb136UlVuK9X9XaAOR/suko-app-showcase?node-id=0%3A1

[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [MKDropdownMenu](https://github.com/maxkonovalov/MKDropdownMenu) - dropdown menu for iOS
