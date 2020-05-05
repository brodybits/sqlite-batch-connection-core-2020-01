function openDatabaseConnection (options, cb, errorCallback) {
  cordova.exec(cb, errorCallback, 'SQLiteDemoPlugin', 'openDatabaseConnection', [
    options
  ])
}

function executeBatch (connectionId, batchList, cb) {
  cordova.exec(cb, null, 'SQLiteDemoPlugin', 'executeBatch', [
    connectionId,
    batchList
  ])
}

window.sqliteBatchConnection = {
  openDatabaseConnection: openDatabaseConnection,
  executeBatch: executeBatch
}
