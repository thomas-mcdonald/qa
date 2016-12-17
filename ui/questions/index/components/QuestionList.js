import React, { Component } from 'react'

const QuestionCount = ({number, name}) =>
  <div className="qa-question-list-count">{number} <span>{name}</span></div>

const QuestionTag = ({children}) =>
  <span className="qa-question-list-tag pt-tag pt-minimal">{children}</span>

const Question = ({title}) => (
  <div className="pt-card qa-question-list-card">
    <div className="qa-question-list-counts">
      <QuestionCount number="8" name="votes" />
      <QuestionCount number="0" name="answers" />
      <QuestionCount number="80" name="views" />
    </div>
    <div className="qa-question-list-summary">
      <h3 className="qa-question-list-title">
        <a>{title}</a>
      </h3>
      <div className="qa-question-list-tags">
        <QuestionTag>meta</QuestionTag>
        <QuestionTag>question</QuestionTag>
        <QuestionTag>not-a-tag</QuestionTag>
      </div>
      <div className="qa-question-list-recent">
        answered by <a>Thomas McDonald</a> three hours ago
      </div>
    </div>
  </div>
)

class QuestionList extends Component {
  render() {
    return (
      <div>
        {this.props.questions.map((question, i) => <Question key={i} {...question} />)}
      </div>
    )
  }
}

export default QuestionList
