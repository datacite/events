# frozen_string_literal: true

# Patch DatabaseTasks for nulldb to prevent schema loading attempts
if Rails.env.test? && defined?(ActiveRecord::Tasks::DatabaseTasks)
  # module ActiveRecord
  #   module Tasks
  #     class NullDBDatabaseTasks
  #       def load_schema(*)
  #         # no-op
  #       end
  #     end
  #   end
  # end
  module ActiveRecord
    module Tasks
      class NullDBDatabaseTasks
        def load_schema(*)
          # no-op
        end
      end
    end
  end

  ActiveRecord::Tasks::DatabaseTasks.register_task(/nulldb/, ActiveRecord::Tasks::NullDBDatabaseTasks)
end

# if Rails.env.test?
#   module ActiveRecord
#     class Migration
#       class << self
#         def check_pending!; end
#       end
#     end
#   end
# end

module ActiveRecord
  class Migration
    class << self
      def check_pending!; end
    end
  end
end
