//
//  ContentView.swift
//  Sample_CoreLocation
//
//  Created by Praveen George on 04/07/2021.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    
    @StateObject var locationViewModel = LocationManager()
      
      var body: some View {
          switch locationViewModel.authorizationStatus {
          case .notDetermined:
              AnyView(RequestLocationView())
                  .environmentObject(locationViewModel)
          case .restricted:
              ErrorView(errorText: "Location use is restricted.")
          case .denied:
              ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
          case .authorizedAlways, .authorizedWhenInUse:
              TrackingView()
                  .environmentObject(locationViewModel)
          default:
              Text("Unexpected status")
          }
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationManager
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                locationViewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationManager
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
    
    var body: some View {
        VStack {
            VStack {
                PairView(
                    leftText: "Latitude:",
                    rightText: String(coordinate?.latitude ?? 0)
                )
                PairView(
                    leftText: "Longitude:",
                    rightText: String(coordinate?.longitude ?? 0)
                )
                PairView(
                    leftText: "Altitude",
                    rightText: String(locationViewModel.lastSeenLocation?.altitude ?? 0)
                )
                PairView(
                    leftText: "Speed",
                    rightText: String(locationViewModel.lastSeenLocation?.speed ?? 0)
                )
                PairView(
                    leftText: "Country",
                    rightText: locationViewModel.currentPlacemark?.country ?? ""
                )
                PairView(leftText: "City", rightText: locationViewModel.currentPlacemark?.administrativeArea ?? ""
                )
            }
            .padding()
        }
    }
    
 
}
struct PairView: View {
    var leftText: String
    var rightText: String

    var body: some View {
        VStack {
            Text("\(leftText) :  \(rightText)")
                .foregroundColor(.gray)
                .padding(.bottom)
        }
    }
}
