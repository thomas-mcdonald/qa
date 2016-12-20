// Application polyfills. If adding a file here, make a note as to why it is required

// PhantomJS polyfills
import 'core-js/fn/array/from'
import Promise from 'promise-polyfill'

if (!window.Promise) {
  window.Promise = Promise;
}

import 'whatwg-fetch'
