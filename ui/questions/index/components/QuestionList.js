import React, { Component } from 'react'

const QuestionCount = ({number, name}) =>
  <div className="qa-question-list-count">{number} <span>{name}</span></div>

const QuestionTag = ({children}) =>
  <span className="qa-question-list-tag pt-tag pt-minimal">{children}</span>

const Question = ({answers_count, title, view_count, vote_count}) => (
  <div className="pt-card qa-question-list-card">
    <div className="qa-question-list-counts">
      <QuestionCount number={vote_count} name="votes" />
      <QuestionCount number={answers_count} name="answers" />
      <QuestionCount number={view_count} name="views" />
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
        answered three hours ago <a>Thomas McDonald</a> <strong>4,123</strong>
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
