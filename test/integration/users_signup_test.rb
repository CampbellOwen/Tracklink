require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
      get signup_path
      assert_no_difference 'User.count' do
          post users_path, user: { email: "hello@hello",
                                  password: "hello",
                                  password_confirmation: "nothello" }
      end
      assert_template 'users/new'
  end

  test "passwords not matching" do
      get signup_path
      assert_no_difference 'User.count' do
          post users_path, user: { email: "hello@hello.com",
                                  password:  "hello123",
                                  password_confirmation: "hello124" }
      end
      assert_template 'users/new'
  end

  test "Already existing account" do
      get signup_path
      assert_difference 'User.count' do
      post users_path, user: { email: "test@test.com",
                               password: "simplepass",
                               password_confirmation: "simplepass" }
      end
      get signup_path
      assert_no_difference 'User.count' do
          post users_path, user: { email: "test@test.com",
                                   password: "simplepass",
                                   password_confirmation: "simplepass" }
      end
  end

end
