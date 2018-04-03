//
//  BarcodeScannerViewController.h
//  PigChamp
//
//  Created by Venturelabour on 22/12/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>

@protocol barcodeScanner <NSObject>
-(void)scannedBarcode:(NSString*)barcode;
@end

@interface BarcodeScannerViewController : UIViewController
{
   // id<barcodeScanner> delegate;
}

@property(nonatomic,weak)id delegate;

@end
