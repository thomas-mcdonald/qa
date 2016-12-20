import React, { Component } from 'react'

import { Menu, MenuDivider, MenuItem, Popover, Position } from '@blueprintjs/core'

class UserDropdown extends Component {
  renderPopover() {
    return (
      <Menu>
        <MenuItem text="Your profile" href={this.props.profile_link} />
        <MenuItem text="Edit profile" href={this.props.edit_link} />
        <MenuDivider />
        <form method="post" action="/logout">
          <input type="hidden" name="authenticity_token" value={this.props.csrf} />
          <li>
            <button className="pt-menu-item pt-popover-dismiss" type="submit" id="logout" value="Logout">Logout</button>
          </li>
        </form>
      </Menu>
    )
  }

  render() {
    return (
      <Popover className="user-dropdown" content={this.renderPopover()} position={Position.BOTTOM_RIGHT}>
        {this.props.display_name}
      </Popover>
    )
  }
}

export default UserDropdown
