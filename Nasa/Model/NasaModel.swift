//
//  NasaModel.swift
//  Nasa
//
//  Created by Ozan Salman on 24.07.2022.
//

import Foundation

// MARK: - NasaModel
struct NasaModel: Codable {
    let photos: [Photo]


    // MARK: - Photo
    struct Photo: Codable {
        let id, sol: Int
        let camera: Camera
        let imgSrc: String
        let earthDate: String
        let rover: Rover

        enum CodingKeys: String, CodingKey {
            case id, sol, camera
            case imgSrc = "img_src"
            case earthDate = "earth_date"
            case rover
        }
    }

    // MARK: - Camera
    struct Camera: Codable {
        let id: Int
        let name: String
        let roverID: Int
        let fullName: String

        enum CodingKeys: String, CodingKey {
            case id, name
            case roverID = "rover_id"
            case fullName = "full_name"
        }
    }


    // MARK: - Rover
    struct Rover: Codable {
        let id: Int
        let name: String
        let landingDate, launchDate: String
        let status: String

        enum CodingKeys: String, CodingKey {
            case id, name
            case landingDate = "landing_date"
            case launchDate = "launch_date"
            case status
        }
    }

}
