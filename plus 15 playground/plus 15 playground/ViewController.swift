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
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.046585247614, longitude: -114.075468099458), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
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
            } else if count == 2 {
                polygonRenderer.fillColor = UIColor.blue
            } else if count == 3 {
                polygonRenderer.fillColor = UIColor.purple
            } else if count == 4 {
                polygonRenderer.fillColor = UIColor.green
            } else if count == 5 {
                polygonRenderer.fillColor = UIColor.yellow
            } else if count == 6 {
                polygonRenderer.fillColor = UIColor.orange
            } else if count == 7 {
                polygonRenderer.fillColor = UIColor.brown
            } else {
                polygonRenderer.fillColor = UIColor.black
            }
            count = count + 1
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

