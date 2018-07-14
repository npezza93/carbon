data = {
  state: '/home/johnlennon/walrus.png',
}

Buffer.from("hello").toString("base64")

needle('post', 'https://carbon.now.sh/images', data)
  .then((response) ->
    return doSomethingWith(response)
  )
  .catch((err) ->
    console.log('Call the locksmith!')
  )
