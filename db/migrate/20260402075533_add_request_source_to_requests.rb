class AddRequestSourceToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :request_source, :string
  end
end
