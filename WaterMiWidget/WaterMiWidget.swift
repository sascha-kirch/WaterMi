//
//  WaterMiWidget.swift
//  WaterMiWidget
//
//  Created by Sascha on 26.10.20.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    
    // MARK: - Core Data stack
    
    /**View that is presented while the Widget is loading!*/
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), plantName:"Olivio", plantImage: UIImage(named: "WaterMi_Image")!)
    }
    
    //  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    //      let Plants:[Plant] = loadPlants()
    //      let entry = SimpleEntry(date: Date(), plantName: Plants[0].plantName ?? "No Plant yet", plantImage: UIImage(data:Plants[0].plantImage!) ?? UIImage(named: //"WaterMi_Image")!)
    //      completion(entry)
    //  }
    //
    //  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    //      var entries: [SimpleEntry] = []
    //      let Plants:[Plant] = loadPlants()
    //
    //      // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    //      let currentDate = Date()
    //      for hourOffset in 0 ..< 5 {
    //          let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
    //          let entry = SimpleEntry(date: Date(), plantName: Plants[0].plantName ?? "No Plant yet", plantImage: UIImage(data:Plants[0].plantImage!) ?? UIImage(named: //"WaterMi_Image")!)
    //          entries.append(entry)
    //      }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), plantName:"Olivio", plantImage: UIImage(named: "WaterMi_Image")!)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: Date(), plantName:"Olivio", plantImage: UIImage(named: "WaterMi_Image")!)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

/**Description of the Data that will be presented in the Widget*/
struct SimpleEntry: TimelineEntry {
    let date: Date
    
    var plantName : String
    var plantImage : UIImage
}

struct WaterMiWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 4) {
                HStack(alignment: .center, spacing: 4, content: {
                    Image(uiImage: entry.plantImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    Text(entry.plantName)
                })
                
                Text(entry.date, style: .time)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [.yellow,.green ]), startPoint: .topLeading, endPoint: .bottomTrailing))
            //Link(destination: , label: {
            //    /*@START_MENU_TOKEN@*/Text("Link")/*@END_MENU_TOKEN@*/
            //})
        }
    }
}

/**Info of the widget that will be displayed when setting up the Widget!*/
@main
struct WaterMiWidget: Widget {
    let kind: String = "WaterMiWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WaterMiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WaterMi Plant Status")
        .description("Shows the current WaterMi reminders and watering status")
    }
}

struct WaterMiWidget_Previews: PreviewProvider {
    static var previews: some View {
        WaterMiWidgetEntryView(entry: SimpleEntry(date: Date(), plantName:"Olivio", plantImage: UIImage(named: "WaterMi_Image")!))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
