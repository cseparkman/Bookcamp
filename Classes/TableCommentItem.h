//
//  TableCommentItemCell.h
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

// UI
#import "Three20UI/TTTableTextItem.h"

// the TTTableTextItem have a property of text;
@interface TableCommentItem : TTTableTextItem {
	NSString* _title;
	NSString* _caption;
	NSNumber* _rating;
	NSDate*   _timestamp;
	NSString* _imageURL;
}
@property (nonatomic, copy)	NSNumber* rating;
@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* caption;
@property (nonatomic, retain) NSDate*   timestamp;
@property (nonatomic, copy)   NSString* imageURL;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL;


+ (id)itemWithTitle:(NSString *)title caption:(NSString *)caption text:(NSString *)text
		 rating:(NSNumber*)rating
		  timestamp:(NSDate *)timestamp URL:(NSString *)URL;
@end

