package com.demo;

import io.sqlc.SQLiteBatchCore;

import org.apache.cordova.*;

import org.json.*;

public class SQLiteDemoPlugin extends CordovaPlugin {
  @Override
  public boolean execute(String method, JSONArray data, CallbackContext cbc) {
    switch(method) {
      case "openDatabaseConnection":
        openDatabaseConnection(data, cbc);
        break;
      case "executeBatch":
        executeBatch(data, cbc);
        break;
      default:
        return false;
    }
    return true;
  }

  static private void
  openDatabaseConnection(JSONArray args, CallbackContext cbc) {
    SQLiteBatchCore.openDatabaseConnection(args, new SQLiteBatchCore.OpenCallbacks() {
      public void success(int connectionId) {
        cbc.success(connectionId);
      }
      public void error(String message) {
        cbc.error(message);
      }
    });
  }

  static private void executeBatch(JSONArray args, CallbackContext cbc) {
    SQLiteBatchCore.executeBatch(args, new SQLiteBatchCore.ExecuteBatchCallbacks() {
      public void success(JSONArray results) {
        cbc.success(results);
      }
      public void error(String message) {
        cbc.error(message);
      }
    });
  }
}
