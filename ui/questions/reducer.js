const initialState = []

const questions = (state = initialState, action) => {
  switch(action.type) {
    case 'REQUEST_QUESTIONS':
      if (action.status == 'SUCCESS') {
        console.log(action.payload)
        return action.payload
      } else {
        return state
      }
    default:
      return state
  }
}

export default questions;
