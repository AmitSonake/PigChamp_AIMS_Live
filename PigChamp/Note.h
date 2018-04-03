//
//  Note.h
//  PigChamp
//
//  Created by Venturelabour on 12/10/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Note : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *lblDetail;
@property(nonatomic,strong)IBOutlet UITextField *txtDetail;
@end
