//
//  MasterTableViewController.m
//  iDev Reader
//
//  Created by Alexander Blunck on 11/13/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import "MasterTableViewController.h"


@implementation MasterTableViewController

@synthesize tableDataArray;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.471 alpha:1.000]];
    
    //Reload Button
    UIImage *buttonImage = [UIImage imageNamed:@"reload_button.png"];
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    [reloadButton setImage:buttonImage forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(reloadRSS) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *reloadBarItemButton = [[[UIBarButtonItem alloc] initWithCustomView:reloadButton] autorelease];

    self.navigationItem.rightBarButtonItem = reloadBarItemButton;
    
    
    
    self.tableDataArray = [NSMutableArray array];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [self loadRSS];
}

-(void) loadRSS {
    NSString *requestUrl = @"http://appserver.ablfx.com/idevreader/rssparser.php";
    [SVHTTPRequest GET:requestUrl parameters:nil completion:^(NSObject *response) {
        id objects = [response valueForKey:@"articles"];
        for (id object in objects) {
            Article *article = [[Article alloc] init];

            article.article_title = [object valueForKey:@"article_title"];;
            article.article_url = [object valueForKey:@"article_url"];
            [self.tableDataArray addObject:article];
        }
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [SVProgressHUD dismiss];
        
    }];
}

-(void) reloadRSS {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.tableDataArray removeAllObjects];
    [self loadRSS];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //CustomCell Setup//////////////////////////////////////////////////////////////////////////////////
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[CustomCell class]]) {
                cell = (CustomCell*)currentObject;
                break;}}
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [cell.deleteButton setHidden:YES];
    
    Article *article = [self.tableDataArray objectAtIndex:indexPath.row];
    [[cell titleLabel] setText:article.article_title];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Article *article = [self.tableDataArray objectAtIndex:indexPath.row];
    ArticleViewController *viewController = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
    viewController.article = article;
    [self.navigationController pushViewController:viewController animated:YES];
}










@end
