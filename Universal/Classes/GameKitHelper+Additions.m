//
//  GameKitHelper+Additions.m
//  Removr
//
//  Created by Mike Cohen on 2/5/11.
//  Copyright 2011 MC Development. All rights reserved.
//

#import "GameKitHelper+Additions.h"


@implementation GameKitHelper (Additions)

static NSMutableDictionary *achievementDescriptions = nil;

-(void) loadAchievementDescriptions
{
	if (isGameCenterAvailable == NO)
		return;
    
	[GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray* loadedAchievements, NSError* error)
     {
         [self setLastError:error];
		 
         if (achievementDescriptions == nil)
         {
             achievementDescriptions = [[NSMutableDictionary alloc] init];
         }
         else
         {
             [achievementDescriptions removeAllObjects];
         }
         
         for (GKAchievementDescription* achievement in loadedAchievements)
         {
             [achievementDescriptions setObject:achievement forKey:achievement.identifier];
         }
		 
         if ([delegate respondsToSelector: @selector(onAchievementDescriptionsLoaded:)]) {
             [delegate onAchievementDescriptionsLoaded:achievementDescriptions];
         }
     }];
}

- (GKAchievementDescription*)getAchievementDescription:(NSString*)ident
{
	if (isGameCenterAvailable == NO)
		return nil;
    
	GKAchievementDescription* desc = [achievementDescriptions objectForKey:ident];
		
	return [[desc retain] autorelease];
}

@end
