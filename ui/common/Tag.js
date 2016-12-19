import React from 'react'
import classnames from 'classnames'

const Tag = ({className, link, name}) => {
  const tagClassName = classnames(className, 'pt-tag', 'pt-minimal')
  return <a className={tagClassName} href={link}>{name}</a>
}

export default Tag
