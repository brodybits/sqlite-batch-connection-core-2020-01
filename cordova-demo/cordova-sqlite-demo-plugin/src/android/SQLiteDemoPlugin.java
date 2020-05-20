package com.demo;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

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

      final String fullName = options.getString("fullName");

      final int flags = options.getInt("flags");

      final int mydbc = SQLiteBatchCore.openBatchConnection(fullName, flags);

      if (mydbc < 0) {
        cbc.error("open error: " + -mydbc);
      } else {
        cbc.success(mydbc);
      }
    } catch(Exception e) {
      // NOT EXPECTED - internal error:
      cbc.error(e.toString());
    }
  }

  static private void executeBatch(JSONArray args, CallbackContext cbc) {
    try {
      final int mydbc = args.getInt(0);

      JSONArray data = args.getJSONArray(1);

      threadPool.execute(new Runnable() {
        public void run() {
          executeBatchNow(mydbc, data, cbc);
        }
      });
    } catch(Exception e) {
      // NOT EXPECTED - internal error:
      cbc.error(e.toString());
    }
  }

  static private void
  executeBatchNow(final int mydbc, JSONArray data, CallbackContext cbc) {
    try {
      JSONArray results = SQLiteBatchCore.executeBatch(mydbc, data);

      cbc.success(results);
    } catch(Exception e) {
      // NOT EXPECTED - internal error:
      cbc.error(e.toString());
    }
  }

  static {
    threadPool = Executors.newCachedThreadPool();
  }

  // This is really an instance of ExecutorService,
  // but only execute from Executor is needed here.
  static private Executor threadPool;
}
