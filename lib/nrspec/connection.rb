require 'firebase'

module Nrspec
  class Connection
    BASE_URI = 'https://nrspec-d14ce.firebaseio.com/'
    TABLE_NAME = 'rspec_files'

    def initialize
      @firebase = Firebase::Client.new(BASE_URI)
    end

    def get(id = nil)
      firebase.get(resource_path(id))
    end

    def create(resource:)
      resource.merge!({
        updated_at: current_timestamp,
        created_at: current_timestamp
      })

      firebase.push(resource_path, resource)
    end

    def update(id:, resource:)
      resource.merge!({
        updated_at: current_timestamp
      })

      firebase.update(resource_path(id: id), resource)
    end

    private

    attr_accessor :firebase

    def resource_path(id = nil)
      [TABLE_NAME, id].compact.join('/')
    end

    def current_timestamp
      Firebase::ServerValue::TIMESTAMP
    end
  end
end
