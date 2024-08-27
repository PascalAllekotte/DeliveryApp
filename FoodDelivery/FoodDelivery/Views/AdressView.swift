//  AdressView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 12.07.24.
//

import SwiftUI
import MapKit

struct AddressAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct AdressView: View {
    @EnvironmentObject var loginViewModel: AuthViewModel
    
    @State private var adress = AdressModel(street: "", streetNumber: "", postalCode: "", place: "")
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var annotation: AddressAnnotation?
    
    var body: some View {
        VStack {
            Text("Lieferadresse")
                .font(.title)
            
            TextField("Straße", text: $adress.street)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                .padding(.bottom, 10)
            
            HStack {
                TextField("Hausnummer", text: $adress.streetNumber)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                
                TextField("Postleitzahl", text: $adress.postalCode)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            }
            .padding(.bottom, 10)
            
            TextField("Ort", text: $adress.place)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                .padding(.bottom, 10)
            
            Button("Adresse suchen") {
                searchLocation()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 2)
            .foregroundStyle(.black)
            
            Map(coordinateRegion: $region, annotationItems: annotation != nil ? [annotation!] : []) { annotation in
                MapMarker(coordinate: annotation.coordinate, tint: .red)
            }
            .frame(height: 300)
            .cornerRadius(10)
            
            Spacer()
            
            Button("Bestätigen") {
                updateAddress()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 2)
            .foregroundStyle(.black)
        }
        .padding()
        .onAppear {
            if let user = loginViewModel.user {
                self.adress = user.adress
            }
        }
    }
    
    func searchLocation() {
        let geocoder = CLGeocoder()
        let addressString = "\(adress.street) \(adress.streetNumber), \(adress.postalCode) \(adress.place)"
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                withAnimation {
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                    annotation = AddressAnnotation(coordinate: location.coordinate)
                }
            }
        }
    }
    
    func updateAddress() {
        loginViewModel.updateAddress(newAddress: adress)
    }
}


#Preview {
    AdressView()
        .environmentObject(AuthViewModel())
}
