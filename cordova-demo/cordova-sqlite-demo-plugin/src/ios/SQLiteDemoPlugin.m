#import <Cordova/CDVPlugin.h>

#import "SQLiteBatchCore.h"

@interface SQLiteDemoPlugin : CDVPlugin

- (void) openDatabaseConnection: (CDVInvokedUrlCommand *) commandInfo;

- (void) executeBatch: (CDVInvokedUrlCommand *) commandInfo;

@end

@implementation SQLiteDemoPlugin

- (void) openDatabaseConnection: (CDVInvokedUrlCommand *) commandInfo
{
  NSArray * _args = commandInfo.arguments;

  NSDictionary * options = (NSDictionary *)[_args objectAtIndex: 0];

  NSString * filename = (NSString *)[options valueForKey: @"path"];

  const int flags = [(NSNumber *)[options valueForKey: @"flags"] intValue];

  [SQLiteBatchCore openBatchConnection: filename
                                 flags: flags
                               success: ^(int connection_id) {
    CDVPluginResult * openResult =
      [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                           messageAsInt: connection_id];

    [self.commandDelegate sendPluginResult: openResult
                                callbackId: commandInfo.callbackId];
  }
  error: ^ (NSString * message) {
    CDVPluginResult * openErrorResult =
      [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                        messageAsString: message];
    [self.commandDelegate sendPluginResult: openErrorResult
                                callbackId: commandInfo.callbackId];
  }];
}

- (void) executeBatch: (CDVInvokedUrlCommand *) commandInfo
{
  NSArray * _args = commandInfo.arguments;

  const int connection_id = [(NSNumber *)[_args objectAtIndex: 0] intValue];

  NSArray * data = [_args objectAtIndex: 1];

  [SQLiteBatchCore executeBatch: connection_id
                           data: data
                        success: ^(NSArray * results) {
    CDVPluginResult * batchResult =
      [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                         messageAsArray: results];

    [self.commandDelegate sendPluginResult: batchResult
                                callbackId: commandInfo.callbackId];
  }
  error: ^ (NSString * message) {
    CDVPluginResult * batchErrorResult =
      [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                        messageAsString: message];
    [self.commandDelegate sendPluginResult: batchErrorResult
                                callbackId: commandInfo.callbackId];
  }];
}

@end
