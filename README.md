# sample_flutter_android_app

A Flutter Android application designed to connect to microcontrollers over WiFi. 

## Features  

- **WiFi Communication**: Establish a connection using an IP address and port number  
- **Data Visualization**: Display stored data in a chart format 
- **Chart Saving**: Save generated charts as images to the device gallery  
- **Navigation**: Multiple pages accessible via a drawer menu  

## Connection Details  

- **Communication Method**: WiFi using TCP/IP protocol with TCP Sockets  
- **Required Inputs**:   
  - IP Address 
  - Port number for communication  
- **Data Format**: JSON/Custom format for sending and receiving data   

### Connection Type  
This application utilizes **TCP/IP over Wi-Fi** with **TCP Sockets** for reliable, real-time communication between the mobile app and the microcontroller. This ensures stable data transfer and is suitable for monitoring and control applications.  

## Getting Started  

### Prerequisites  

- Flutter SDK installed  
- IDE with Flutter and Dart plugins installed (like VS code)  
- Mobile device connected to the Wifi Module's network  

### Installation  

1. Clone the repository

2. Navigate to the project directory

3. Install dependencies: 
   ```bash  
    flutter pub get  

4. Run the app: 
   ```bash 
    flutter run  
