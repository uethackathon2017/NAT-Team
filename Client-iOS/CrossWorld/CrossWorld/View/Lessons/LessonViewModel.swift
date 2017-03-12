//
//  LessonViewModel.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/11/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation

class LessonViewModel {
    struct CellDescription {
        var title: String = ""
        var nameLesson: String = ""
        var author: String = ""
        var imageUrl: String = ""
        var imageAuthor: String = ""
        var shortDes: String = ""
        var isUnLock = true
    }
    
    var listCell: [CellDescription] = [
        CellDescription(title: "English in a Minute", nameLesson: "Keep You on Your Toes", author: "VOA News", imageUrl: "les1", imageAuthor: "", shortDes: "Is it a good or bad thing if something \"keeps you on your toes?\" Watch this week's English in a Minute to find out! Then, practice using this expression in the comments below.", isUnLock: true),
        CellDescription(title: "Everyday Grammar", nameLesson: "Determiners", author: "VOA News", imageUrl: "les2", imageAuthor: "", shortDes: "i'd much be happy if give me some english structures on my fb then well i can be gd at.am cleverboy joshua", isUnLock: false),
        CellDescription(title: "English in a Minute", nameLesson: "On a Roll", author: "VOA News", imageUrl: "les3", imageAuthor: "", shortDes: "What does it mean to be \"on a roll?\" Watch this week's EIM to find out!", isUnLock: true),
        CellDescription(title: "Everyday Grammar", nameLesson: "Parallelism", author: "VOA News", imageUrl: "les", imageAuthor: "", shortDes: "You can fool all the people some of the time, and some of the people all the time, but you cannot fool all the people all the time.", isUnLock: true),
        CellDescription(title: "News Words", nameLesson: "Hybrid", author: "VOA News", imageUrl: "les4", imageAuthor: "", shortDes: "Do you know what a hybrid is? Learn with News Words.", isUnLock: true),
        CellDescription(title: "English @ the Movies", nameLesson: "'Write Your Own Rules'", author: "VOA News", imageUrl: "les5", imageAuthor: "", shortDes: "Our saying today on English @ the Movies is \"write your own rules\" from the movie \"La La Land.\" It is about a woman and a man who fall in love, while trying to make it big in the movie and music worlds. Do you know what \"write your own rules\" means? Watch our video and then take the quiz!", isUnLock: false),
        CellDescription(title: "Peter Ripken", nameLesson: "A Life in Literature", author: "VOA News", imageUrl: "les6", imageAuthor: "", shortDes: "Peter Ripken loves literature. The man from Frankfurt, Germany reads books by writers all over the world. And he learned years ago that not all nations permit writers to express themselves freely. In fact, free expression can be quite dangerous in many places.", isUnLock: true),
    ]
}

extension UIImage{
    func randomAvatar() -> UIImage?{
        let randomNum = arc4random_uniform(19) + 1
        let fullname = "avt\(randomNum)"
        
        return UIImage(named: fullname)
    }
}
