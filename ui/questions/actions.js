import { getQuestions } from './queries'

export const requestQuestions = () => ({
  type: 'REQUEST_QUESTIONS',
  status: 'IN_PROGRESS'
})

export const receiveQuestions = (questions) => ({
  type: 'REQUEST_QUESTIONS',
  status: 'SUCCESS',
  payload: questions
})

export const fetchQuestions = () => (dispatch) => {
  dispatch(requestQuestions)
  getQuestions()
    .then(questions => dispatch(receiveQuestions(questions)))
}
