//
//  CustomInfoTableCell.swift
//  Exercise
//
//  Created by sriramana on 8/1/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class CustomInfoTableCell : UITableViewCell {
    
    /*
     create label to dispaly title
     */
    private let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    /*
     create label to dispaly descriptoin
     */
    private let descLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    /*
     create Image to dispaly Images from service
     */
    private let itemImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        addSubview(itemImage)
        addSubview(titleLabel)
        addSubview(descLbl)
        
        /*
         adding constraints to elements
         */
        itemImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        titleLabel.anchor(top: topAnchor, left: itemImage.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        descLbl.anchor(top: titleLabel.bottomAnchor, left: itemImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     displaying the data from json
     */
    func renderData(info : DataModel){
        
        if let name = info.title{
            self.titleLabel.text = name
        } else{
            self.titleLabel.text = ""
        }
        if let desc = info.descriptionValue{
            self.descLbl.text = desc
        } else{
            self.descLbl.text = ""
        }
        
        //download image from url
        if let imgUrl = info.imageHref{
            let priorityQ = DispatchQueue.global(qos: .userInteractive)
            priorityQ.async {
                Alamofire.request(imgUrl).responseImage { response in
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        if let image = response.result.value {
                            strongSelf.itemImage.image = image
                            strongSelf.setNeedsLayout()
                            strongSelf.setNeedsDisplay()
                        }else{
                            strongSelf.itemImage.image = UIImage(named: "user_placeholder")
                        }
                    }
                }
            }
        } else{
            // set a placeholder image
            self.itemImage.image = UIImage(named: "user_placeholder")
        }
    }
}
