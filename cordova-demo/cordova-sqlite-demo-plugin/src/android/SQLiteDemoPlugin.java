package com.demo;

import io.sqlc.SQLiteBatchCore;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;

import org.json.JSONArray;
import org.json.JSONObject;

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
    try {
      final JSONObject options = args.getJSONObject(0);

      final String pathname = options.getString("path");

      final int flags = options.getInt("flags");

      SQLiteBatchCore.openBatchConnection(pathname, flags, new SQLiteBatchCore.OpenCallbacks() {
        public void success(int connectionId) {
          cbc.success(connectionId);
        }
        public void error(String message) {
          cbc.error(message);
        }
      });
    } catch(Exception e) {
      // NOT EXPECTED - internal error:
      cbc.error(e.toString());
    }
  }

  static private void executeBatch(JSONArray args, CallbackContext cbc) {
    try {
      final int mydbc = args.getInt(0);

      JSONArray data = args.getJSONArray(1);

      SQLiteBatchCore.executeBatch(mydbc, data, new SQLiteBatchCore.ExecuteBatchCallbacks() {
        public void success(JSONArray results) {
          cbc.success(results);
        }
        public void error(String message) {
          cbc.error(message);
        }
      });
    } catch(Exception e) {
      // NOT EXPECTED - internal error:
      cbc.error(e.toString());
    }
  }
}
