class RandomService
  def self.random_number(size)
    response = RestClient.get('https://qrng.anu.edu.au/API/jsonI.php?length=1&type=uint8')
    json_body = JSON.parse(response.body)
    ((json_body.dig('data', 0) / 256.0) * size).floor
  end
end
