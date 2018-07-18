//
//  QSTextField.m
//  Taker
//
//  Created by qws on 2018/6/14.
//  Copyright © 2018年 com.pepsin.fork.video_taker. All rights reserved.
//

#import "QSTextField.h"

@implementation QSTextField

//全部关闭
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange {

}


@end
