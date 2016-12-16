import React, { Component } from 'react'
import { Tab, Tabs, TabList, TabPanel } from '@blueprintjs/core'

class Container extends Component {
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
            <TabPanel>newest</TabPanel>
            <TabPanel>activity</TabPanel>
            <TabPanel>votes</TabPanel>
          </Tabs>
        </div>
      </div>
    )
  }
}

export default Container;
