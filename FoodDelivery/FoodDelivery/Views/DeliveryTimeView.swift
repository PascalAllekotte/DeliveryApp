//
//  DeliveryTimeView.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 05.08.24.
//

import SwiftUI

struct DeliveryTimeView: View {
    @Binding var selectedDeliveryTime: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cartViewModel: CartViewModel

    @State private var selectedDay: String = ""
    @State private var selectedTimeSlot: String = ""

    // Funktion, um die nächsten Tage zu generieren
    func generateNextDays(count: Int) -> [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM" 
        
        let today = Date()
        var days: [String] = []
        
        for i in 0..<count {
            if let nextDate = calendar.date(byAdding: .day, value: i, to: today) {
                let dayString = dateFormatter.string(from: nextDate)
                days.append(dayString)
            }
        }
        return days
    }

    var body: some View {
        VStack {
            HStack {
                Text("Choose your delivery time")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding()

            ScrollView(.horizontal) {
                HStack {
                    ForEach(generateNextDays(count: 7), id: \.self) { day in
                        VStack {
                            Text(day)
                        }
                        .foregroundStyle(.black.opacity(0.8))
                        .padding()
                        .frame(width: 140)
                        .background(Color("produkt"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(cartViewModel.selectedDay == day ? Color.blue.opacity(0.6) : Color.clear, lineWidth: 3)
                        )
                        .shadow(radius: 1)
                        .onTapGesture {
                            cartViewModel.setSelectedDeliveryTime(day: day, timeSlot: cartViewModel.selectedTimeSlot)
                        }
                    }
                }
            }
            .padding(.top, -10)
            .padding(.leading)

            HStack {
                Text("Choose your best time")
                    .bold()
                Spacer()
            }
            .padding()

            ForEach(["14.00 - 16.00", "16.00 - 18.00", "18.00 - 20.00", "20.00 - 22.00"], id: \.self) { timeSlot in
                VStack {
                    Text(timeSlot)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("produkt").opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 12)))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(cartViewModel.selectedTimeSlot == timeSlot ? Color.blue.opacity(0.6) : Color.clear, lineWidth: 3)
                )
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color.blue.opacity(0.3), lineWidth: 1))
                .padding([.trailing, .leading, .top])
                .onTapGesture {
                    cartViewModel.setSelectedDeliveryTime(day: cartViewModel.selectedDay, timeSlot: timeSlot)
                }
            }

            Spacer()

            Button("Choose") {
                selectedDeliveryTime = cartViewModel.getSelectedDeliveryTime()
                dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("produkt"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 2)
            .foregroundStyle(.black)
            .padding()
        }
    }
}

#Preview {
    DeliveryTimeView(selectedDeliveryTime: .constant("14.00 - 16.00"))
      .environmentObject(CartViewModel())
}
