import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import { createStore } from 'redux'

import './polyfills'

import App from './App'
import Infobox from './Infobox'

// NOP for now
let store = createStore(() => {})

let rootApp = (
  <Provider store={store}>
    <App />
  </Provider>
)
let target = document.getElementById('root')

if (target != undefined) {
  ReactDOM.render(<App />, target);
}

// TODO: eventually remove all the below:
window.ReactDOM = ReactDOM

$(document).ready(() => {
  const elems = document.getElementsByClassName('react-user-info')
  Array.from(elems).forEach((elem) => {
    const asked = elem.getAttribute('data-asked')
    const display_name = elem.getAttribute('data-display-name')
    const gravatar = elem.getAttribute('data-gravatar')
    const reputation = elem.getAttribute('data-reputation')
    const user_link = elem.getAttribute('data-user-link')
    ReactDOM.render(<Infobox
      asked={asked}
      display_name={display_name}
      gravatar={gravatar}
      reputation={reputation}
      user_link={user_link} />, elem)
  })
})
