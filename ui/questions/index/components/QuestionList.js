import React, { Component } from 'react'
import distanceInWordsToNow from 'date-fns/distance_in_words_to_now'

import Tag from '../../../common/Tag'

const QuestionCount = ({number, name}) =>
  <div className="qa-question-list-count">{number} <span>{name}</span></div>

const QuestionTag = (tag) => <Tag className="qa-question-list-tag" {...tag} />

const QuestionActivity = ({date, name, profile_link, reputation}) => {
  const time = distanceInWordsToNow(date)
  // TODO: live update relative time, include absolute on hoverover
  return (
    <div className="qa-question-list-recent">
      {time} ago by <a href={profile_link}>{name}</a> <strong>{reputation}</strong>
    </div>
  )
}

const Question = ({answers_count, last_active_at, last_active_user,
                    question_link, tags, title, view_count, vote_count}) => (
  <div className="pt-card qa-question-list-card">
    <div className="qa-question-list-counts">
      <QuestionCount number={vote_count} name="votes" />
      <QuestionCount number={answers_count} name="answers" />
      <QuestionCount number={view_count} name="views" />
    </div>
    <div className="qa-question-list-summary">
      <h3 className="qa-question-list-title">
        <a href={question_link}>{title}</a>
      </h3>
      <div className="qa-question-list-tags">
        {tags.map((tag, index) => <QuestionTag key={index} {...tag} />)}
      </div>
      <QuestionActivity date={last_active_at} {...last_active_user} />
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
