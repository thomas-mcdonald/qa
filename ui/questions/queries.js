export const getQuestions = (tab) => {
  return fetch(`/questions.json?sort=${tab}`)
    .then(response => {
      if (response.ok) {
        return response.json()
      } else {
        throw response
      }
    })
}
