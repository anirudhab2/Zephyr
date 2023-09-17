# Zephyr
[Zephyr](https://en.wikipedia.org/wiki/Zephyr) is a sample weather app that displays current weather data from OpenWeatherMap to the users

## Features
- [x] Displaying weather data from user's current location.
- [x] Allowing users to search for a location and displaying weather information for the lcoation.
- [x] Interactive search where user can see the results as typed, with appropriate rate limiting handling. 
- [x] Users can switch between Metric and Imperial units.
- [x] Appropriate unit conversion based on user's preference. 
- [x] Displayed weather information -
  - [x] Current temperature.
  - [x] Currrent location for weather data.
  - [x] Icon that appropriately conveys the current weather.
  - [x] Current weather description, such as clouds, mist etc.
  - [x] Temperature range throughout the day.
  - [x] Apparent temperature or "Feels like" temperature.
  - [x] Atmospheric conditions such as humidity, pressure, wind speed and visibilty.
  - [x] Sunrise and sunset time. 
  - [x] Rain and snow fall measurement when available.
- [x] Error cases handled -
  - [x] Location permissions not granted by user.
  - [x] Unable to determine user's location.
  - [x] Weather data not available for a lcoation.
  - [x] Location results not available for user's search query.     

## Specifications
* Language - Swift 5.7 with UIKit
* Architecture - MVVM
* CoreLocation for location access, URLSession for networking.
* Data source - OpenWeatherMap's [Current weather data](https://openweathermap.org/current) and [Geocoding](https://openweathermap.org/api/geocoding-api) APIs
* Third party libraries used - none

## Scope for improvements [WIP]
- [ ] Unit testing.
- [ ] Exploring alternative data sources to combat downtime and data unavailablity issues.
- [ ] Different presentation styles to improve user experience.
- [ ] Hourly and weekly forecast.

[Screenshots](https://github.com/anirudhab2/Zephyr/issues/3)
