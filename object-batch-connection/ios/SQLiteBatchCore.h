#import <Foundation/Foundation.h>

@interface SQLiteBatchCore : NSObject

+ (void) initialize;

+ (void) openDatabaseConnection: (NSArray *) arguments
                        success: (void (^)(int)) successCallback
                          error: (void (^)(NSString *)) errorCallback;

+ (void) executeBatch: (NSArray *) arguments
              success: (void (^)(NSArray *)) successCallback;

@end
