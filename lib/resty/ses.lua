local aws  = require 'aws'
local http = require 'resty.http'

local payload = {
    ['Action'] = 'SendEmail',
    ['Source'] = 'hello@roompillow.com',
    ['Destination.ToAddress.member.1'] ='paragasu@gmail.com',
    ['Message.Subject.Data']   = 'Hello World',
    ['Message.Body.Text.Data'] = 'Hello There'
}

local config = {
  aws_key     = 'AKIAJRD4IKQHT6O6QSGQ',
  --aws_key     = 'AKIAJUR6PN33WMMZIRRA',
  aws_secret  = 'AjqZl4wYTyuuQDveeaFcwyCYKQHYaqUYzoFahwtzto8N',
  --aws_secret  = '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',
  aws_host    = 'email.us-east-1.amazonaws.com',
  aws_region  = 'us-east-1',
  aws_service = 'ses',
  request_body= payload
}
local inspect = require 'inspect'

aws:new(config)

local auth_header = aws:get_authorization_header()
local amz_date_header = aws:get_date_header()

print('Authorization: ' .. auth_header)
--print('Date: ' .. amz_date_header)

local httpc = http:new()
local res, err = httpc:request_uri('https://' .. config.aws_host, {
  method = 'POST',
  body = ngx.encode_args(payload),
  ssl_verify = false,
  headers = {
    ['Content-Type'] = 'application/x-www-form-urlencoded',
    ['Authorization'] = auth_header,
    ['X-Amz-Date'] = amz_date_header 
  }
})

if not res then
  ngx.say('Failed request', err)
end

ngx.say(res.body)
ngx.say('SES done')
