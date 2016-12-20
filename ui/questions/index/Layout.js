import React, { Component } from 'react'

import { Tab, Tabs, TabList, TabPanel } from '@blueprintjs/core'

import QuestionList from './components/QuestionList'

class Layout extends Component {
  constructor(props) {
    super(props)
    this.props.onLoad()
  }

  render() {
    return (
      <div id="page-wrap">
        <div id="body">
          <h1>Recent Questions</h1>
          <Tabs>
            <TabList>
              <Tab>newest</Tab>
              <Tab>activity</Tab>
              <Tab>votes</Tab>
            </TabList>
            <TabPanel>
              <QuestionList questions={this.props.questions} />
              <a href="/questions">view more questions</a>
            </TabPanel>
            <TabPanel>activity</TabPanel>
            <TabPanel>votes</TabPanel>
          </Tabs>
        </div>
      </div>
    )
  }
}

export default Layout
