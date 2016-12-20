export const getQuestions = () => {
  return fetch('/questions.json')
    .then(response => {
      if (response.ok) {
        return response.json()
      } else {
        throw response
      }
    })
}
