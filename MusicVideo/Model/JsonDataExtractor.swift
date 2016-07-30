//
//  JsonDataExtractor.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 30/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

class JsonDataExtractor {
    
    static func extractVideoDataFromJson(videoDataObject: AnyObject) -> [Video] {
        guard let videoData = videoDataObject as? JSONDictionary else {
            return [Video]()
        }
        
        var videos = [Video]()
        if let feeds = videoData["feed"] as? JSONDictionary, entries = feeds["entry"] as? JSONArray {
            for (index, data) in entries.enumerate() {
                let vName: String
                let vRights: String
                let vPrice: String
                let vImageUrl: String
                let vArtist: String
                let vVideoUrl: String
                let vImId: String
                let vGenre: String
                let vLinkToiTunes: String
                let vReleaseDate: String
                
                // Video name
                if let imName = data["im:name"] as? JSONDictionary,
                    label = imName["label"] as? String {
                    vName = label
                } else {
                    vName = ""
                }
                
                // The Studio Name
                if let rightsDict = data["rights"] as? JSONDictionary,
                    label = rightsDict["label"] as? String {
                    vRights = label
                } else {
                    vRights = ""
                }
                
                // Price of Video
                if let imPrice = data["im:price"] as? JSONDictionary,
                    label = imPrice["label"] as? String {
                    vPrice = label
                } else {
                    vPrice = ""
                }
                
                // The Video Image
                if let imImage = data["im:image"] as? JSONArray,
                    image = imImage[2] as? JSONDictionary,
                    label = image["label"] as? String {
                    vImageUrl = label.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
                } else {
                    vImageUrl = ""
                }
                
                // The Artist Name
                if let imArtist = data["im:artist"] as? JSONDictionary,
                    label = imArtist["label"] as? String {
                    vArtist = label
                } else {
                    vArtist = ""
                }
                
                //Video Url
                if let link = data["link"] as? JSONArray,
                    vUrl = link[1] as? JSONDictionary,
                    attributes = vUrl["attributes"] as? JSONDictionary,
                    href = attributes["href"] as? String {
                    vVideoUrl = href
                } else {
                    vVideoUrl = ""
                }
                
                // The Artist ID for iTunes Search API
                if let id = data["id"] as? JSONDictionary,
                    attributes = id["attributes"] as? JSONDictionary,
                    imId = attributes["im:id"] as? String {
                    vImId = imId
                } else {
                    vImId = ""
                }
                
                // The Genre
                if let category = data["category"] as? JSONDictionary,
                    attributes = category["attributes"] as? JSONDictionary,
                    term = attributes["term"] as? String {
                    vGenre = term
                } else {
                    vGenre = ""
                }
                
                // Video Link to iTunes
                if let id = data["id"] as? JSONDictionary,
                    label = id["label"] as? String {
                    vLinkToiTunes = label
                } else {
                    vLinkToiTunes = ""
                }
                
                // The Release Date
                if let imReleaseDate = data["im:releaseDate"] as? JSONDictionary,
                    attributes = imReleaseDate["attributes"] as? JSONDictionary,
                    label = attributes["label"] as? String {
                    vReleaseDate = label
                } else {
                    vReleaseDate = ""
                }
                
                let currentVideo = Video(vRank: index + 1, vName: vName, vRights: vRights,
                                         vPrice: vPrice, vImageUrl: vImageUrl, vArtist: vArtist,
                                         vVideoUrl: vVideoUrl, vImId: vImId, vGenre: vGenre,
                                         vLinkToiTunes: vLinkToiTunes, vReleaseDate: vReleaseDate)
                videos.append(currentVideo)
            }
        }
        return videos
    }
}