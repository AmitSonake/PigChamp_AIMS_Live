//
//  CopyPasteTextField.m
//  AgCareers
//
//  Created by Unicorn on 28/10/15.
//  Copyright © 2015 VLWebtek. All rights reserved.
//

#import "CopyPasteTextField.h"

@implementation CopyPasteTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
