// 
//  Session.m
//  Thyme
//
//  Created by João Moreno on 6/4/10.
//

#import "Session.h"
#import "ThymeAppDelegate.h"

#define AppDelegate ((ThymeAppDelegate*) [[NSApplication sharedApplication] delegate])

@interface Session(hidden)
- (NSString*)formattedDate;
@end


@implementation Session 

@dynamic hours;
@dynamic minutes;
@dynamic seconds;
@dynamic date;
@dynamic taskName;

- (NSString*)formatDate
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy 'at' HH:mm"];
    }
    
    return [dateFormatter stringFromDate:self.date];
}

+ (NSArray*)allSessions
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[[AppDelegate.managedObjectModel entitiesByName] valueForKey:@"Session"]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                   ascending:YES
                                                                  comparator:^NSComparisonResult(NSDate* a, NSDate* b) {
                                                                      return [b compare:a];
                                                                  }];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSArray *result = [AppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    [request release];
    
    return result;
}

+ (NSArray*)allSessionsAsDictionaries
{
    NSArray *sessions = [Session allSessions];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:sessions.count];
    
    [sessions enumerateObjectsUsingBlock:^(Session *session, NSUInteger index, BOOL *stop) {
        [result addObject:[session asDictionary]];
    }];
    
    return result;
}

+ (Session*)sessionWithSeconds:(NSInteger)_seconds minutes:(NSInteger)_minutes hours:(NSInteger)_hours
{
    Session* session = (Session*) [NSEntityDescription insertNewObjectForEntityForName:@"Session" 
                                                     inManagedObjectContext:AppDelegate.managedObjectContext];

    session.hours = [NSNumber numberWithInt:_hours];
    session.minutes = [NSNumber numberWithInt:_minutes];
    session.seconds = [NSNumber numberWithInt:_seconds];
    session.date = [NSDate date];
    
    return session;
}

- (NSString*)timeStringRepresentation
{
    if ([self.hours intValue] > 0)
        return [NSString stringWithFormat:@"%02d:%02d:%02d", [self.hours intValue], [self.minutes intValue], [self.seconds intValue]];
    else
        return [NSString stringWithFormat:@"%02d:%02d", [self.minutes intValue], [self.seconds intValue]];
}

- (NSString*)stringRepresentation
{
    if (self.taskName == nil || [self.taskName isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@ - %@", [self timeStringRepresentation], [self formatDate]];
    }
    
    return [NSString stringWithFormat:@"%@ - %@ - %@", [self timeStringRepresentation], [self formatDate], self.taskName];
}

- (NSDictionary*)asDictionary
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSNumber *duration = [NSNumber numberWithUnsignedInteger:[self.seconds unsignedIntegerValue]
        + (([self.minutes unsignedIntegerValue] + ([self.hours unsignedIntegerValue] * 60)) * 60)];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [dateFormatter stringFromDate:self.date], @"date",
                            duration, @"duration",
                            nil];

    if (self.taskName) {
        [result setObject:self.taskName forKey:@"taskName"];
    }
    
    [dateFormatter release];
    
    return result;
}

@end
