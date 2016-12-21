import { getQuestions } from './queries'

export const requestQuestions = (tab) => ({
  type: 'REQUEST_QUESTIONS',
  status: 'IN_PROGRESS',
  meta: {
    tab: tab
  }
})

export const receiveQuestions = (tab, questions) => ({
  type: 'REQUEST_QUESTIONS',
  status: 'SUCCESS',
  payload: questions,
  meta: {
    tab: tab
  }
})

export const fetchQuestions = (tab) => (dispatch) => {
  dispatch(requestQuestions(tab))
  getQuestions(tab)
    .then(questions => dispatch(receiveQuestions(tab, questions)))
}
