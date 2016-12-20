import { connect } from 'react-redux'

import { fetchQuestions } from '../actions'
import Layout from './Layout'

const mapStateToProps = (state) => ({
  questions: state
})

const mapDispatchToProps = (dispatch) => ({
  onLoad: () => { dispatch(fetchQuestions()) }
})

export default connect(mapStateToProps, mapDispatchToProps)(Layout)
