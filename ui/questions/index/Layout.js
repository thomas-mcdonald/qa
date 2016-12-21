import React, { Component } from 'react'

import { Tab, Tabs, TabList, TabPanel } from '@blueprintjs/core'

import QuestionsTabPanel from './components/QuestionsTabPanel'

class Layout extends Component {
  constructor(props) {
    super(props)
    this.props.onLoad('newest')
    this.tabs = ['newest', 'activity', 'votes']
    this.onTabChange = (tabIndex) => {
      this.props.onLoad(this.tabs[tabIndex])
    }
  }

  render() {
    const { questions } = this.props
    return (
      <div id="page-wrap">
        <div id="body">
          <h1>Recent Questions</h1>
          <Tabs onChange={this.onTabChange}>
            <TabList>
              {this.tabs.map((tab, index) => <Tab key={index}>{tab}</Tab>)}
            </TabList>
            {this.tabs.map((tab, index) => (
              <TabPanel key={index}>
               <QuestionsTabPanel questions={questions} />
             </TabPanel>
            ))}
          </Tabs>
        </div>
      </div>
    )
  }
}

export default Layout
