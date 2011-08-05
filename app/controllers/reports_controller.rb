class ReportsController < ApplicationController
  require 'csv'
  def csvusers
    if params[:pass] == "pokerlol"
      @users = User.all

      csv_string = CSV.generate do |csv|
        csv << ["Name", "School","Join Date" ]

        @users.each do |record|
          csv << [record.name,
                  record.school_id,
                  record.created_at.to_date]
        end
      end

      filename = "userdump.csv"
      send_data(csv_string,
        :type => 'text/csv; charset=utf-8; header=present',
        :filename => filename)
      end
    end
    
    def csvcourses
      if params[:pass] == "pokerlol"
        @courses = Course.all

        csv_string = CSV.generate do |csv|
          csv << ["Name", "School","Join Date", "Schedules" ]

          @courses.each do |record|
            csv << [record.name,
                    record.school_id,
                    record.created_at, record.schedules.count]
          end
        end

        filename = "userdump.csv"
        send_data(csv_string,
          :type => 'text/csv; charset=utf-8; header=present',
          :filename => filename)
        end
      end
end
