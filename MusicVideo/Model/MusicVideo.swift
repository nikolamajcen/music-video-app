//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 17/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

class Videos {
    
    // Data encapsulation
    private var _vName:String
    private var _vRights:String
    private var _vPrice:String
    private var _vImageUrl:String
    private var _vArtist:String
    private var _vVideoUrl:String
    private var _vImid:String
    private var _vGenre:String
    private var _vLinkToiTunes:String
    private var _vReleaseDte:String
    
    // This variable gets created from the UI
    var vImageData:NSData?
    
    //Make a getter
    
    var vName: String {
        return _vName
    }
    
    var vRights: String {
        return _vRights
    }
    
    var vPrice: String {
        return _vPrice
    }
    
    var vImageUrl: String {
        return _vImageUrl
    }
    
    var vArtist: String {
        return _vArtist
    }
    
    var vVideoUrl: String {
        return _vVideoUrl
    }
    
    var vImid:String {
        return _vImid
    }
    
    var vGenre:String {
        return _vGenre
    }
    
    var vLinkToiTunes:String {
        return _vLinkToiTunes
    }
    
    var vReleaseDte:String {
        return _vReleaseDte
    }
    
    
    init(data: JSONDictionary) {
        
        // Video name
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
            _vName = vName
        } else {
            _vName = ""
        }
        
        // The Studio Name
        if let rights = data["rights"] as? JSONDictionary,
            vRights = rights["label"] as? String {
            _vRights = vRights
        } else {
            _vRights = ""
        }
        
        // Price of Video
        if let price = data["im:price"] as? JSONDictionary,
            vPrice = price["label"] as? String {
            _vPrice = vPrice
        } else {
            _vPrice = ""
        }
        
        // The Video Image
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
            _vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        } else {
            _vImageUrl = ""
        }
        
        // The Artist Name
        if let artist = data["im:artist"] as? JSONDictionary,
            vArtist = artist["label"] as? String {
            _vArtist = vArtist
        } else {
            _vArtist = ""
        }
        
        //Video Url
        if let video = data["link"] as? JSONArray,
            vUrl = video[1] as? JSONDictionary,
            vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
            _vVideoUrl = vVideoUrl
        } else {
            _vVideoUrl = ""
        }
        
        // The Artist ID for iTunes Search API
        if let imid = data["id"] as? JSONDictionary,
            vid = imid["attributes"] as? JSONDictionary,
            vImid = vid["im:id"] as? String {
            _vImid = vImid
        } else {
            _vImid = ""
        }
        
        // The Genre
        if let genre = data["category"] as? JSONDictionary,
            rel2 = genre["attributes"] as? JSONDictionary,
            vGenre = rel2["term"] as? String {
            _vGenre = vGenre
        } else {
            _vGenre = ""
        }
        
        // Video Link to iTunes
        if let release2 = data["id"] as? JSONDictionary,
            vLinkToiTunes = release2["label"] as? String {
            _vLinkToiTunes = vLinkToiTunes
        } else {
            _vLinkToiTunes = ""
        }
        
        // The Release Date
        if let release2 = data["im:releaseDate"] as? JSONDictionary,
            rel2 = release2["attributes"] as? JSONDictionary,
            vReleaseDte = rel2["label"] as? String {
            _vReleaseDte = vReleaseDte
        } else {
            _vReleaseDte = ""
        }
    }
}