//
//  FirstReportViewController.h
//  PigChamp
//
//  Created by Venturelabour on 04/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "ControlSettings.h"
#import "CoreDataHandler.h"
#import <Google/Analytics.h>
#import "SlideNavigationController.h"
#import "MenuViewController.h"

//#import "BarcodeScannerViewController.h"

@interface FirstReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SlideNavigationControllerDelegate>{
    NSMutableArray *arrReports;    MenuViewController *tlc;

    NSString *strPlzWait,*strNoInternet,*strOk,*strNodataFound,*strServerErr,*strUnauthorised,*strSignOff;
}

#pragma mark - view life cycle
@property (weak, nonatomic) NSString *strDateFormat;
@property(nonatomic,strong)IBOutlet UITableView *tblFirst;
@property(nonatomic,strong)NSMutableDictionary *dictHeaders;
@property(nonatomic,strong)NSString *strEvnt;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property(strong, nonatomic)IBOutlet UIPickerView *pickerSortType;
@property (strong, nonatomic) CustomIOS7AlertView *alertForSortType;
@property(nonatomic,strong)NSMutableArray *arrSortType;
@property(nonatomic,strong)NSString *strPlzWait,*strNoInternet,*strOk;
@property(nonatomic,strong)NSMutableArray *arrReports;
@property(nonatomic,strong)NSString *strTitle,*strActiveAnimalreportType;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
