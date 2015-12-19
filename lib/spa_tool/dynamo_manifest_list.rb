require 'aws-sdk'
require 'pry-byebug'

class DynamoManifestList

  MANIFEST_ATTRIBUTE_NAME = "manifest_files"
  PARTITION_KEY_VALUE = "standard"

  attr_accessor :client, :table_name

  def initialize(table_name, region)
    credentials = Aws::Credentials.new(ENV['ARTIFACTS_KEY'], ENV['ARTIFACTS_SECRET'])

    Aws.config.update(region: region, credentials: credentials)

    self.client= Aws::DynamoDB::Client.new(region: region)
    self.table_name = table_name
  end

  def put(manifest_list)
    client.put_item(
      table_name: table_name,
      item: {
        id: PARTITION_KEY_VALUE,
        created_at: Time.now.to_i,
        MANIFEST_ATTRIBUTE_NAME => manifest_list
      }
    )
  end

  def get_latest
    get.items.first[MANIFEST_ATTRIBUTE_NAME]
  end

  def get_latest_created_at
    Time.at(get.items.first['created_at'])
  end

  private

  def get
    client.query({
      table_name: table_name,
      select: "ALL_ATTRIBUTES",
      consistent_read: true,
      scan_index_forward: false,
      limit: 1,
      key_conditions: {
        "id" => {
          attribute_value_list: [PARTITION_KEY_VALUE],
          comparison_operator: "EQ"
        }
      }
    })
  end

end
