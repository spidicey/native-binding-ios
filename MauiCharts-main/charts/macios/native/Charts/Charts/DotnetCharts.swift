//
//  DotnetCharts.swift
//  Charts
//
//  Created by .NET MAUI team on 6/18/24.
//

import Foundation
import UIKit
import DGCharts
import GoSignSDKLite

@objc(DotnetCharts)
public class DotnetCharts : NSObject {
        
    @objc
    public static func getString(myString: NSString) -> NSString {
        return myString
    }
    
    @objc
    public static func createPieChart(data: [String : Double], colors: [UIColor]?) -> UIView {
        let pieChartView = renderPieChart()
        
        var pieChartData: [String: Double] = [:]
        data.forEach { key, value in
            pieChartData[key as String] = value
        }

        setChartData(pieChart: pieChartView, data: pieChartData, colors: colors)
        return pieChartView
    }
    @objc
    public static func registerDevice(myString: String, localizedReason: String)
        -> String
    {
        var alias="";
        var fail="";
        API.registerDevice(authenToken: myString) { response in
         // response: Result<RegisterDeviceAPIResponse, Error>
         switch response {
             case .success(let result):
                 alias = result.alias ?? "";
                 break;
             case .failure(let failure):
                 let error = failure as! ServerResponseError
                 fail = "Failure: \(error.message)"
                 break;
            }
        }
        return alias.isEmpty ? fail : alias;
    }
    
    
    static func renderPieChart() -> PieChartView {
        let pieChartview = PieChartView()

        pieChartview.backgroundColor = UIColor.clear
        pieChartview.holeColor = UIColor.clear
        pieChartview.legend.enabled = false
        pieChartview.rotationAngle = 270

        return pieChartview
    }
    
    static func setChartData(pieChart: PieChartView, data: [String : Double], colors: [UIColor]?) {
        let entries = data.map { return PieChartDataEntry(value: $0.value, label: $0.key) }
        let dataSet = PieChartDataSet(entries: entries)
        
        if let chartColors = colors {
            dataSet.colors = chartColors
        }
        else {
            dataSet.colors = ChartColorTemplates.material()
        }
        
        let data = PieChartData(dataSet: dataSet)
        data.setValueFont(.systemFont(ofSize: 18, weight: .bold))
        data.setValueTextColor(.white)

        pieChart.data = data
        pieChart.notifyDataSetChanged()
    }
}
