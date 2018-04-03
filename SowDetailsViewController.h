//
//  SowDetailsViewController.h
//  PigChamp
//
//  Created by Venturelabour on 11/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarcodeScannerViewController.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@interface SowDetailsViewController : UIViewController<barcodeScanner,SlideNavigationControllerDelegate> {
    BarcodeScannerViewController *barcodeScannerViewController;
    NSString *strRptType,*strValidationMsg,*strOK,*strUnauthorised,*strServerErr;
    MenuViewController *tlc;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrSowBg;
@property (weak, nonatomic) IBOutlet UILabel *lblSimple;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailed;
@property (weak, nonatomic) IBOutlet UILabel *lblIdentityTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSimple;
@property (weak, nonatomic) IBOutlet UIButton *btnDetailed;
@property (weak, nonatomic) IBOutlet UITextField *txtIdentity;
@property (weak, nonatomic) IBOutlet UIButton *btnRunReport;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
