require 'test_helper'

class LineTest < ActiveSupport::TestCase
  def setup
      @line = Line.new(RouteNo: "Line 1", 
                       Direction: "NORTH",
                       Destination: "home")
      @invalid = Line.new( Direction: "NORTH",
                           Destination: "home")
  end

  test "save duplicate line" do
      assert_difference ['Line.count'] do
        @line.save
      end
      duplicate_line = @line.dup
      assert_no_difference ['Line.count'] do
        duplicate_line.save
      end
  end

  test 'save almost duplicate line' do
      assert_difference ['Line.count'] do
        @line.save
      end
      line2 = Line.new(RouteNo: "Line 1",
                       Direction: "SOUTH",
                       Destination: "home")
      assert_difference ['Line.count'] do
        line2.save
      end
  end

  test 'save invalid' do
      assert_no_difference ['Line.count'] do
        @invalid.save
      end
  end

end
