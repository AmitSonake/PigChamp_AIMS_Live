//
//  ReportsInput.h
//  PigChamp
//
//  Created by Venturelabour on 05/02/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstReportViewController.h"
#import "CustomIOS7AlertView.h"
#import "BarcodeScannerViewController.h"
#import "SlideNavigationController.h"

@interface ReportsInput : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,barcodeScanner,SlideNavigationControllerDelegate>{
    NSString *strScan,*strYes,*strNo,*strOk,*strCancel,*strWait,*strNoInternet,*strIdentity,*strUnauthorised,*strServerErr;
    BarcodeScannerViewController *barcodeScannerViewController;
    MenuViewController *tlc;
}

#pragma mark - Property
@property (weak, nonatomic) IBOutlet UIButton *btnRunReport;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITableView *tblReportsDynamic;
@property(nonatomic,strong)NSMutableArray *arrDropDownReport;
@property(nonatomic,strong)NSMutableArray *arrDynamicReport;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UIView *vwFooter;
@property(nonatomic,strong) NSMutableDictionary *dictDynamicReport,*dictJsonReport;
@property(nonatomic,strong)IBOutlet UIDatePicker *dtPickerReport;
@property(nonatomic,strong)NSString *strEvent;
@property (strong, nonatomic) CustomIOS7AlertView *alertForPickUpDateReport;
@property(strong, nonatomic)IBOutlet UIPickerView *pickerDropDownReport;
@property (strong, nonatomic) CustomIOS7AlertView *alertForDropDown;
@property(nonatomic,strong)UIView *activeTextField;
@property (weak, nonatomic) NSString *strSubMenu;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;
@property(nonatomic,strong)NSString *strActiveAnimalReportType;
@property (weak, nonatomic) NSString *strDateFormat;

#pragma mark - Methods
- (IBAction)btnDate_tapped:(id)sender;
- (IBAction)btnDropDown_tapped:(id)sender;

@end
