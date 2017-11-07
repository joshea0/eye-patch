require "aws-sdk-core"
require "aws-sdk-core/ses"

module Eye
  class Notify
    class AWSSDK < Eye::Notify
      param :region, String
      param :access_key_id, String
      param :secret_access_key, String
      param :from, String, true

      def execute
        options = { region: "us-east-1" } # default to us-east-1
        options[:region] = region if region
        if access_key_id && secret_access_key
          options[:credentials] = Aws::Credentials.new(access_key_id, secret_access_key)
        end
        client = Aws::SES::Client.new(options)
        client.send_email(message)
      end

      def message
        { source: from,
          destination: {
            to_addresses: [contact]
          },
          message: {
            subject: {
              data: message_subject
            },
            body: {
              text: {
                data: message_body
              },
              html: {
                data: message_body
              }
            }
          }
        }
      end
    end
  end
end