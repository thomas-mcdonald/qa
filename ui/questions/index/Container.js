import { connect } from 'react-redux'

import { fetchQuestions } from '../actions'
import Layout from './Layout'

const mapStateToProps = (state) => ({
  questions: state.questions.store,
  loading: state.questions.loading
})

const mapDispatchToProps = (dispatch) => ({
  onLoad: (tab) => { dispatch(fetchQuestions(tab)) }
})

export default connect(mapStateToProps, mapDispatchToProps)(Layout)
