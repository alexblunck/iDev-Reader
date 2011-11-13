//
//  ArticleViewController.m
//  iDev Reader
//
//  Created by Alexander Blunck on 11/13/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import "ArticleViewController.h"

@implementation ArticleViewController

@synthesize webView, article;


#pragma mark - View lifecycle

-(void) navBack:(id) sender {
    [self.navigationController popViewControllerAnimated:YES ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back_button.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarItemButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = backBarItemButton;
    
    [self.webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bg.png"]]];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:article.article_url]]];
    
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
