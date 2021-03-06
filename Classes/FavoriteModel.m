//
//  FavoriteModel.m
//
// Created by lin waiwai(jiansihun@foxmail.com) on 1/19/11.
// Copyright 2011 __waiwai__. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "FavoriteModel.h"
#import "Book.h"

@implementation FavoriteModel

@synthesize books = _books;
@synthesize loadedTime = _loadedTime;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize count;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)bookContextDidSave:(NSNotification*)saveNotification {
	offset += 1;	
}

-(id)init{
	if (self = [super init]) {
		offset = 0;
		count = 0;
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(bookContextDidSave:) name:FavoritedObjectContextDidSaveNotification object:nil];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc removeObserver:self name:FavoritedObjectContextDidSaveNotification object:nil];
	TT_RELEASE_SAFELY (_books);
	TT_RELEASE_SAFELY (_loadedTime);
	TT_RELEASE_SAFELY (_managedObjectContext);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSMutableArray *) books{
	if (!_books) {
		_books = [[NSMutableArray alloc] init];
	}
	return _books;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
	return !!_loadedTime;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext ) {
		ModelLocator *locator = [ModelLocator sharedInstance];
		NSPersistentStoreCoordinator *coordinator = [locator persistentStoreCoordinator];
		if (coordinator != nil) {
			_managedObjectContext = [[NSManagedObjectContext alloc] init];
			[_managedObjectContext setPersistentStoreCoordinator: coordinator];
		}
    }
    return _managedObjectContext;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more{
	if (!self.isLoading) {	
		NSManagedObjectContext *moc = [self managedObjectContext];
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:[self managedObjectContext]];
		[fetchRequest setEntity:entity];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"favorited = %@",  [NSNumber numberWithBool: YES]]];
		NSSortDescriptor *savedDateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"savedDate" ascending:NO] autorelease];
		NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:savedDateDescriptor, nil] autorelease];
		[fetchRequest setSortDescriptors:sortDescriptors];


		
	
		NSError *error = nil;
		count = [moc countForFetchRequest: fetchRequest error: &error];
		
		if (error) {
			BCNSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		} else {
			if (count != NSNotFound){
				
			} else {
				[self didFinishLoad];
				return ;
			}
		}
		 
		NSUInteger limit = 10;
		[fetchRequest setFetchOffset:offset]; 
		[fetchRequest setFetchLimit:limit];
		offset += limit;
		NSArray *aBooks = [moc executeFetchRequest:fetchRequest error:&error];
		if (aBooks) {
			for (Book *book in aBooks) {
				[self.books addObject:book];
			}
		} else {
			if (error) {
				TTDERROR(@"Unresolved error %@, %@", error, [error userInfo]);
				return;
			}
		}
	}
	[self didFinishLoad];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)didFinishLoad{
	TT_RELEASE_SAFELY (_loadedTime);
	_loadedTime = [[NSDate date] retain];
	[super didFinishLoad];
}

@end
