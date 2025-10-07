//
//  AddApiDetailsView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 01/10/25.
//

import SwiftUI
import SwiftData

struct AddApiDetailsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    let apiService = ApiService()
    
    @State var apiUrl: String = "https://f6p0pmlm-8080.inc1.devtunnels.ms"
    @State var urlError: Bool = false
    
    
    var body: some View {
        VStack{
            TextField("Enter API URL", text: $apiUrl)
                .padding(.bottom)
            
            if urlError {
                Text("API Url was Incorrect.")
                    .foregroundStyle(.red)
                    .fontWeight(.bold)
            }
            
            Text("Done").onTapGesture {
                addApiDetails()
            }
        }.padding()
    }
    
    func addApiDetails() {
//        checking API URL
        print("button tapped")
        urlError = false
        apiService.getRequest(urlString: "\(apiUrl)/auth/health" , token : "") { result in
            switch result {
            case .success(let data):
                print("GET Response:", String(data: data, encoding: .utf8) ?? "")
                if let jsonString = String(data: data, encoding: .utf8) {
                            
//                    saving the api url in context
                    if let dict = apiService.convertJSONStringToDictionary(jsonString) {
                        if dict["status"] != nil {
                            if dict["status"]! as! String == "OK" {
                                context.insert(ApiDetails(url: apiUrl))
                                context.hasChanges ? try? context.save() : print("No changes")
                                dismiss()
                            }
                        }
                         
                    }
            }

            case .failure(let error):
                urlError = true
                print("Error:", error.localizedDescription)
            }
        }
        
       
    }
}

#Preview {
    NavigationStack{
        AddApiDetailsView()
            .modelContainer(for: ApiDetails.self, inMemory: true)
    }
}
