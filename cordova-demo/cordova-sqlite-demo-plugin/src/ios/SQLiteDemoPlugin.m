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

  const int dbid = [SQLiteBatchCore openBatchConnection: filename flags: flags];

  if (dbid < 0) {
    CDVPluginResult * openErrorResult =
      [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                        messageAsString: @"open error"];
    [self.commandDelegate sendPluginResult: openErrorResult
                                callbackId: commandInfo.callbackId];
  } else {
    CDVPluginResult * openResult =
      [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                           messageAsInt: dbid];
    [self.commandDelegate sendPluginResult: openResult
                                callbackId: commandInfo.callbackId];
  }
}

- (void) executeBatch: (CDVInvokedUrlCommand *) commandInfo
{
  NSArray * _args = commandInfo.arguments;

  const int connection_id = [(NSNumber *)[_args objectAtIndex: 0] intValue];

  NSArray * data = [_args objectAtIndex: 1];

  NSArray * results = [SQLiteBatchCore executeBatch: connection_id data: data];

  CDVPluginResult * batchResult =
    [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                       messageAsArray: results];

  [self.commandDelegate sendPluginResult: batchResult
                              callbackId: commandInfo.callbackId];
}

@end
