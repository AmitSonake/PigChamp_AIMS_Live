//
//  UITextField+PasswordField.m
//
//
//  Created by IND-VLMAC on 25/11/17.
//

#import "UITextField+PasswordField.h"
@implementation UITextField (PasswordField)
-(void)addPasswordField{
    [self setRightViewMode:UITextFieldViewModeWhileEditing];
    // Create UIButton
    UIButton *showTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showTextBtn.frame = CGRectMake(0, 0, 30, 30);
    [showTextBtn setImage:[UIImage imageNamed:@"eyeoff"] forState:UIControlStateNormal];
    showTextBtn.titleLabel.textColor = [UIColor blackColor];
    [showTextBtn setBackgroundColor:[UIColor clearColor]];
  //  [showTextBtn setTitle:@"S" forState:UIControlStateNormal];
   // showTextBtn.layer.borderColor = [UIColor grayColor].CGColor;
   // showTextBtn.layer.borderWidth = 1;
    //[showTextBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [showTextBtn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:showTextBtn];
    
}
// Start Button clicked
- (IBAction)touchDown:(id)sender {
    self.secureTextEntry = FALSE;
}
//Button released
- (IBAction)touchUpInside:(UIButton*)sender {
    if (self.secureTextEntry) {
       // [sender setTitle:@"H" forState:UIControlStateNormal];
         [sender setImage:[UIImage imageNamed:@"eyeon"] forState:UIControlStateNormal];
        
    }else{
       // [sender setTitle:@"S" forState:UIControlStateNormal];
         [sender setImage:[UIImage imageNamed:@"eyeoff"] forState:UIControlStateNormal];
    }
    
    self.secureTextEntry = !self.secureTextEntry;
}
@end
