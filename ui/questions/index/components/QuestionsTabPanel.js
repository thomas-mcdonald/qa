import React, { Component } from 'react'
import { NonIdealState, Spinner } from '@blueprintjs/core'

import QuestionList from './QuestionList'

class QuestionsTabPanel extends Component {
  renderLoading() {
    const spinner = <Spinner className="pt-large" />
    return <NonIdealState visual={spinner} />
  }

  render() {
    const { loading, questions } = this.props
    if (loading) {
      return this.renderLoading()
    } else {
      return (
        <div>
          <QuestionList questions={questions} />
          <a href="/questions">view more questions</a>
        </div>
      )
    }
  }
}

export default QuestionsTabPanel
