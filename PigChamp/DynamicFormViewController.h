//
//  DynamicFormViewController.h
//  PigChamp
//
//  Created by Venturelabour on 26/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "BarcodeScannerViewController.h"
#import <Google/Analytics.h>
#import "SlideNavigationController.h"
#import "MenuViewController.h"

//#import "APParser.h"
@class CustomIOS7AlertView;
@class SettingsViewController;
@class DropDown;

@interface DynamicFormViewController : UIViewController<barcodeScanner,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,SlideNavigationControllerDelegate> {
    SettingsViewController *settingsViewController;
    BarcodeScannerViewController *barcodeScannerViewController;
    NSString *strScan,*strYes,*strNo,*strOk,*strCancel,*strWait,*strNoInternet,*strStillLive,*strClear,*strServerErr,*strUnauthorised,*strSignOff;
    NSString *strSplitSex,*strSplitWex;
    MenuViewController *tlc;
}

#pragma mark - Property
@property (weak, nonatomic) IBOutlet UIView *vwcontainer;
@property (weak, nonatomic) NSString *strDateFormat;
@property (weak, nonatomic) IBOutlet UIView *vwFooter;
@property (weak, nonatomic) IBOutlet UIButton *btnDropDown;
@property(nonatomic,strong)UIView *activeTextField;
@property (weak, nonatomic) IBOutlet UITableView *tblDynamic;
@property(nonatomic,strong)IBOutlet UIDatePicker *dtPicker;
@property(strong, nonatomic)IBOutlet UIPickerView *pickerDropDown;
@property(nonatomic,strong)NSMutableArray *arrDropDown;
@property(nonatomic,strong)NSMutableArray *arrDynamic;
@property(nonatomic,strong) NSMutableDictionary *dictDynamic,*dictJson,*dictReload;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedValue;
@property(nonatomic,strong)NSString *strEventCode;
@property(nonatomic,strong)NSString *strTitle;
@property(nonatomic,strong)NSString *strTitleInt;
@property(nonatomic,strong)NSString *lblTitle;
@property (strong, nonatomic) CustomIOS7AlertView *alertForOrgName;
@property (strong, nonatomic) CustomIOS7AlertView *alertForPickUpDate;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property(nonatomic,strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

#pragma mark method
-(void)callEdit;

@end
