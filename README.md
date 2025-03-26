# sample_flutter_android_app

A new Flutter project.
A Flutter application designed to connect to devices over WiFi. The app enables users to monitor and visualize data from the connected device, save charts, and configure settings.  

## Features  

- **WiFi Communication**: Establish a connection using an IP address and port number  
- **Data Visualization**: Display real-time or stored data in a chart format 
- **Chart Saving**: Save generated charts as images to the device gallery  
- **Navigation**: Multiple pages accessible via a drawer menu  

## Pages  

1. **Home Page**:   
   - Input field for IP address  
   - Connect/Start button to establish communication  
   - Connection status indicator  

2. **Plot Page**:   
   - Displays data in a chart format  
   - Option to save the chart as an image  

3. **Calibration Settings Page**:   
   - Configure calibration settings  
   - Save calibration values  

4. **Help Page** 

5. **About Page**

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

1. Clone the repository:  
   ```bash  
   git clone https://github.com/yourusername/WifiRemoteMonitoring.git  

2. Navigate to the project directory: 
    cd WifiRemoteMonitoring  

3. Install dependencies: 
    flutter pub get  

4. Run the app: 
    flutter run  
