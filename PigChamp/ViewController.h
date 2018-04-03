//
//  ViewController.h
//  PigChamp
//
//  Created by Venturelabour on 20/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlSettings.h"
#import "CustomIOS7AlertView.h"
#import "CopyPasteTextField.h"
#import "UITextField+PasswordField.h"

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    ControlSettings* sharedSettings;
    UIEdgeInsets contentInsetsScroll;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIScrollView *scrBackground;
@property(nonatomic,strong) IBOutlet UITextField *txtLogintextField;
@property(nonatomic,strong) IBOutlet CopyPasteTextField *txtPasswordtextField;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;
@property(nonatomic,strong)UITextField *activeTextField;
@property(strong, nonatomic)IBOutlet UIPickerView *pickerLanguage;
@property(strong, nonatomic)CustomIOS7AlertView *alertForLanguage;
@property(strong, nonatomic)NSMutableArray *arrLanguage,*arrayEnglish;
@property(strong, nonatomic)NSUserDefaults *pref;

- (IBAction)btnLanguage_tapped:(id)sender;

@end

