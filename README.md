# unsplash-ios-client
iOS Photos app based on Unsplash API

![Home](https://github.com/yura-voevodin/unsplash-ios-client/raw/master/Screenshots/Home.png)
![Search](https://github.com/yura-voevodin/unsplash-ios-client/raw/master/Screenshots/Search.png)

## Default state
Photos: https://unsplash.com/documentation#photos

- [x] Display a grid of pictures. ( request #1) 
- [x] The number of pictures in a row - 3.
- [x] Implement pagination in the list (no more than 10 pages)
- [x] Number of pictures per page - 30.

## Search by name
Search: https://unsplash.com/documentation#search

- [x] Implement search. ( request #2) 
- [x] The request should be sent, if was entered more than three characters
- [x] The number of pictures in a row - 1.
- [x] Needs implement the removing of pictures in the search mode. Deletion is relevant only for the current search result.

## General requirements
- [x] By tap on the picture should shown it on full screen.
- [x] The Network module should be located in a separate framework.
