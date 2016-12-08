import React from 'react';

const Infobox = ({asked, display_name, gravatar, reputation, user_link}) => (
  <div className="qa-user-info">
    <p className="asked">{asked}</p>
    <img src={gravatar} />
    <div className="user-details">
      <a href={user_link}>{display_name}</a>
      <span>{reputation}</span>
    </div>
  </div>
)

export default Infobox;
