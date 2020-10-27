//
//  WaterMiWidget.swift
//  WaterMiWidget
//
//  Created by Sascha on 26.10.20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let plantDatabaseManager = PlantDatabaseManager()
    
    /**View that is presented while the Widget is loading!*/
    func placeholder(in context: Context) -> PlantEntry {
        return PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!)
    }
    
    /**Snapshot is used to display widget in the widget center as preview*/
    func getSnapshot(in context: Context, completion: @escaping (PlantEntry) -> ()) {
        let entry = PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!)
    }
    
    /**Time line when the widget is presented and updated. */
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [PlantEntry] = []
        let plants = plantDatabaseManager.loadPlants()
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        //TODO: Methode macht aktuell noch keinen sinn da jede stunde die gleichen aktuellen daten eingesetzt werden.
        for minuteOffset in 0 ..< plants.count {
            let entryDate = Calendar.current.date(byAdding: .second, value: minuteOffset * 5, to: currentDate)!
            let entry = PlantEntry(date: entryDate, plantName: plants[minuteOffset].plantName!, plantImage: UIImage(data: plants[minuteOffset].plantImage!)!)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

/**Description of the Data that will be presented in the Widget*/
struct PlantEntry: TimelineEntry {
    let date: Date
    
    let plantName:String
    let plantImage:UIImage
}

/**UI Representation of the widget*/
struct WaterMiWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.colorScheme) private var colorScheme
    
    
    
    var body: some View {
        ZStack{
            if colorScheme == .light {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 4, content: {
                        Image(uiImage: entry.plantImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        Text(entry.plantName)
                    })
                    if widgetFamily != .systemSmall {
                        Divider()
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(uiImage: entry.plantImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            Text(entry.plantName)
                        })
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.yellow,.green ]), startPoint: .topLeading, endPoint: .bottomTrailing))
            } else {
                //dark color scheme
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 4, content: {
                        Image(uiImage: entry.plantImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        Text(entry.plantName)
                    })
                    if widgetFamily != .systemSmall {
                        Divider()
                        HStack(alignment: .center, spacing: 4, content: {
                            Image(uiImage: entry.plantImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            Text(entry.plantName)
                        })
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.orange,.blue ]), startPoint: .topLeading, endPoint: .bottomTrailing))
            }
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
        WaterMiWidgetEntryView(entry: PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .dark)
        
        WaterMiWidgetEntryView(entry: PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.colorScheme, .dark)
        
        WaterMiWidgetEntryView(entry: PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .environment(\.colorScheme, .dark)
        
        WaterMiWidgetEntryView(entry: PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .light)
        
        WaterMiWidgetEntryView(entry: PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.colorScheme, .light)
        
        WaterMiWidgetEntryView(entry: PlantEntry(date: Date(), plantName: "Olivio", plantImage: UIImage(named: "WaterMi_Image")!))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .environment(\.colorScheme, .light)
    }
}


