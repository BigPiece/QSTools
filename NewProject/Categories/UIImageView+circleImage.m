//
//  UIImageView+circleImage.m
//  QSKuRun
//
//  Created by tareena on 16/5/17.
//  Copyright © 2016年 qws. All rights reserved.
//

#import "UIImageView+circleImage.h"

@implementation UIImageView (circleImage)
- (void)setCircleLayer{
    //设置原型头像
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
}
@end
