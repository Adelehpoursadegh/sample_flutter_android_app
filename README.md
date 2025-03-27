# sample_flutter_android_app

A Flutter android application designed to connect to devices over WiFi. 

## Features  

- **WiFi Communication**: Establish a connection using an IP address and port number  
- **Data Visualization**: Display stored data in a chart format 
- **Chart Saving**: Save generated charts as images to the device gallery  
- **Navigation**: Multiple pages accessible via a drawer menu  

## Hardware Connection Details  

- **Communication Method**: WiFi using TCP/IP protocol with TCP Sockets  
- **Required Inputs**:   
  - IP Address 
  - Port number for communication  
- **Data Format**: JSON/Custom format for sending and receiving data   

### Connection Type  
This application utilizes **TCP/IP over Wi-Fi** with **TCP Sockets** for reliable, real-time communication between the mobile app and the electronic board. This ensures stable data transfer, suitable for monitoring and control applications.  

## Getting Started  

### Prerequisites  

- Flutter SDK installed  
- IDE with Flutter and Dart plugins installed    
- Mobile device connected to the electronic board's network  

### Installation  

1. Clone the repository

2. Navigate to the project directory

3. Install dependencies: 
   ```bash  
    flutter pub get  

4. Run the app: 
   ```bash 
    flutter run  
