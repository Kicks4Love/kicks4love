CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     Rails.application.secrets.amazon_access_key_id,
    aws_secret_access_key: Rails.application.secrets.amazon_secret_access_key,
    region:                'us-west-2',
  }
  config.fog_directory  = 'kicks4love-test'
end
