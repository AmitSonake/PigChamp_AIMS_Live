//
//  FarmSelectionViewController.h
//  PigChamp
//
//  Created by Venturelabour on 21/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import <Google/Analytics.h>

@class CustomIOS7AlertView;

@interface FarmSelectionViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *strNoInternet,*strSelectFarm,*strOK,*strCancel,*strServerErr,*strUnauthorised,*strSignOff;
    
}

@property(strong, nonatomic)IBOutlet UIPickerView *pickerDropDown;
@property(strong, nonatomic)CustomIOS7AlertView *alertForFarmSelection;
@property (weak, nonatomic) IBOutlet UIButton *btnFarmSelection;
@property(strong, nonatomic)NSMutableArray *arrFarms;
//@property(strong, nonatomic)NSMutableArray *arrlanguage;
@property(strong, nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblFarmSelection;
@property(nonatomic,strong)NSUserDefaults *pref;
@end
