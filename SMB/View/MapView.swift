//
//  MapView.swift
//  SMB
//
//  Created by Mateusz Dylewski on 11/01/2023.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    var id: String
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @StateObject
    private var locationService = LocationService()
    
    private let notificationService = NotificationService()
    
    @StateObject
    private var shopService = ShopService()
    
    @State
    private var showListPopover = false
    
    @State
    private var showAddPopover = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $locationService.mapRegion,
                showsUserLocation: true,
                annotationItems: shopService.shopList
            ) { shop in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)) {
                    VStack {
                        Image(systemName: "star")
                            .resizable()
                            .foregroundColor(.yellow)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .padding(.bottom, -15)
                        Text(shop.name)
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                    }
                }
            }
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear {
                locationService.checkIfLocationServiceIsEnabled()
                notificationService.requestNotificationAuthorization()
                shopService.getShops()
            }
            
            HStack {
                Spacer()
                Button {
                    showAddPopover.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 75, height: 75)
                        .background(.blue)
                        .clipShape(Circle())
                }
                Spacer()
                Button {
                    showListPopover.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 75, height: 75)
                        .background(.blue)
                        .clipShape(Circle())
                }
                Spacer()
            }
        }
        .popover(isPresented: $showListPopover) {
            Text("Favourites")
                .font(.system(size: 40, weight: .bold))
                .padding(.top, 15)
                .padding(.bottom, -10)
            List {
                ForEach(shopService.shopList, id: \.id) { shop in
                    VStack {
                        Text(shop.name)
                        Text(shop.description)
                        Text(String(shop.range))
                        Text(String(shop.latitude) + " : " + String(shop.longitude))
                    }
                }
                .onDelete(perform: shopService.deleteById(at:))
            }
        }
        .popover(isPresented: $showAddPopover) {
            ShopAdd(locationService: locationService, shopService: shopService, showPopover: $showAddPopover)
        }
    }
}
