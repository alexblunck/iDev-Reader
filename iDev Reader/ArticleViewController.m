//
//  ArticleViewController.m
//  iDev Reader
//
//  Created by Alexander Blunck on 11/13/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import "ArticleViewController.h"
#import "AppDelegate.h"
#import "Favorite.h"
#import "SVProgressHUD.h"

@implementation ArticleViewController

@synthesize webView, article, managedObjectContext;


#pragma mark - View lifecycle


-(BOOL) isValueSaved {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(favorite_url == %@)",self.article.article_url];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        NSLog(@"Error during fetching records | error: %@", error);
    }
    
    if ([mutableFetchResults count] != 0) {
        return YES;
    } else if ([mutableFetchResults count] == 0) {
        return NO;
    }
    
    return NO;
}

-(void) checkValid {
    
    if ([self isValueSaved]) {
        [SVProgressHUD showInView:self.view];
        [SVProgressHUD dismissWithError:@"Already in Favorites!"];
        
    } else {
        [SVProgressHUD showInView:self.view];
        [self addToFavorites];
    }
}

-(void) addToFavorites {
    
    Favorite *fav = (Favorite*) [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext];
    
    [fav setFavorite_title:article.article_title];
    [fav setFavorite_url:article.article_url];
    [fav setFavorite_timestamp:[NSDate date]];
    
    //Error Handeling
    NSError *error;
    if (![managedObjectContext save:&error]) {
        //Do stuff if saving failed
    }
    [SVProgressHUD dismissWithSuccess:@"Successfully Added!"];
    
}


-(void) navBack:(id) sender {
    [self.navigationController popViewControllerAnimated:YES ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    UIImage *buttonImage = [UIImage imageNamed:@"back_button.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarItemButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = backBarItemButton;
    
    
    UIImage *starImage = [UIImage imageNamed:@"star_button.png"];
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    starButton.frame = CGRectMake(0, 0, starImage.size.width, starImage.size.height);
    [starButton setImage:starImage forState:UIControlStateNormal];
    [starButton addTarget:self action:@selector(checkValid) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *starBarItemButton = [[[UIBarButtonItem alloc] initWithCustomView:starButton] autorelease];
    self.navigationItem.rightBarButtonItem = starBarItemButton;
    
    
    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bg.png"]]];
    
    
    NSString *readabilityUrl = [NSString stringWithFormat:@"http://www.readability.com/read?url=%@", article.article_url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:readabilityUrl]]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - WebView Delegate Methods
-(void) webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
