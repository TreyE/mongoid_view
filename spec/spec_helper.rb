require "bundler/setup"
require "mongoid_view"

# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV["MONGOID_SPEC_HOST"] ||= "127.0.0.1"
ENV["MONGOID_SPEC_PORT"] ||= "27017"

# These are used when creating any connection in the test suite.
HOST = ENV["MONGOID_SPEC_HOST"]
PORT = ENV["MONGOID_SPEC_PORT"].to_i

MONGOID_ROOT_USER = Mongo::Auth::User.new(
  database: Mongo::Database::ADMIN,
  user: 'mongoid-user',
  password: 'password',
  roles: [
    Mongo::Auth::Roles::USER_ADMIN_ANY_DATABASE,
    Mongo::Auth::Roles::DATABASE_ADMIN_ANY_DATABASE,
    Mongo::Auth::Roles::READ_WRITE_ANY_DATABASE,
    Mongo::Auth::Roles::HOST_MANAGER,
    Mongo::Auth::Roles::CLUSTER_MONITOR
  ]
)

CONFIG = {
  clients: {
    default: {
      database: "mongoid_view_test_db",
      hosts: [ "#{HOST}:#{PORT}" ],
      options: {
        server_selection_timeout: 0.5,
        max_pool_size: 5,
        heartbeat_frequency: 180,
        user: MONGOID_ROOT_USER.name,
        password: MONGOID_ROOT_USER.password,
        auth_source: Mongo::Database::ADMIN,
      }
    }
  }
}

Mongoid.configure do |config|
  config.load_configuration(CONFIG)
end

client = Mongo::Client.new(["#{HOST}:#{PORT}"])
begin
  # Create the root user administrator as the first user to be added to the
  # database. This user will need to be authenticated in order to add any
  # more users to any other databases.
  client.database.users.create(MONGOID_ROOT_USER)
rescue Exception => e
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
