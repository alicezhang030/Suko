# Suko

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description

Suko allows users to discover new anime and keep track of the anime they want to watch, are watching, and have watched. 

### App Evaluation
- **Category:** Entertainment, Social
- **Mobile:** Most anime enjoyers watch on their laptop, so it's more convenient for them if they could discover new shows and update their progress on a show without having to leave the website they're watching from. Thus, making Suko a mobile-first experience is crucial.
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
        - Take a quiz and receive anime recommendations based on their selections

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

MVP:
- [x] User can create a new account and login.
- [x] User can see non-tailored anime recommendations on the home page.
- [ ] User can search for an anime.
- [x] User can mark an anime as want-to-watch, watching, or watched.
- [x] User can view and edit their profile.

Ambiguous Problems:
- [ ] User can see on a map what users near them are watching.
- [ ] Users can take a quiz and receive anime recommendations based on their selections.

**Optional Nice-to-have Stories**
- [ ] User can rate and review animes.
- [ ] User can reply to anime reviews.
- [ ] Users can create custom lists.
- [ ] Users can set privacy settings for lists (i.e. visible to the public or not).
- [ ] User can friend/unfriend other users.
- [ ] User can share anime to other users in-app.
- [ ] Users can follow their friends' anime lists.
- [ ] User can post a recommendation request, and their friends can submit recommendations.

### 2. Screen Archetypes

* Login Screen
* Sign Up Screen
* Home Screen
    * Users are able to see what's trending overall and what's trending within specific genres. 
    * Users are able to search for a specific anime.
* Library Screen
    * Users are able to see (and click into) the three default lists: want to watch, watching, and watched
* List Screen
    * List of anime of a specific type (ex. want to watch, romance, etc.)
* Detail Screen
    * Users are able to see all relevant information about a specific anime
* Profile Screen
    * Users are able to see and edit their profile picture
    * Users are able to see their lists
    * Users are able to log out from the application

### 3. Navigation 

**Tab Navigation** (Tab to Screen)

* Home
* Library
* Map
* Profile

**Flow Navigation** (Screen to Screen)

* Home Screen
   * Click on specific anime ->  Detail Screen of an anime
   * Click on the see all button -> List Screen (ex. of the trending anime)
* Library Screen
   * Click on a list -> List Screen of that list
* Anime List Screen
    * Click on specific anime ->  Detail Screen of an anime

[**TODO:** Add what the flow navigation is for the map screen]

## Wireframes 
https://www.figma.com/file/VEcbEb136UlVuK9X9XaAOR/suko-app-showcase?node-id=0%3A1

[**TODO:** Add actual pictures of the wireframes.]

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
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [MKDropdownMenu](https://github.com/maxkonovalov/MKDropdownMenu) - dropdown menu for iOS
