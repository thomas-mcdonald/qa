const initialState = {
  store: [],
  loading: true
}

const questions = (state = initialState, action) => {
  switch(action.type) {
    case 'REQUEST_QUESTIONS':
      if (action.status == 'SUCCESS') {
        return {
          store: action.payload,
          loading: false
        }
      } else {
        return {...state, loading: true}
      }
    default:
      return state
  }
}

export default questions
