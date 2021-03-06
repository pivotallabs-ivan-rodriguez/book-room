//
//  BRCalendarResourcesOperation.m
//  Book Room
//
//  Created by DX169-XL on 2014-05-06.
//  Copyright (c) 2014 Pivotal Labs. All rights reserved.
//

#import "BRCalendarResourcesOperation.h"

@implementation BRCalendarResourcesOperation

- (NSString *)path {
    return [NSString stringWithFormat:@"resource/2.0/%@/",kGoogleAppsDomain];
}

- (NSMutableDictionary *)queryParameters {
    return nil;
}

- (void)success {
    self.state = HTTPCRUDOperationSuccessfulState;
}

- (void)failure:(NSError *)error {
    self.state = HTTPCRUDOperationFailState;

    NSLog(@"Calendar Resources Operation failed %@ (%@)",self.returnedObject,error);
}

- (HTTPCRUDOperationType)type {
    return kHTTPCRUDOperationCalendar;
}

@end
