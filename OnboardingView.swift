//
//  OnboardingView.swift
//  Infinity
//
//  Created by Berk Dogan on 12/8/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    
    var body: some View {
        if currentPage > totalPages {
            HomeView()
        }
        else {
            WalkthroughScreen()
        }
        
    }
}
 
struct WalkthroughScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack {
            
            
            // Changing between views
            if currentPage == 1 {
                ScreenView(image: "level", title: "Unique Level", detail: "By using two lines, you can measure any surface or angle with ease", bgColor: Color("color1"))
                    .transition(.scale)
            }
            if currentPage == 2 {
                ScreenView(image: "compass", title: "Compass", detail: "Easily accessible compass", bgColor: Color("color2"))
                    .transition(.scale)
            }
            if currentPage == 3 {
                ScreenView(image: "thankyou", title: "Bubbles Pro", detail: "If you like the app and want to support the development of Bubbles and disable ads, you can check out Bubbles Pro (one-time purchase) in settings.", bgColor: Color("color3"))
                    .transition(.scale)
            }
            
        } // END ZSTACK
        .overlay {
            
            // Pushing the button and text to the bottom
            VStack {
                Spacer()
                // Button
                Button(action: {
                    // changing views
                    withAnimation(.easeInOut) {
                        if currentPage <= totalPages {
                            currentPage += 1
                        } else {
                            currentPage = 1
                        }
                    }
                    
                }, label:{
                    Image (systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(
                            ZStack {
                                Circle()
                                    .stroke(Color.black.opacity(0.04), lineWidth: 4)
                                    .padding(-15)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages)) // this is for getting a nice circle indicator
                                    .stroke(Color.white, lineWidth: 4)
                                    .rotationEffect(.init(degrees: -90))
                                    .padding(-15) // match the other circle
                            }
                        )
                }) // End Button
                .padding(.bottom, 20)
            }
            
        }
    } // END VIEW
}

struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                
                // Showing it only for the first page ...
                if currentPage == 1 {
                    Text("Welcome to Bubbles")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                } else {
                    // Back button
                    Button(action: {
                        
                        withAnimation(.easeInOut) {
                            currentPage -= 1
                        }
                        
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(15)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    
                    withAnimation(.easeInOut) {
                        currentPage = 4
                    }
                    
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            } // END HSTACK
            .foregroundColor(.black)
            .padding()
            
            Spacer(minLength: 0)
            
            /**
             Images goes here
             */
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
            
            /**
             Title of the screen
             */
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
            
            /**
             Body of the screen
             */
            Text(detail)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .kerning(1.3)
                .multilineTextAlignment(.center)
                .padding(20)
            
            
            // Minimum spacing when phone is reducing
            Spacer(minLength: 120)
            
            
        } // END VSTACK
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}


// Total Pages
var totalPages = 3

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughScreen()
    }
}
