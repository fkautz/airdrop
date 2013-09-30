class CreateRunningServices < ActiveRecord::Migration
  def self.up
    create_table :running_services do |t|
      t.column :service, :string, :null => false
      t.column :container_id, :string, :null => false
    end
  end
end
