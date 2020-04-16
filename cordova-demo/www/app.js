document.addEventListener('deviceready', onReady)

// based on some JavaScript code generated by generate-cordova-package
function log (text) {
  // log into the `messages` div:
  document.getElementById('messages').appendChild(document.createTextNode(text))
  document.getElementById('messages').appendChild(document.createElement('br'))
  // and to the console
  console.log(text)
}

const DATABASE_FILE_NAME = 'demo.db'

// SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
// ref: https://www.sqlite.org/c3ref/open.html
const OPEN_DATABASE_FLAGS = 6

function openFileDatabaseConnection (name, openCallback, errorCallback) {
  window.sqliteStorageFile.resolveAbsolutePath(
    {
      name: name,
      // TEMPORARY & DEPRECATED value, as needed for iOS & macOS ("osx"):
      location: 2
    },
    function (path) {
      log('database file path: ' + path)

      window.openDatabaseConnection(
        path,
        OPEN_DATABASE_FLAGS,
        openCallback,
        errorCallback
      )
    }
  )
}

function onReady () {
  log('deviceready event received')

  // for SQLite database file:
  openFileDatabaseConnection(DATABASE_FILE_NAME, openCallback, function (
    error
  ) {
    log('UNEXPECTED OPEN ERROR: ' + error)
  })
}

function openCallback (connectionId) {
  log('open connection id: ' + connectionId)

  // ERROR TEST - file name with incorrect flags:
  window.openDatabaseConnection(
    'dummy.db',
    0,
    function (_ignored) {
      log('FAILURE - unexpected open success callback received')
    },
    function (e) {
      log('OK - received error callback as expected for incorrect open call')

      // CONTINUE with batch demo, with the correct connectionId:
      batchDemo(connectionId)
    }
  )
}

function batchDemo (connectionId) {
  log('starting batch demo for connection id: ' + connectionId)
  window.executeBatch(
    connectionId,
    [
      ['SELECT ?, -?, LOWER(?), UPPER(?)', [null, 123.456789, 'ABC', 'Text']],
      ['SLCT 1', []],
      ['SELECT ?', ['OK', 'out of bounds parameter']],
      ['DROP TABLE IF EXISTS Testing', []],
      ['CREATE TABLE Testing (data NOT NULL)', []],
      ["INSERT INTO Testing VALUES ('test data')", []],
      ['INSERT INTO Testing VALUES (null)', []],
      ['DELETE FROM Testing', []],
      ["INSERT INTO Testing VALUES ('test data 2')", []],
      ["INSERT INTO Testing VALUES ('test data 3')", []],
      ['SELECT * FROM Testing', []],
      ["SELECT 'xyz'", []]
    ],
    batchCallback
  )
}

function batchCallback (batchResults) {
  // show batch results in JSON string format (on all platforms)
  log('received batch results')
  log(JSON.stringify(batchResults))

  startReaderDemo()
}

function startReaderDemo () {
  openFileDatabaseConnection(
    DATABASE_FILE_NAME,
    function (id) {
      log('read from another connection id: ' + id)

      window.executeBatch(id, [['SELECT * FROM Testing', []]], function (res) {
        log(JSON.stringify(res))
      })
    },
    function (error) {
      log('UNEXPECTED OPEN ERROR: ' + error)
    }
  )
}
