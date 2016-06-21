require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
    include SessionsHelper
  # test "the truth" do
  #   assert true
  # end
  test "login with invalid information" do
        get login_path
        assert_template 'sessions/new'
        post login_path, session: { email: "", password: "" }
        assert_template 'sessions/new'
        assert_not flash.empty?
  end

  test "redirect after login" do
      get signup_path
      post users_path, user: { email: "test@test.com",
                               password: "simplepass",
                               password_confirmation: "simplepass" }
      delete logout_path
      get login_path
      post login_path, session: { email: "test@test.com", password: "simplepass" }

      assert flash.empty?
      assert logged_in?
  end
      
end
