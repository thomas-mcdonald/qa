import React, { Component } from 'react'

import { Tab, Tabs, TabList, TabPanel } from '@blueprintjs/core'

import QuestionsTabPanel from './components/QuestionsTabPanel'

class Layout extends Component {
  constructor(props) {
    super(props)

    this.state = ({
      openTab: 0
    })
    this.props.onLoad('newest')
    this.tabs = ['newest', 'activity', 'votes']
    this.onTabChange = (tabIndex) => {
      const tab = this.tabs[tabIndex]
      this.props.onLoad(tab)
      this.setState({ openTab: tabIndex })
    }
  }

  render() {
    const { loading, questions } = this.props
    return (
      <div id="page-wrap">
        <div id="body">
          <h1>Recent Questions</h1>
          <Tabs onChange={this.onTabChange} selectedTabIndex={this.state.openTab}>
            <TabList>
              {this.tabs.map((tab, index) => <Tab key={index}>{tab}</Tab>)}
            </TabList>
            {this.tabs.map((tab, index) => (
              <TabPanel key={index}>
               <QuestionsTabPanel loading={loading} questions={questions} />
             </TabPanel>
            ))}
          </Tabs>
        </div>
      </div>
    )
  }
}

export default Layout
