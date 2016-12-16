import React from 'react'
import ReactDOM from 'react-dom'

import './polyfills'

import Infobox from './Infobox'

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
