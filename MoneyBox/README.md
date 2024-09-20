# Moneybox Lite App - Oliver Ives 

## Overview
This project implements a lightweight version of the Moneybox app, allowing existing users to log in, check their account balances, and manage their Moneybox savings. The app is designed to provide a clean and user-friendly interface while showcasing best practices in coding style, conventions, and design patterns.

## Features
- **Login Screen**: Allows existing users to sign in with email and password.
- **Accounts Screen**: Displays the user's accounts and the total plan value.
- **Account Details Screen**: Shows detailed information about a selected account, including a button to add £10 to the Moneybox.
- **Haptic Feedback**: Provides tactile feedback for button presses, enhancing the user experience.
- **Dark Mode Support**: Fully supports dark mode, adjusting the UI based on user preferences.
- **API Integration**: Utilizes the provided Networking module to handle API requests with proper error handling.
- **Unit Tests**: Includes comprehensive unit tests for components and UI interactions.
- **Accessibility Features**: Implemented accessibility features to enhance user experience.

## Technologies Used
- Swift
- UIKit
- Auto Layout
- Networking (provided module)
- Xcode 16

## API Usage
The app interacts with the Moneybox API.

### Test User Credentials
To test the app, use the following credentials:
- **Username**: `test+ios@moneyboxapp.com`
- **Password**: `P455word12`

## Unit Testing
The project includes unit tests located in the `MoneyBoxTests` and `MoneyBoxUITests` folders, utilizing mocked data for API responses. Tests cover login functionality, account fetching, and UI updates based on user actions.

## Code Organization
The code is structured to follow MVVM architecture and adhere to SOLID principles, ensuring maintainability and scalability. The organization includes:
- **Views**: UI components, each responsible for its own layout and presentation logic.
- **ViewModels**: Business logic and data handling for the views.
- **Networking**: API interaction, encapsulating all network calls and responses.
- **Models**: Data models representing the entities used in the app.

## Running the App
- Clone the repository to your local machine.
- Open the project in Xcode.
- Build and run the app on a simulator or physical device with iOS 15 or later.
