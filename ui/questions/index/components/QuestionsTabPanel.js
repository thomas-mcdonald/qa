import React, { Component } from 'react'

import QuestionList from './QuestionList'

class QuestionsTabPanel extends Component {
  render() {
    const { questions } = this.props
    return (
      <div>
        <QuestionList questions={questions} />
        <a href="/questions">view more questions</a>
      </div>
    )
  }
}

export default QuestionsTabPanel
