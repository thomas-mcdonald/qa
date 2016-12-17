import React, { Component } from 'react'
import { Tab, Tabs, TabList, TabPanel } from '@blueprintjs/core'

import QuestionList from './components/QuestionList'

class Container extends Component {
  render() {
    let questions = [{title: 'What a question'}, {title: 'How do I'}]
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
            <TabPanel><QuestionList questions={questions} /></TabPanel>
            <TabPanel>activity</TabPanel>
            <TabPanel>votes</TabPanel>
          </Tabs>
        </div>
      </div>
    )
  }
}

export default Container;
