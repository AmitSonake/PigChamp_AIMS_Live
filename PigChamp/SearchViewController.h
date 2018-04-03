//
//  SearchViewController.h
//  PigChamp
//
//  Created by Venturelabour on 30/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <Google/Analytics.h>
#import "CustomIOS7AlertView.h"
#import "HistorySummaryViewController.h"
#import "BarcodeScannerViewController.h"
#import "SlideNavigationController.h"

@interface SearchViewController : UIViewController<barcodeScanner,SlideNavigationControllerDelegate> {//MenuViewControllerDelegate
    BarcodeScannerViewController *barcodeScannerViewController;
    NSString *strMatchFilter,*strIdentityMsg,*strOK,*strNoInternet,*strPlzWait,*strSowBoarFilter,*strServerErr,*strUnauthorised,*strSignOff;
    NSMutableArray *arrSearch;
    MenuViewController *tlc;
}

#pragma mark - property
@property (weak, nonatomic) IBOutlet UIScrollView *scrSearchBg;
@property (weak, nonatomic) IBOutlet UILabel *lblExactMatch;
@property (weak, nonatomic) IBOutlet UILabel *lblPartialMatch;
@property (weak, nonatomic) IBOutlet UILabel *lblIdentityTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnExactMatch;
@property (weak, nonatomic) IBOutlet UIButton *btnPartialMatch;
@property (weak, nonatomic) IBOutlet UITextField *txtIdentity;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;
@property (weak, nonatomic) IBOutlet UILabel *lblSow;
@property (weak, nonatomic) IBOutlet UILabel *lblBoar;
@property (weak, nonatomic) IBOutlet UIButton *btnSow;
@property (weak, nonatomic) IBOutlet UIButton *btnBoar;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;

#pragma mark - methods
- (IBAction)btnSearch_tapped:(id)sender;
- (IBAction)btnExactNPartialMatch_tapped:(id)sender;

@end
