//
//  SettingsViewController.m
//  PigChamp
//
//  Created by Venturelabour on 27/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "SettingsViewController.h"

BOOL isBarCode = NO;
BOOL isRFID = NO;

@interface SettingsViewController ()
@end

@implementation SettingsViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Settings"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FromSetting"];

        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSString *strRFID = [pref valueForKey:@"isRFID"];
        NSString *strBar = [pref valueForKey:@"isBarcode"];
        
        if ([strBar isEqualToString:@"1"])
        {
            isBarCode = YES;
            [self.btnBarCode setBackgroundImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
            self.btnBarCode.layer.borderColor =[[UIColor clearColor] CGColor];
        }
        else
        {
            self.btnBarCode.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
        }
        
        if ([strRFID isEqualToString:@"1"])
        {
            isRFID = YES;
            [self.btnRFID setBackgroundImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
            self.btnRFID.layer.borderColor =[[UIColor clearColor] CGColor];
        }
        else
        {
            self.btnRFID.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewDidLoad=%@",exception.description);
    }
}

- (IBAction)btnOk_tapped:(id)sender {
    @try {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];

        if (isBarCode)
        {
            [pref setValue:@"1" forKey:@"isBarcode"];
        }
        else
        {
            [pref setValue:@"0" forKey:@"isBarcode"];
        }
        
        if (isRFID)
        {
            [pref setValue:@"1" forKey:@"isRFID"];
        }
        else
        {
            [pref setValue:@"0" forKey:@"isRFID"];
        }
        
        if (!isRFID && !isBarCode)
        {
            [pref setValue:@"1" forKey:@"isBarcode"];
            [pref setValue:@"0" forKey:@"isRFID"];
        }
        
      [pref synchronize];
     [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnOk_tapped=%@",exception.description);
    }
}

- (IBAction)btnCancel_tapped:(id)sender {
    @try {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnCancel_tapped=%@",exception.description);
    }
}

- (IBAction)btnSelctedReader_tapped:(UIButton*)sender {
    @try {
        
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        
        if (sender.tag==2)
        {
            if (!isBarCode)
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
                self.btnBarCode.layer.borderColor =[[UIColor clearColor] CGColor];
            }
            else
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
                self.btnBarCode.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
            }
            
            isBarCode=!isBarCode;
        }
        else
        {
            if (!isRFID)
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
                self.btnRFID.layer.borderColor =[[UIColor clearColor] CGColor];
            }
            else
            {
                [sender setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
                self.btnRFID.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
            }
            
            isRFID=!isRFID;
        }
        
        [pref synchronize];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnSelctedReader_tapped=%@",exception.description);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
