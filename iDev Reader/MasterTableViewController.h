//
//  MasterTableViewController.h
//  iDev Reader
//
//  Created by Alexander Blunck on 11/13/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SVHTTPRequest.h"
#import "SVProgressHUD.h"
#import "SVWebViewController.h"
#import "Article.h"
#import "CustomCell.h"
#import "ArticleViewController.h"

@interface MasterTableViewController : UITableViewController

-(void) loadRSS;

@property (nonatomic, retain) NSMutableArray *tableDataArray;

@end
