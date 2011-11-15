//
//  Favorite.h
//  iDev Reader
//
//  Created by Alexander Blunck on 11/15/11.
//  Copyright (c) 2011 Ablfx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * favorite_title;
@property (nonatomic, retain) NSString * favorite_url;
@property (nonatomic, retain) NSDate * favorite_timestamp;

@end
