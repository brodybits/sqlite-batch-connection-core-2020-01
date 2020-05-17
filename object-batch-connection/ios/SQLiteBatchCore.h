#import <Foundation/Foundation.h>

@interface SQLiteBatchCore : NSObject

+ (void) initialize;

+ (void) openBatchConnection: (NSString *) filename
                       flags: (int) flags
                     success: (void (^)(int)) successCallback
                       error: (void (^)(NSString *)) errorCallback;

+ (void) executeBatch: (int) connection_id
                 data: (NSArray *) data
              success: (void (^)(NSArray *)) successCallback
                error: (void (^)(NSString *)) errorCallback;

@end
