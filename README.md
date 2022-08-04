# Suko

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description

Suko allows users to discover new anime, keep track of the anime they want to watch, and connect with other anime fans.

### App Evaluation
- **Category:** Entertainment, Social
- **Mobile:** Most people watch anime on their laptop, so it's more convenient for them if they could discover new shows and update their progress on a show without having to leave the website they're watching from. Thus, making Suko a mobile-first experience is crucial.
- **Story:** 
    - Anime series are often finished within a week, so it becomes very hard to remember the shows one has seen over time. Suko helps anime watchers keep track.
    - There are over 20,000 anime out there, so it's hard finding a good anime to watch. Suko helps anime watchers discover the perfect anime for them.
- **Market:** Anyone with a desire to watch anime can use this app. 
    - Anime's popularity is growing: Netflix reported that over 100 million households around the world watched anime in 2020, a 50% increase from 2019. Thus, the size of Suko's potential user base is large.
    - The only other anime tracking product out there is MyAnimeList, which has received many complaints regarding user experience. So, Suko would provide huge value to anime watchers. 
    - Partnerships with animation companies to promote specific anime could be used for monetization.
- **Habit:** Turning on a show after school or work is a common habit. So, anime watchers will be using this app very often to find new shows and update their status with a show. 
- **Scope:**
    - V1 (MVP) should allow users to 
        - Search for an anime,
        - Mark an anime as want to watch, watching, or watched.
    - V2 (Ambiguous Problems) should allow users to
        - See what users near them are watching,
        - Create events for nearby users,
        - Take a quiz and receive tailored anime recommendations.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

MVP:
- [x] User can create a new account and login.
- [x] User can see non-tailored anime recommendations on the home page.
- [x] User can search for an anime.
- [x] User can mark an anime as want-to-watch, watching, or watched.
- [x] User can view and edit their profile.

Ambiguous Problems:
- [x] User can see on a map where nearby users are and their profiles.
- [x] Users can create events for nearby users.
- [x] Users can take a quiz and receive tailored anime recommendations.

**Optional Nice-to-have Stories**
- [x] User can follow other users.
- [ ] User can rate and review anime.
- [ ] Users can create custom lists.
- [ ] Users can set privacy settings for lists (i.e. visible to the public or not).
- [ ] User can share anime to other users in-app.

### 2. Screen Archetypes

* Login Screen
* Sign Up Screen
* Home Screen
    * Displays what's trending overall and what's trending within specific genres.
    * User can search for a specific anime.
* Library Screen
    * Displays user's anime list titles.
* Anime List Screen
    * Displays anime belonging into this list.
* Anime Details Screen
    * Display all relevant information about the anime.
    * Users can add it to an anime list.
* Quiz Screen
    * Display trending movies.
    * Users can swipe on said trending movies.
* Browse Events Screen
    * Display nearby events and the events the user has registered for.
* Create Event Screen
    * Users can enter event information and select precise event location.
* Event Details Screen
    * Display all relevant information about the event
    * Users can register for the event.
* Profile Screen
    * Display user's profile informaton and anime lists.
    * User can edit the profile information if they are the profile owner.
    * User can log out from the application.

### 3. Navigation 

**Tab Navigation** (Tab to Screen)

* Home
* Library
* Events
* Community Map
* Profile

**Flow Navigation** (Screen to Screen)

* Home Screen
   * Search for an anime ->  Anime List Screen
   * Click on the see all button -> Anime List Screen 
   * Click on specific anime ->  Anime Detail Screen
   * Click on movies bar button -> Quiz Screen
* Quiz Screen
    * Finish the quiz -> Anime List Screen
* Library Screen
   * Click on a list title -> Anime List Screen
* Anime List Screen
    * Click on specific anime -> Anime Detail Screen
* Browse Events Screen
    * Click on a specific event -> Event Details Screen
    * Click on create event bar button -> Create Event Screen
* User Map Screen
    * Click on a pin on the map -> Profile Screen
* Profile Screen
    * Click on a list title -> Anime List Screen

## Wireframes 
https://www.figma.com/file/VEcbEb136UlVuK9X9XaAOR/suko-app-showcase?node-id=0%3A1

## Schema 
### Models
**SUKAnime**

|Property|Type|Description|
|---|---|---|
|malID|int|unique ID in MyAnimeList|
|title|NSString|title|
|posterURL|NSString|poster URL|
|synopsis|NSString|synopsis|
|numEpisodes|int|episode count|
|genres|NSArray<NSDictionary *>|genres this anime belongs to|

**SUKEvent**

|Property|Type|Description|
|---|---|---|
|name|NSString|event name|
|eventDescription|NSString|event description|
|location|PFGeoPoint|event coordinates|
|startTime|NSDate|event start day and time|
|endTime|NSDate|end day and time |
|postedBy|PFUser|user posting the event|
|attendees|NSArray<NSString *>|event attendees represented by an array containing their unique user object IDs|

**SUKFollow**

|Property|Type|Description|
|---|---|---|
|follower|PFUser|the user who is doing the following|
|userBeingFollowed|PFUser|the user being followed|

**SUKMovie**

|Property|Type|Description|
|---|---|---|
|ID|NSNumber|unique ID|
|title|NSString|title|
|genreIDs|NSArray<NSNumber *>|the IDs of the genres this movie belongs into|
|posterURL|NSString|poster URL|
|synopsis|NSString|synopsis|


### Networking

**External APIs:** [Jikan API](https://jikan.moe/) and [Movie Database API](https://developers.themoviedb.org/)
* Home Screen
    * (GET) Retrive trending anime from Jikan API
    * (GET) Retrive genre options from Jikan API
    * (GET) Retrive top anime from a specific genre from Jikan API
    * (GET) Retrive search results from Jikan API
* Anime List Screen
    * (GET) Retrive information on a specific anime from Jikan API
* Quiz Screen
    * (GET) Retrive trending movies from Movie Database API
    * (GET) Retrive genre options from Movie Database API
    * (GET) Retrive top anime from a specific genre from Jikan API

**Parse:**
* Browse Event Screen
    * (GET) Retrive the events within a 40 mile radius of the user's current location
    * (GET) Retrive the events the user has registered for
* User Map Screen
    * (GET) Retrive the users within a 3 mile radius of the user's current location.
* Create Event Screen
    * (POST) Create a new SUKEvent
* Profile Screen
    * (POST) Create a new SUKFollow 

## Credits
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [MKDropdownMenu](https://github.com/maxkonovalov/MKDropdownMenu) - dropdown menu for iOS
- [MDCSwipeToChoose](https://github.com/modocache/MDCSwipeToChoose) - swipe to "like" or "dislike" any view
