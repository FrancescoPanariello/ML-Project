//
//  ContentView.swift
//  ML Project
//
//  Created by Francesco Panariello on 24/03/22.
//

import SwiftUI
import CoreML

struct ContentView: View {
    let animals = ["tiger","flamingo", "horse"]
    @State private var num_element : Int = 0
    let model = SqueezeNet()
    @State private var classification: String = ""
    
    
    var body: some View {
        VStack{
            Text("Animal Classifier").font(.largeTitle).bold()
            Image(animals[num_element])
                .resizable() .scaledToFit()
            HStack{
                Button("<"){
                if(self.num_element != 0){
                   self.num_element = self.num_element - 1
                    self.classification = ""
                }}
                Spacer()
                Button("Verify") {
                    verify()
                }.foregroundColor(.green)
                Spacer()
                Button(">"){
                if(self.num_element < animals.count - 1){
                   self.num_element = self.num_element + 1
                    self.classification = ""
                }}
            }.padding()
        
            Divider()
            VStack(spacing: 20){
        Text("Result:")
        Text(classification)
            }
            
        Spacer()
        }
    }
    
    func verify(){
        let currentImageName = animals[num_element]
        
        guard let image = UIImage(named: currentImageName),
              let resizedImage = image.converterpixelBuffer(width: 227, height: 227) else{
                  return
              }
             
        
        let output = try? model.prediction(image: resizedImage)
        if let output = output {
                let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            
            let top3 = results.prefix(3).map { (key, value) in
                    return "\(key) = \(String(format: "%.2f", value * 100))%"
                }.joined(separator: " \n")

               
                self.classification = top3
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
