//
//  FavoritesTableViewController.m
//  iDev Reader
//
//  Created by Alexander Blunck on 11/15/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "AppDelegate.h"

@implementation FavoritesTableViewController

@synthesize tableDataArray, managedObjectContext;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.408 green:0.478 blue:0.471 alpha:1.000]];
}

-(void) reloadFavorites {
    //Load favs from DB
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext];
    
    //Setup fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    //Define Sorting
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"favorite_timestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    //Fetch Records & Error Handeling
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        //Handle the Error
    }
    
    //Save fetched Data to array
    [self setTableDataArray:mutableFetchResults];
    [mutableFetchResults release];
    [request release];
    
    [self.tableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated {
    [self reloadFavorites];
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
    
    [cell.deleteButton addTarget:self action:@selector(confirmDelete:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton setTag:indexPath.row];
    
    Favorite *favorite = [self.tableDataArray objectAtIndex:indexPath.row];
    [[cell titleLabel] setText:favorite.favorite_title];
    
    return cell;
}

-(void) confirmDelete:(id)sender {
    currentDeleteTag = ((UIControl*)sender).tag ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hi There" message:@"Delete from Favorites?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { //Cancel Button
    }
    
    if (buttonIndex == 1) { //Delete Button
        [self deleteFavorite:self];
    }
}

-(void) deleteFavorite: (id) sender {
    //int selectedIndex = ((UIControl*)sender).tag ;
    //NSLog(@"selected: %i", currentDeleteTag);
    Favorite *fav = [self.tableDataArray objectAtIndex:currentDeleteTag];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(favorite_url == %@)", fav.favorite_url];
    
    [fetch setPredicate:predicate];
    
    
    NSError * error = nil;
    NSArray * objects = [managedObjectContext executeFetchRequest:fetch error:&error];
    [fetch release];
    for (NSManagedObject * object in objects) {
        [managedObjectContext deleteObject:object];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];

    [self reloadFavorites];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Favorite *favorite = [self.tableDataArray objectAtIndex:indexPath.row];
    
    Article *article = [[Article alloc] init];
    article.article_title = favorite.favorite_title;
    article.article_url = favorite.favorite_url;
    
    ArticleViewController *viewController = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
    viewController.article = article;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
