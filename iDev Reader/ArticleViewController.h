//
//  ArticleViewController.h
//  iDev Reader
//
//  Created by Alexander Blunck on 11/13/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "SVProgressHUD.h"

@interface ArticleViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) Article *article;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
