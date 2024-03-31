# CoinTracker App

## Overview

This iOS application allows users to track cryptocurrency prices and details. It is developed using **Xcode 15.3** and leverages **RxSwift** along with **UIKit** for reactive programming and UI development.

## Features

- Data is fetched from the provided API to display cryptocurrency information.
- Supports multi-screen sizes for optimal user experience.
- Users can view detailed information about a specific cryptocurrency by tapping on its item.
- Infinite scrolling implemented to load more coins when the user reaches the bottom of the page.
- Pull-to-refresh functionality enables users to update data.
- Top 3 coins by rank are displayed at the top section when searching isn't active.
- Invite friends feature prompts users to invite friends to join the app. Invitation prompts appear at positions 5, 10, 20, 40, 80, 160, etc., and users can share invitations with friends.

## Design Pattern

The application is structured using the **MVVM** (Model-View-ViewModel) design pattern, which facilitates clear separation of concerns and easy unit testing.

## Third-Party Libraries

**RxSwift** is used to handle reactive programming, providing a robust and efficient way to handle asynchronous operations and UI events.
