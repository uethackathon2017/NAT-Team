//
//  GroupViewModel.swift
//  CrossWorld
//
//  Created by My Macbook Pro on 3/12/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import Foundation

class GroupViewModel{
    
    struct PeopleCellDescription {
        var title: String?
        var image: UIImage?
    }
    
    var listPeople: [PeopleCellDescription] = [
    
        PeopleCellDescription(title: "Phạm Vân Anh‎", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Bé Bủn", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Trinh Phạm", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Clever Tran", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Tran Anh Diep", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Vân Ớt", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Nhượng Duy Đỗ", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Hằng Híp", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Anh Son", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Hoàngg Thanhh Hươngg", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Anh Đức Lê", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Lương Trần Đài Nguyên", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Anh Bin", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Anh Son", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Nhượng Duy Đỗ", image: UIImage().randomAvatar()),
        PeopleCellDescription(title: "Hằng Híp", image: UIImage().randomAvatar())
    ]

}
