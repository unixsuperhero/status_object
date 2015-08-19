class Car < ActiveRecord::Base
  include KeyValue::ActiveRecord

  key_value :report_status_id, :report_status, CarReportStatus
end

#
# Adds #report_status and #report_status=
# ---------------------------------------
#
# car = Car.first
# car.report_status_id     # => 3
#
# car.report_status.id     # => 3
# car.report_status.title  # => "Work Log"
# car.report_status.name   # => :work_log
#
#
# car.report_status = :completed
#
# car.report_status_id     # => 4
#
# car.report_status.id     # => 4
# car.report_status.title  # => "Completed"
#
# car.report_status = 2
# car.report_status.title  # => "Hands On"
#


