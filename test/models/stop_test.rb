require 'test_helper'

class StopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
      @valid = Stop.new(Name: "Stop 1", 
                       StopNo: "12345", 
                       Latitude: "48.123456", 
                       Longitude: "-122.123456",
                       City: "London",
                       AtStreet: "234234",
                       OnStreet: "234234",
                       Routes: "12, 512, 1, ASDASD")
      @invalid1 = Stop.new(Name: "Stop 2", 
                       Latitude: "48.123456", 
                       Longitude: "-122.123456",
                       City: "London",
                       AtStreet: "234234",
                       OnStreet: "234234",
                       Routes: "12, 512, 1, ASDASD")
      @invalid2 = Stop.new(Name: "Stop 3", 
                       StopNo: 1213,
                       Latitude: "48.123456", 
                       Longitude: "-122.123456",
                       City: "London",
                       AtStreet: "234234",
                       OnStreet: "234234")
  end

  test "save duplicate stop" do
      assert_difference ['Stop.count'] do
        @valid.save
      end
      duplicate_stop = @valid.dup
      assert_no_difference ['Stop.count'] do
        duplicate_stop.save
      end
  end

  test "save invalid stop1" do
      assert_no_difference ['Stop.count'] do
          @invalid1.save
      end
  end
  test "save invalid stop2" do
      assert_no_difference ['Stop.count'] do
          @invalid2.save
      end
  end

end
