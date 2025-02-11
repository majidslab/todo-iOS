//
//  SignInView.swift
//  todo-online
//
//  Created by Majid Jamali on 1/21/25.
//

import SwiftUI
//import GoogleSignIn
//import GoogleSignInSwift
import CryptoKit

struct SignInView: View {
    
    @State private var fullName: String = ""
    @State private var userName: String = ""
    @State private var password: String = ""
    
    @State private var isShowingSignUpView: Bool = false
    @State private var presentError: Bool = false
    @State private var localError: ErrorResult? = nil
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        VStack(spacing: 0.0) {
            GeometryReader { geo in
                HStack {
                    Button {
                        withAnimation(.default) {
                            isShowingSignUpView.toggle()
                            localError = nil
                        }
                    } label: {
                        Text("Sign in")
                            .padding(.vertical, 8.0)
                            .padding(.horizontal, 24.0)
                    }
                    .background(
                        ZStack {
                            if isShowingSignUpView == false {
                                Capsule()
                                    .strokeBorder(lineWidth: 3.0, antialiased: true)
                                    .foregroundStyle(AnyGradient(Gradient(colors: [Color.selectedDateBG, Color.clear, Color.clear])))
                            }
                        }
                    )
                    .buttonStyle(.plain)
                    .font(.headline)
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                    
                    Button {
                        withAnimation(.default) {
                            isShowingSignUpView.toggle()
                            localError = nil
                        }
                    } label: {
                        Text("Sign up")
                            .padding(.vertical, 8.0)
                            .padding(.horizontal, 24.0)
                    }
                    .background(
                        ZStack {
                            if isShowingSignUpView == true {
                                Capsule()
                                    .strokeBorder(lineWidth: 3.0, antialiased: true)
                                    .foregroundStyle(AnyGradient(Gradient(colors: [Color.selectedDateBG, Color.clear, Color.clear])))
                            }
                        }
                    )
                    .buttonStyle(.plain)
                    .font(.headline)
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                }
                .padding(.top, 16.0)
            }
            .frame(height: 60.0)
            List {
                if isShowingSignUpView {
                    AddTaskListItemView(title: "FullName") {
                        TextField("fullname", text: $fullName, prompt: nil, axis: .horizontal)
                            .keyboardType(.default)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                    }
                    .foregroundStyle(localError != nil ? .red : .primary)
                }
                AddTaskListItemView(title: "Username") {
                    TextField("username", text: $userName, prompt: nil, axis: .horizontal)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                .foregroundStyle(localError != nil ? .red : .primary)
                AddTaskListItemView(title: "Password") {
                    SecureField("password", text: $password, prompt: nil)
                        .textContentType(.password)
                }
                .foregroundStyle(localError != nil ? .red : .primary)
            }
            .listRowInsets(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
            
            HStack(spacing: 8.0) {
                
                Button {
                    // local login
                    guard checkIfNotEmpty() else {
                        localError = ErrorResult.emptyInputFields
                        presentError.toggle()
                        return
                    }
                    if isShowingSignUpView {
                        userSignUp()
                    } else {
                        userLogin()
                    }
                } label: {
                    HStack {
                        Text(isShowingSignUpView ? "Sign up" : "Sign in")
                    }
                    .foregroundStyle(Color.selectedTaskItem)
                    .padding(.horizontal, 24.0)
                    .padding(.vertical, 12.0)
                    .background(
                        ZStack {
                            Capsule()
                                .foregroundStyle(Color.selectedDateBG.gradient)
                                .rotationEffect(.degrees(360))
                                .padding(8.0)
                            Capsule()
                                .strokeBorder(lineWidth: 3.0, antialiased: true)
                                .foregroundStyle(AnyGradient(Gradient(colors: [Color.selectedDateBG, Color.clear, Color.clear])))
                        }
                    )
                    .font(.headline)
                    .buttonStyle(.plain)
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Image(.google)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 18.0, height: 18.0)
                        Text("Continue with Google")
                    }
                    .foregroundStyle(Color.selectedTaskItem)
                    .padding(.horizontal, 18.0)
                    .padding(.vertical, 12.0)
                    .background(
                        ZStack {
                            Capsule()
                                .foregroundStyle(Color.selectedDateBG.gradient)
                                .rotationEffect(.degrees(360))
                                .padding(8.0)
                        }
                    )
                    .font(.headline)
                    .buttonStyle(.plain)
                }
                .disabled(true)
            }
            .alert(localError?.message ?? "", isPresented: $presentError) {
                Button("OK") {
                    withAnimation(.default) {
                        presentError.toggle()
                        localError = nil
                    }
                }
            }

            Spacer(minLength: 8.0)
        }
    }
}

extension SignInView {
    
    func checkIfNotEmpty() -> Bool {
        if isShowingSignUpView {
            return !fullName.isEmpty && !userName.isEmpty && !password.isEmpty
        }
        else {
            return !userName.isEmpty && !password.isEmpty
        }
    }
    
    func userLogin() {
        localError = nil
        userSignInRequest { result, error in
            if let result {
                let user = UserModel(name: nil, family: nil, fullName: nil, profileImage: nil, gmail: nil, userName: userName, password: password, gmailToken: nil, lastLogin: Date.now, accessToken: result.token, registrationDate: nil)
                Task {
                    modelContext.insert(user)
                    try modelContext.save()
                    dismiss()
                }
            } else if let error {
                // throw error!
                localError = error
                presentError.toggle()
            }
        }
    }
    
    func userSignUp() {
        localError = nil
        userSignUpRequest { result, error in
            if let result {
                let user = UserModel(name: nil, family: nil, fullName: fullName, profileImage: nil, gmail: nil, userName: userName, password: password, gmailToken: nil, lastLogin: Date.now, accessToken: result.token, registrationDate: Date.now)
                Task {
                    modelContext.insert(user)
                    try modelContext.save()
                    dismiss()
                }
            } else if let error {
                // throw error!
                localError = error
                presentError.toggle()
            }
        }
    }
    
    func userSignInRequest(completion: @escaping((SignInResult?, ErrorResult?) -> Void)) {
        
        // fullname: majidjamali
        // username: majid1
        // password: 65413asd321xZXC2ASWDwq!#@!@234$@CXE -> no hashing needed
        let body = SignInBody(username: userName, password: password)
        let manager = NetworkManager()
        manager.request(SignInResult.self, url: URL.signinPOST, method: .post, requestBody: body, isPublicBearer: true, userAuthenticationBearer: nil) { result, error in
            return completion(result, error)
        }
    }
    
    func userSignUpRequest(completion: @escaping((SignUpResult?, ErrorResult?) -> Void)) {
        let body = SignUpBody(fullName: fullName, username: userName, password: password)
        let manager = NetworkManager()
        manager.request(SignUpResult.self, url: URL.signupPOST, method: .post, requestBody: body, isPublicBearer: true, userAuthenticationBearer: nil) { result, error in
            return completion(result, error)
        }
    }
}
