class UploadService
  def self.upload_image(file)
    response = RestClient.post("#{Settings.nacx.base_url}/upload",
                    { image: file },
                    { content_type: 'multipart/form-data', accept: :json })
    json_body = JSON.parse(response.body)
    json_body['url']
  end
end
