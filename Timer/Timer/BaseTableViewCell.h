//
//  BaseTableViewCell.h
//  Timer
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface BaseTableViewCell : UITableViewCell

- (void)setDataWithModel:(BaseModel *)model;

@end
