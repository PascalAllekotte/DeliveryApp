import SwiftUI
import FirebaseAnalytics

struct ProductWeightDetail: View {
    var produkt: ProductMeatModel
    
    @State private var quantity = 1
    @State private var gramm: Double = 75
    @State private var berechneterPreis: Double = 0.0
    @State private var isFavorite: Bool = false
    @FocusState private var isInputActive: Bool
    @State private var isZutatenExpanded = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel

    var preisProGramm: Double {
        let preisProKilogramm = Double(produkt.price.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "€", with: "")) ?? 0.0
        return preisProKilogramm / 1000.0
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ZStack {
                    VStack(alignment: .center) {
                        AsyncImage(
                            url: URL(string: produkt.imageURL),
                            content: { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 350)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                                    .padding(.horizontal, 40)
                            },
                            placeholder: {
                                Image(systemName: "photo")
                                    .frame(width: 350, height: 350)
                                    .overlay(Text("Bild\nnicht\ngefunden")
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center))
                                    .padding(.horizontal, 40)
                            }
                        )
                        .padding(.top, 70)
                        
                        Text(produkt.productName)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                // teilen code noch später
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .padding(.trailing, 20)
                            }
                            .padding(.top, 70)
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                toggleFavorite(for: produkt)
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.title)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .padding(.trailing, 20)
                            }
                            .padding(.bottom, 10)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                
                HStack {
                    Text("\(produkt.price)€/kg")
                        .foregroundStyle(.gray)
                        .padding(.leading)
                    Spacer()
                    
                    //____Vorgefertigte Auswahl_______________________________________________
                    VStack {
                        Grid {
                            GridRow {
                                Text("\(produkt.vauswahl1)g")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Text(String(format: "%.2f €", preisProGramm * Double(produkt.vauswahl1)!))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Button(action: {
                                    addPredefinedEntry(amount: produkt.vauswahl1)
                                }) {
                                    Text("+")
                                        .font(.system(size: 20))                                        .padding(5)
                                        .background(Color("produkt"))
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.top, 5)
                            .fontWeight(.semibold)

                        
                            GridRow {
                                Text("\(produkt.vauswahl2)g")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Text(String(format: "%.2f €", preisProGramm * Double(produkt.vauswahl2)!))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Button(action: {
                                    addPredefinedEntry(amount: produkt.vauswahl2)
                                }) {
                                    Text("+")
                                        .font(.system(size: 20))
                                        .padding(5)
                                        .background(Color("produkt"))
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                                }
                            }
                            .padding(.horizontal, 5)
                            .padding(.top, 5)
                            .fontWeight(.semibold)

                        }
                        .frame(width: 250, height: 100)
                        .background(Color("addfarbe2"))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .shadow(radius: 1)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, -10)
                .padding()

                
                Text(String(format: "%.2f €", berechneterPreis))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, -20)
                
                VStack {
                    if let productId = produkt.id {
                        ForEach(cartViewModel.getEntries(for: productId).indices, id: \.self) { index in
                            HStack {
                                Button(action: {
                                    cartViewModel.removeEntry(for: productId, at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.gray)
                                }
                                .padding(.leading, 5)
                                Text("\(Int(cartViewModel.getEntries(for: productId)[index].gramm)) g")
                                    .font(.subheadline)
                                    .padding(.leading, 5)
                                Spacer()
                                Text(String(format: "%.2f €", cartViewModel.getEntries(for: productId)[index].preis))
                                    .font(.subheadline)
                                    .padding(.trailing, 5)
                            }
                            .padding([.top, .bottom], 2)
                            .padding([.leading, .trailing], 30)
                            .background(Color.white.opacity(0.1))
                        }
                    }
                }
                .padding([.leading, .bottom], 10) // Gesamtpadding für den VStack
                
                HStack {
                    Text("\(Int(gramm)) g")
                        .font(.subheadline)
                    
                    Slider(value: $gramm, in: 75...1000, step: 25)
                        .padding()
                        .onChange(of: gramm) { _, newValue in
                            berechneterPreis = newValue * preisProGramm
                        }
                        .padding(.leading, -10)
                }
                .padding([.leading, .trailing], 35)

                Button(action: {
                    if gramm > 74 {
                        cartViewModel.addEntry(for: produkt, gramm: gramm, preis: berechneterPreis)
                        Analytics.logEvent("artikel_hinzugefuegt", parameters: ["anzahl": quantity, "gramm": gramm, "preis": berechneterPreis])
                        gramm = 75
                        berechneterPreis = gramm * preisProGramm
                    }
                }) {
                    Text("Hinzufügen")
                        .padding(5)
                        .background(Color("addfarbe2"))
                        .foregroundStyle(.black)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                }
                .padding(.bottom, 10)
                
            }
            .background(Color("produkt"))
            
            // MARK: FOLDING INFORMATIONS
            
            DisclosureGroup(isExpanded: $isZutatenExpanded) {
                VStack(alignment: .leading) {
                    Text("Zutatenliste hier.")
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } label: {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("Zutaten")
                    Spacer()
                    Image(systemName: isZutatenExpanded ? "chevron.up" : "chevron.down")
                }
                .foregroundStyle(.black)
                .padding()
                .background(Color.white)
            }
            .padding(8)
            Divider()
                .padding(.bottom, 100)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.all)
        .onAppear {
            isFavorite = authViewModel.user?.favorites.contains(produkt.id ?? "") ?? false
        }
    }
    
    func toggleFavorite(for product: ProductMeatModel) {
        guard let productId = product.id else { return }
        if authViewModel.user?.favorites.contains(productId) ?? false {
            authViewModel.removeFromFavorites(productId: productId)
            isFavorite = false
        } else {
            authViewModel.addToFavorites(productId: productId)
            isFavorite = true
        }
    }
    
    func addPredefinedEntry(amount: String) {
        if let amountValue = Double(amount) {
            let preis = amountValue * preisProGramm
            cartViewModel.addEntry(for: produkt, gramm: amountValue, preis: preis)
            Analytics.logEvent("artikel_hinzugefuegt", parameters: ["anzahl": quantity, "gramm": amountValue, "preis": preis])
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ProductWeightDetail(produkt: ProductMeatModel(
        description: "Beispiel Produktbeschreibung",
        imageURL: "https://storage.googleapis.com/appshop-691f3.appspot.com/goho.png",
        price: "63,27€",
        productName: "Beispiel Produkt",
        vauswahl1: "100",
        vauswahl2: "200",
        discount: true,
        discountDetail: "10",
        isFavorite: true,
        category: "Rind"
    ))
    .environmentObject(AuthViewModel())
    .environmentObject(CartViewModel())
}
