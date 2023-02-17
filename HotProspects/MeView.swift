//
//  MeView.swift
//  HotProspects
//
//  Created by Tirth on 11/16/22.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreImage

struct MeView: View {
    @State private var name = ""
    @State private var emailAddress = ""
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 150) {
                Form {
                    TextField("Your name", text: $name)
                        .textContentType(.name)
                        .font(.title)
                    
                    TextField("Your name", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .font(.title)
                }
                
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
                Spacer()
            }
            .navigationTitle("Your Code")
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in updateCode() }
            .onChange(of: emailAddress) { _ in updateCode() }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                qrCode = UIImage(cgImage: cgimg)
                return qrCode
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
