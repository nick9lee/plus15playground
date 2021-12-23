//
//  ViewController.swift
//  plus 15 playground
//
//  Created by Nicholas Lee on 2021-09-12.
//
import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    var count = 1;
    
    var points = [ [41, -109.05], [41, -102.05], [37, -102.05], [37, -109.05] ];
    
    override func viewDidLoad() {
        
        mapView.delegate = self
        
        //center map on region
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.044916, longitude: -114.070336), span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06))
        
        mapView.addOverlays(self.parseGeoJSON())
        
        
        
        super.viewDidLoad()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonRenderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            polygonRenderer.lineWidth = 1.0
            polygonRenderer.strokeColor = UIColor.purple
            if count == 1 {
                polygonRenderer.fillColor = UIColor.red
                count = count + 1
            } else {
                polygonRenderer.fillColor = UIColor.blue
            }
            return polygonRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func parseGeoJSON() -> [MKOverlay] {
        guard let url = Bundle.main.url(forResource: "plus15", withExtension: "json") else {
            fatalError("Unable to get geojson")
        }
        
        var geoJson = [MKGeoJSONObject]()
        do {
            let data = try Data(contentsOf: url)
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            fatalError("Unable to decode geoJson")
        }
        
        var overlays = [MKOverlay]()
        for item in geoJson {
            if let feature = item as? MKGeoJSONFeature {
                for geo in feature.geometry {
                    if let polygon = geo as? MKPolygon {
                        overlays.append(polygon)
                    }
                }
            }
        }
        return overlays
    }
    
    

}

