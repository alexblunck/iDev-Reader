//
//  FavoritesTableViewController.h
//  iDev Reader
//
//  Created by Alexander Blunck on 11/15/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleViewController.h"
#import "Article.h"
#import "Favorite.h"
#import "CustomCell.h"


@interface FavoritesTableViewController : UITableViewController {
    int currentDeleteTag;
}

@property (nonatomic, retain) NSMutableArray* tableDataArray;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
