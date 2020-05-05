#import <Cordova/CDVPlugin.h>

#import "SQLiteBatchCore.h"

@interface SQLiteDemoPlugin : CDVPlugin

- (void) openDatabaseConnection: (CDVInvokedUrlCommand *) commandInfo;

- (void) executeBatch: (CDVInvokedUrlCommand *) commandInfo;

@end

@implementation SQLiteDemoPlugin

- (void) openDatabaseConnection: (CDVInvokedUrlCommand *) commandInfo
{
  [SQLiteBatchCore openDatabaseConnection: commandInfo.arguments
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
  [SQLiteBatchCore executeBatch: commandInfo.arguments success: ^(NSArray * results) {
  CDVPluginResult * batchResult =
    [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                       messageAsArray: results];

  [self.commandDelegate sendPluginResult: batchResult
                              callbackId: commandInfo.callbackId];
  }];
}

@end
